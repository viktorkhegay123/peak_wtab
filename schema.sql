-- Штаб FLL: схема базы для Supabase (версия 2: много команд).
-- Вставьте весь файл в SQL Editor и нажмите Run. Файл можно запускать повторно.
--
-- Если база уже работала по старой схеме (одна команда), все старые данные
-- переедут в команду «PEAK»: задачи, заезды, видео, Core Values, регистрации.
-- Новые участники находят команду по названию и подают заявку; капитан или ментор её принимает.
-- Перед запуском на рабочей базе сделайте копию: Table Editor → kv → Export → CSV.

create extension if not exists pgcrypto with schema extensions;

-- ---------- таблицы ----------
create table if not exists teams (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 60),
  code text not null unique,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);
alter table teams enable row level security;

create table if not exists profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  team_id uuid not null references teams(id) on delete cascade,
  joined_at timestamptz not null default now()
);
alter table profiles enable row level security;
create index if not exists profiles_team_idx on profiles(team_id);

create table if not exists staff_emails (email text primary key);
alter table staff_emails add column if not exists team_id uuid references teams(id) on delete cascade;
alter table staff_emails enable row level security;   -- без политик: снаружи не читается

create table if not exists kv (
  team uuid not null references teams(id) on delete cascade,
  coll text not null,
  id text not null,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (team, coll, id)
);
alter table kv add column if not exists team uuid references teams(id) on delete cascade;
alter table kv enable row level security;

-- ---------- служебные функции ----------
create or replace function my_team() returns uuid
language sql stable security definer set search_path = public as
$$ select team_id from profiles where user_id = auth.uid() $$;

-- код приглашения: 8 символов без похожих букв (0/O, 1/I), например K7QM2XWD
create or replace function gen_team_code() returns text
language plpgsql volatile security definer set search_path = public as $$
declare
  alphabet constant text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  c text; b bytea; i int;
begin
  loop
    b := extensions.gen_random_bytes(8);
    c := '';
    for i in 0..7 loop
      c := c || substr(alphabet, 1 + (get_byte(b, i) % 32), 1);
    end loop;
    exit when not exists (select 1 from teams where code = c);
  end loop;
  return c;
end $$;
revoke all on function gen_team_code() from public, anon, authenticated;

-- ---------- перенос старых данных в команду PEAK ----------
do $$
declare t uuid; cb uuid;
begin
  if exists (select 1 from kv where team is null) or exists (select 1 from staff_emails where team_id is null) then
    select id into t from teams where name = 'PEAK' order by created_at limit 1;
    if t is null then
      insert into teams (name, code) values ('PEAK', gen_team_code()) returning id into t;
    end if;
    update kv set team = t where team is null;
    update staff_emails set team_id = t where team_id is null;
    -- все, кто был зарегистрирован, остаются в команде
    insert into profiles (user_id, team_id)
      select u.id, t from kv k join auth.users u on u.id::text = k.id
      where k.team = t and k.coll = 'members'
      on conflict (user_id) do nothing;
    -- создателем команды считаем капитана (или ментора)
    select u.id into cb from kv k join auth.users u on u.id::text = k.id
      where k.team = t and k.coll = 'members' and k.data->>'role' in ('cap','mentor')
      order by (k.data->>'role') = 'cap' desc, k.updated_at limit 1;
    update teams set created_by = coalesce(created_by, cb) where id = t;
  end if;
end $$;

alter table kv alter column team set not null;
alter table kv alter column team set default public.my_team();

do $$
begin
  if not exists (
    select 1 from pg_index i
    join pg_attribute a on a.attrelid = i.indrelid and a.attnum = any(i.indkey)
    where i.indrelid = 'public.kv'::regclass and i.indisprimary and a.attname = 'team'
  ) then
    alter table kv drop constraint if exists kv_pkey;
    alter table kv add constraint kv_pkey primary key (team, coll, id);
  end if;
end $$;

-- ---------- роли ----------
create or replace function me_role() returns text
language sql stable security definer set search_path = public as
$$ select data->>'role' from kv where team = my_team() and coll = 'members' and id = auth.uid()::text $$;

create or replace function is_member() returns boolean
language sql stable security definer set search_path = public as
$$ select coalesce(me_role() in ('build','code','eng','pm','design','cap','mentor'), false) $$;

create or replace function is_staff() returns boolean
language sql stable security definer set search_path = public as
$$ select coalesce(me_role() in ('cap','mentor'), false) $$;

