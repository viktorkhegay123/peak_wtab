# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

School teams of FIRST LEGO League (FLL) in Kazakhstan: students roughly 9–16 years old, their captain, and an adult mentor. The interface is in Russian.

- **Members** (builders, coders, engineers, project managers, designers) take free tasks, log training runs with scores and video, and write Core Values stories.
- **Captain and mentor** create the team, set the team password, assign and accept tasks, manage roles and members, and download data backups.

Primary device is a computer or laptop at a desk: planning tasks, reviewing progress, writing Core Values entries. The training tab (2:30 match timer, mission score calculator, run log) is also used beside the competition table.

## Product Purpose

«Штаб FLL» is a team headquarters for an FLL season: one place for the task board, training runs and scores, Core Values evidence, and the team roster. It was built by team PEAK to unload their own team and is now opened to other FLL teams.

Success: a team keeps all season work in it without losing data, sees progress toward its score goal before the tournament, and arrives at judging with concrete Core Values examples.

## Positioning

Built by an FLL team for FLL teams, around the season's real rituals: the 2:30 robot game, mission scoring, the red/yellow/green score zones, and Core Values judging. Not a generic task tracker.

## Operating Context

- Each team has an isolated space: the captain or mentor creates a team with a name and a team password; members create personal accounts and enter the team with that name and password.
- Tabs: Задачи (board: Свободные, В работе, На проверке, Принято), Тренировка (match timer, pre-run checklist, round score calculator, run log, video player, score chart, team goal, mission stats), Core Values (six FLL values with story entries), Команда (roster, roles, team password).
- Countdown to the team's tournament date in the header.
- Score zones: red up to 299, yellow 300–430, green above 430.

## Capabilities and Constraints

- Single static page (`index.html`) plus `config.js`, hosted on Vercel; data, auth and video storage in Supabase (schema in `schema.sql`, row-level security per team).
- No build step; external scripts only from pinned CDNs; fonts from Google Fonts.
- Element ids and data attributes in `index.html` are used by the script and must be preserved.
- Videos up to 20 MB (compressed in the browser); links to YouTube/Google Drive also accepted.

## Brand Commitments

- Product name: «Штаб FLL».
- Made by team PEAK (Kazakhstan). The PEAK logo (`peak-logo.webp`, white wordmark with a mountain peak) appears as "Made by PEAK" on every screen.
- Team photos of PEAK must not be used in the design.
- FIRST LEGO League terminology (Core Values names, robot game) is used as is.
- Standing look preference (user, 2026-11-18): a familiar, "normal" productivity-tool look in the manner of Notion — light, calm, white canvas with soft tags. Rejected: dark Linear-style, notebook-grid concept. Craft bar: Notion.

## Evidence on Hand

- PEAK logo: `peak-logo.webp` (transparent, white).
- No testimonials, user counts or partner logos exist; do not invent them.

## Product Principles

1. Never lose a team's data: server is the source of truth; destructive actions ask twice.
2. Each team is private by default; nothing of one team is visible to another.
3. Season rituals first: timer, scores and Core Values are one click away.
4. Readable for kids 9–16 and for a mentor reviewing a whole team at once.

## Accessibility & Inclusion

Text contrast meets WCAG AA. Interface must work at phone width (360 px) without horizontal scrolling, although the main device is a computer.
