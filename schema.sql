-- Штаб FLL: схема базы для Supabase. Вставьте весь файл в SQL Editor и нажмите Run.
-- Перед запуском впишите в самом низу почты капитана и ментора (список staff_emails).

create table if not exists kv (
  coll text not null,
  id text not null,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (coll, id)
);
alter table kv enable row level security;

create table if not exists staff_emails (email text primary key);
alter table staff_emails enable row level security;   -- без политик: снаружи не читается

create or replace function me_role() returns text
language sql stable security definer set search_path = public as
$$ select data->>'role' from kv where coll = 'members' and id = auth.uid()::text $$;

create or replace function is_member() returns boolean
language sql stable security definer set search_path = public as
$$ select me_role() in ('build','code','eng','pm','design','cap','mentor') $$;

create or replace function is_staff() returns boolean
language sql stable security definer set search_path = public as
$$ select coalesce(me_role() in ('cap','mentor'), false) $$;

create or replace function can_be_staff() returns boolean
language sql stable security definer set search_path = public as
$$ select exists (select 1 from staff_emails where lower(email) = lower(coalesce(auth.jwt()->>'email',''))) $$;

-- читать могут все вошедшие
drop policy if exists kv_select on kv;
create policy kv_select on kv for select to authenticated using (true);

-- создавать
drop policy if exists kv_insert on kv;
create policy kv_insert on kv for insert to authenticated with check (
  (coll = 'tasks' and is_staff())
  or (coll in ('tstatus','runs','cv','settings') and is_member())
  or (coll = 'members' and id = auth.uid()::text
      and data->>'role' in ('build','code','eng','pm','design','cap','mentor')
      and (data->>'role' not in ('cap','mentor') or can_be_staff()))
);

-- менять
drop policy if exists kv_update on kv;
create policy kv_update on kv for update to authenticated
using (
  (coll = 'tasks' and is_staff())
  or (coll in ('tstatus','runs','cv','settings') and is_member())
  or (coll = 'members' and is_staff())
) with check (
  (coll = 'tasks' and is_staff())
  or (coll in ('tstatus','runs','cv','settings') and is_member())
  or (coll = 'members' and is_staff())
);

-- удалять
drop policy if exists kv_delete on kv;
create policy kv_delete on kv for delete to authenticated using (
  (coll in ('tasks','tstatus','members') and is_staff())
  or (coll in ('runs','cv','settings') and is_member())
);

-- взять задачу так, чтобы два человека не взяли её одновременно
create or replace function claim_task(task_id text, body jsonb) returns boolean
language plpgsql security definer set search_path = public as $$
declare n int;
begin
  if not is_member() then return false; end if;
  if (body->>'ownerId') is distinct from auth.uid()::text then return false; end if;
  insert into kv (coll, id, data) values ('tstatus', task_id, body)
  on conflict (coll, id) do update set data = excluded.data, updated_at = now()
  where coalesce(kv.data->>'status','todo') = 'todo' or kv.data->>'ownerId' = auth.uid()::text;
  get diagnostics n = row_count;
  return n > 0;
end $$;
revoke all on function claim_task(text, jsonb) from public;
grant execute on function claim_task(text, jsonb) to authenticated;
grant execute on function can_be_staff() to authenticated;

-- живое обновление
do $$ begin
  alter publication supabase_realtime add table kv;
exception when duplicate_object then null; end $$;

-- видео
insert into storage.buckets (id, name, public, file_size_limit)
values ('videos', 'videos', true, 52428800) on conflict (id) do nothing;
drop policy if exists videos_read on storage.objects;
create policy videos_read on storage.objects for select using (bucket_id = 'videos');
drop policy if exists videos_upload on storage.objects;
create policy videos_upload on storage.objects for insert to authenticated with check (bucket_id = 'videos');

-- >>> ВПИШИТЕ ПОЧТЫ КАПИТАНА И МЕНТОРА (строчными буквами) <<<
insert into staff_emails (email) values
  ('captain@example.com'),
  ('mentor@example.com')
on conflict do nothing;
