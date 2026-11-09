# Штаб FLL — запуск на Vercel + Supabase

Сайт статический (одна страница). Данные, вход по почте и видео хранит Supabase (бесплатного тарифа хватает команде). Хостит Vercel.

## 1. Supabase (≈5 минут)
1. supabase.com → New project (регион поближе, например Frankfurt). Запомните пароль базы, он нам не понадобится.
2. Откройте `schema.sql`, **внизу впишите почты капитана и ментора** (строчными буквами). Только с этими почтами можно выбрать роль «Капитан» или «Ментор».
3. Supabase → SQL Editor → New query → вставьте весь `schema.sql` → Run. Должно быть «Success».
4. Project Settings → API: скопируйте **Project URL** и ключ **anon public** в `config.js`.

## 2. Vercel
1. Загрузите папку на GitHub (новый репозиторий, все файлы в корне: `index.html`, `config.js`, `photos/`, ...).
2. vercel.com → Add New → Project → выберите репозиторий → Framework Preset: **Other** → Deploy.
3. Получите адрес вида `https://название.vercel.app`.

## 3. Вернуться в Supabase
Authentication → URL Configuration:
- **Site URL**: адрес вашего сайта на Vercel;
- **Redirect URLs**: добавьте тот же адрес (и `http://localhost:3000`, если будете запускать локально).

## 4. Важно про письма со ссылкой входа
Встроенная почта Supabase отправляет очень мало писем в час (единицы). Для команды из 8–10 человек этого мало. Два решения:
- **Вход через Google** (проще всего): Authentication → Providers → Google, создайте OAuth-клиент в Google Cloud Console по подсказке Supabase, потом в `config.js` поставьте `GOOGLE_LOGIN: true`. Тогда на экране входа появится кнопка «Войти через Google».
- Либо свой SMTP: Authentication → SMTP Settings (подойдёт бесплатный Resend или Brevo).

## Как это работает
- Вход по почте, регистрация (имя + роль) один раз, привязана к аккаунту.
- Права проверяет сама база: ставить и удалять задачи, принимать работу и сбрасывать регистрации могут только капитан и ментор. Роли капитана и ментора выдаются по списку почт в `staff_emails`.
- Чтобы добавить капитана позже: SQL Editor → `insert into staff_emails values ('почта@gmail.com');`
- Видео загружаются в Supabase Storage (бакет `videos`, до 50 МБ; сайт сам сжимает до 20 МБ).
- Ключ `anon` публичный по замыслу, защита данных в правилах `schema.sql`.