-- выбрать роль капитана/ментора при регистрации может создатель команды
-- или почта из staff_emails этой команды; остальных назначает капитан или ментор
create or replace function can_be_staff() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from teams where id = my_team() and created_by = auth.uid())
      or exists (select 1 from staff_emails where team_id = my_team()
                 and lower(email) = lower(coalesce(auth.jwt()->>'email','')))
$$;

-- ---------- права на данные: каждая команда видит только своё ----------
drop policy if exists teams_select on teams;
create policy teams_select on teams for select to authenticated using (id = my_team());

drop policy if exists profiles_select on profiles;
create policy profiles_select on profiles for select to authenticated using (user_id = auth.uid());

drop policy if exists kv_select on kv;
create policy kv_select on kv for select to authenticated using (team = my_team());

drop policy if exists kv_insert on kv;
create policy kv_insert on kv for insert to authenticated with check (
  team = my_team() and (
    (coll = 'tasks' and is_staff())
    or (coll in ('tstatus','settings') and is_member())
    or (coll in ('runs','cv') and is_member() and data->>'uid' = auth.uid()::text)
    or (coll = 'members' and id = auth.uid()::text
        and data->>'role' in ('build','code','eng','pm','design','cap','mentor')
        and (data->>'role' not in ('cap','mentor') or can_be_staff()))
  )
);

drop policy if exists kv_update on kv;
create policy kv_update on kv for update to authenticated
using (
  team = my_team() and (
    (coll = 'tasks' and is_staff())
    or (coll in ('tstatus','settings','runs') and is_member())
    or (coll = 'cv' and (is_staff() or (is_member() and data->>'uid' = auth.uid()::text)))
    or (coll = 'members' and is_staff())
  )
) with check (
  team = my_team() and (
    (coll = 'tasks' and is_staff())
    or (coll in ('tstatus','settings','runs') and is_member())
    or (coll = 'cv' and (is_staff() or (is_member() and data->>'uid' = auth.uid()::text)))
    or (coll = 'members' and is_staff())
  )
);

-- удалять чужие заезды и записи Core Values может только капитан или ментор
drop policy if exists kv_delete on kv;
create policy kv_delete on kv for delete to authenticated using (
  team = my_team() and (
    (coll in ('tasks','tstatus','members') and is_staff())
    or (coll = 'settings' and is_member())
    or (coll in ('runs','cv') and (is_staff() or (is_member() and data->>'uid' = auth.uid()::text)))
  )
);

-- ---------- команды: создать, вступить, выйти ----------
create or replace function create_team(p_name text) returns jsonb
language plpgsql security definer set search_path = public as $$
declare t teams; n text := btrim(coalesce(p_name, ''));
begin
  if auth.uid() is null then raise exception 'not_signed_in'; end if;
  if char_length(n) < 2 or char_length(n) > 60 then raise exception 'bad_name'; end if;
  if exists (select 1 from profiles where user_id = auth.uid()) then raise exception 'already_in_team'; end if;
  if (select count(*) from teams where created_by = auth.uid()) >= 5 then raise exception 'too_many_teams'; end if;
  if exists (select 1 from teams where lower(name) = lower(n)) then raise exception 'name_taken'; end if;
  insert into teams (name, code, created_by) values (n, gen_team_code(), auth.uid()) returning * into t;
  insert into profiles (user_id, team_id) values (auth.uid(), t.id);
  delete from join_requests where user_id = auth.uid();
  return jsonb_build_object('id', t.id, 'name', t.name, 'code', t.code, 'owner', true);
end $$;

create or replace function join_team(p_code text) returns jsonb
language plpgsql security definer set search_path = public as $$
declare t teams; cur uuid;
  c text := upper(regexp_replace(coalesce(p_code, ''), '[^A-Za-z0-9]', '', 'g'));
begin
  if auth.uid() is null then raise exception 'not_signed_in'; end if;
  select * into t from teams where code = c;
  if t.id is null then
    perform pg_sleep(0.4);   -- замедляем перебор кодов
    raise exception 'bad_code';
  end if;
  select team_id into cur from profiles where user_id = auth.uid();
  if cur is not null and cur <> t.id then raise exception 'already_in_team'; end if;
  insert into profiles (user_id, team_id) values (auth.uid(), t.id) on conflict (user_id) do nothing;
  return jsonb_build_object('id', t.id, 'name', t.name, 'code', t.code, 'owner', coalesce(t.created_by = auth.uid(), false));
end $$;

create or replace function team_info() returns jsonb
language sql stable security definer set search_path = public as $$
  select jsonb_build_object('id', t.id, 'name', t.name, 'code', t.code, 'owner', coalesce(t.created_by = auth.uid(), false))
  from teams t where t.id = my_team()
$$;

-- выйти из команды: данные команды остаются, удаляется только ваша регистрация
create or replace function leave_team() returns void
language plpgsql security definer set search_path = public as $$
declare t uuid := my_team();
begin
  if t is null then return; end if;
  delete from kv where team = t and coll = 'members' and id = auth.uid()::text;
  delete from profiles where user_id = auth.uid();
end $$;

create or replace function regen_team_code() returns text
language plpgsql security definer set search_path = public as $$
declare c text;
begin
  if not is_staff() then raise exception 'not_allowed'; end if;
  c := gen_team_code();
  update teams set code = c where id = my_team();
  return c;
end $$;

create or replace function remove_member(p_user uuid) returns void
language plpgsql security definer set search_path = public as $$
declare t uuid := my_team();
begin
  if not is_staff() then raise exception 'not_allowed'; end if;
  if p_user = auth.uid() then raise exception 'not_self'; end if;
  delete from kv where team = t and coll = 'members' and id = p_user::text;
  delete from profiles where user_id = p_user and team_id = t;
end $$;

-- ---------- списки миссий и чек-листа: добавление без затирания чужих правок ----------
create or replace function kv_list_add(p_id text, p_item jsonb) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not is_member() then raise exception 'not_allowed'; end if;
  if p_id not in ('missions','checklist') or jsonb_typeof(p_item) <> 'object' or (p_item->>'id') is null then
    raise exception 'bad_input';
  end if;
  insert into kv (team, coll, id, data)
  values (my_team(), 'settings', p_id, jsonb_build_object('items', jsonb_build_array(p_item)))
  on conflict (team, coll, id) do update
    set data = jsonb_set(coalesce(kv.data, '{}'::jsonb), '{items}',
                 coalesce(kv.data->'items', '[]'::jsonb) || jsonb_build_array(p_item)),
        updated_at = now();
end $$;

create or replace function kv_list_remove(p_id text, p_item_id text) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not is_member() then raise exception 'not_allowed'; end if;
  update kv set
    data = jsonb_set(data, '{items}', coalesce(
      (select jsonb_agg(e) from jsonb_array_elements(coalesce(data->'items', '[]'::jsonb)) e
       where e->>'id' is distinct from p_item_id), '[]'::jsonb)),
    updated_at = now()
  where team = my_team() and coll = 'settings' and id = p_id;
end $$;

-- ---------- взять задачу так, чтобы два человека не взяли её одновременно ----------
create or replace function claim_task(task_id text, body jsonb) returns boolean
language plpgsql security definer set search_path = public as $$
declare n int;
begin
  if not is_member() then return false; end if;
  if (body->>'ownerId') is distinct from auth.uid()::text then return false; end if;
  insert into kv (team, coll, id, data) values (my_team(), 'tstatus', task_id, body)
  on conflict (team, coll, id) do update set data = excluded.data, updated_at = now()
  where coalesce(kv.data->>'status', 'todo') = 'todo' or kv.data->>'ownerId' = auth.uid()::text;
  get diagnostics n = row_count;
  return n > 0;
end $$;

-- ---------- заявки на вступление: нашёл команду в списке, капитан или ментор принял ----------
create table if not exists join_requests (
  user_id uuid primary key references auth.users(id) on delete cascade,   -- одна заявка на человека
  team_id uuid not null references teams(id) on delete cascade,
  name text not null check (char_length(name) between 1 and 40),
  email text,
  created_at timestamptz not null default now()
);
alter table join_requests enable row level security;   -- без политик: только через функции ниже
create index if not exists join_requests_team_idx on join_requests(team_id);

-- поиск команды по названию: видно только название и число участников
create or replace function search_teams(p_q text) returns jsonb
language plpgsql stable security definer set search_path = public as $$
declare q text := btrim(coalesce(p_q, ''));
begin
  if auth.uid() is null or char_length(q) < 2 then return '[]'::jsonb; end if;
  q := replace(replace(replace(q, '\', '\\'), '%', '\%'), '_', '\_');
  return coalesce((
    select jsonb_agg(jsonb_build_object('id', t.id, 'name', t.name,
             'members', (select count(*) from profiles p where p.team_id = t.id)) order by t.name)
    from (select * from teams where name ilike '%' || q || '%' order by name limit 20) t
  ), '[]'::jsonb);
end $$;

create or replace function request_join(p_team uuid, p_name text) returns jsonb
language plpgsql security definer set search_path = public as $$
declare n text := btrim(coalesce(p_name, '')); tn text;
begin
  if auth.uid() is null then raise exception 'not_signed_in'; end if;
  if exists (select 1 from profiles where user_id = auth.uid()) then raise exception 'already_in_team'; end if;
  if char_length(n) < 1 or char_length(n) > 40 then raise exception 'bad_member_name'; end if;
  select name into tn from teams where id = p_team;
  if tn is null then raise exception 'no_team'; end if;
  insert into join_requests (user_id, team_id, name, email)
  values (auth.uid(), p_team, n, auth.jwt()->>'email')
  on conflict (user_id) do update set team_id = excluded.team_id, name = excluded.name,
    email = excluded.email, created_at = now();
  return jsonb_build_object('team_id', p_team, 'team_name', tn, 'name', n);
end $$;

create or replace function my_request() returns jsonb
language sql stable security definer set search_path = public as $$
  select jsonb_build_object('team_id', r.team_id, 'team_name', t.name, 'name', r.name, 'created_at', r.created_at)
  from join_requests r join teams t on t.id = r.team_id where r.user_id = auth.uid()
$$;

create or replace function cancel_request() returns void
language sql security definer set search_path = public as
$$ delete from join_requests where user_id = auth.uid() $$;

create or replace function team_requests() returns jsonb
language plpgsql stable security definer set search_path = public as $$
begin
  if not is_staff() then return '[]'::jsonb; end if;
  return coalesce((select jsonb_agg(jsonb_build_object('user_id', user_id, 'name', name, 'email', email,
           'created_at', created_at) order by created_at)
         from join_requests where team_id = my_team()), '[]'::jsonb);
end $$;

create or replace function approve_request(p_user uuid) returns void
language plpgsql security definer set search_path = public as $$
declare t uuid := my_team();
begin
  if not is_staff() then raise exception 'not_allowed'; end if;
  if not exists (select 1 from join_requests where user_id = p_user and team_id = t) then raise exception 'no_request'; end if;
  insert into profiles (user_id, team_id) values (p_user, t) on conflict (user_id) do nothing;
  delete from join_requests where user_id = p_user;
end $$;

create or replace function decline_request(p_user uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not is_staff() then raise exception 'not_allowed'; end if;
  delete from join_requests where user_id = p_user and team_id = my_team();
end $$;

revoke all on function search_teams(text) from public, anon;
revoke all on function request_join(uuid, text) from public, anon;
revoke all on function my_request() from public, anon;
revoke all on function cancel_request() from public, anon;
revoke all on function team_requests() from public, anon;
revoke all on function approve_request(uuid) from public, anon;
revoke all on function decline_request(uuid) from public, anon;
grant execute on function search_teams(text), request_join(uuid, text), my_request(), cancel_request(),
  team_requests(), approve_request(uuid), decline_request(uuid) to authenticated;

-- ---------- доступ к функциям ----------
revoke all on function create_team(text) from public, anon;
revoke all on function join_team(text) from public, anon;
revoke all on function team_info() from public, anon;
revoke all on function leave_team() from public, anon;
revoke all on function regen_team_code() from public, anon;
revoke all on function remove_member(uuid) from public, anon;
revoke all on function kv_list_add(text, jsonb) from public, anon;
revoke all on function kv_list_remove(text, text) from public, anon;
revoke all on function claim_task(text, jsonb) from public, anon;
revoke all on function can_be_staff() from public, anon;
grant execute on function create_team(text), join_team(text), team_info(), leave_team(),
  regen_team_code(), remove_member(uuid), kv_list_add(text, jsonb), kv_list_remove(text, text),
  claim_task(text, jsonb), can_be_staff() to authenticated;

-- ---------- живое обновление ----------
do $$ begin
  alter publication supabase_realtime add table kv;
exception when duplicate_object then null; end $$;

-- ---------- видео: каждая команда загружает в свою папку ----------
insert into storage.buckets (id, name, public, file_size_limit)
values ('videos', 'videos', true, 52428800) on conflict (id) do nothing;
drop policy if exists videos_read on storage.objects;
create policy videos_read on storage.objects for select using (bucket_id = 'videos');
drop policy if exists videos_upload on storage.objects;
create policy videos_upload on storage.objects for insert to authenticated with check (
  bucket_id = 'videos'
  and (storage.foldername(name))[1] = public.my_team()::text
  and public.is_member()
);

-- Необязательно: дать почте право выбрать роль капитана/ментора в конкретной команде.
-- insert into staff_emails (email, team_id)
--   select 'mentor@gmail.com', id from teams where name = 'PEAK'
-- on conflict (email) do update set team_id = excluded.team_id;

-- Команды и число участников (покажется после запуска):
select t.name, (select count(*) from profiles p where p.team_id = t.id) as members,
       (select count(*) from join_requests r where r.team_id = t.id) as pending_requests
from teams t order by t.created_at;
