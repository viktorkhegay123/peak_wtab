---
name: Штаб FLL
description: A calm light team workspace in the manner of Notion, under a deep navy header band.
colors:
  primary: "#5645d4"
  primary-hover: "#4534b3"
  primary-soft: "#efecfc"
  on-primary: "#ffffff"
  header-navy: "#0a1530"
  on-navy-muted: "#b7bfd4"
  link-blue: "#0b6bcb"
  focus-blue: "#8ab4f8"
  paper: "#ffffff"
  surface-warm: "#f7f6f3"
  surface-warm-2: "#f1f1ef"
  surface-warm-3: "#e9e9e7"
  hairline: "#e9e9e7"
  hairline-strong: "#dcdbd8"
  hairline-hover: "#c8c6c1"
  ink: "#37352f"
  ink-2: "#4f4d47"
  muted: "#6b6963"
  faint: "#77756f"
  charcoal-chip: "#2f2e2a"
  tag-gray-bg: "#efeeec"
  tag-gray: "#4b4943"
  tag-blue-bg: "#dbe9f5"
  tag-blue: "#1f4a6b"
  tag-yellow-bg: "#fbefcf"
  tag-yellow: "#6b4a12"
  tag-green-bg: "#dcefdf"
  tag-green: "#215c34"
  tag-red-bg: "#fde3df"
  tag-red: "#8a2a1e"
  tag-purple-bg: "#ebe3f5"
  tag-purple: "#55307e"
  tag-orange-bg: "#fbe3cf"
  tag-orange: "#7a3e10"
  tag-pink-bg: "#f8e1ec"
  tag-pink: "#7d2752"
  tag-brown-bg: "#efe5df"
  tag-brown: "#5e3a24"
  zone-red: "#d6322b"
  zone-yellow: "#b5600b"
  zone-green: "#1f8a3b"
typography:
  display:
    fontFamily: "Inter, -apple-system, Segoe UI, system-ui, sans-serif"
    fontSize: "clamp(26px, 3.6vw, 36px)"
    fontWeight: 700
    lineHeight: 1.1
    letterSpacing: "-0.025em"
  numeral:
    fontFamily: "Inter, -apple-system, Segoe UI, system-ui, sans-serif"
    fontSize: "clamp(64px, 14vw, 104px)"
    fontWeight: 700
    lineHeight: 1
    letterSpacing: "-0.04em"
    fontFeature: "\"tnum\""
  headline:
    fontFamily: "Inter, -apple-system, Segoe UI, system-ui, sans-serif"
    fontSize: "30px"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "-0.02em"
  title:
    fontFamily: "Inter, -apple-system, Segoe UI, system-ui, sans-serif"
    fontSize: "17px"
    fontWeight: 600
    lineHeight: 1.3
  card-title:
    fontFamily: "Inter, -apple-system, Segoe UI, system-ui, sans-serif"
    fontSize: "15px"
    fontWeight: 600
    lineHeight: 1.4
  body:
    fontFamily: "Inter, -apple-system, Segoe UI, system-ui, sans-serif"
    fontSize: "15px"
    fontWeight: 400
    lineHeight: 1.55
    fontFeature: "\"cv11\", \"ss03\", \"tnum\""
  label:
    fontFamily: "Inter, -apple-system, Segoe UI, system-ui, sans-serif"
    fontSize: "13px"
    fontWeight: 500
    lineHeight: 1.55
rounded:
  bar: "3px"
  tag: "5px"
  control-sm: "6px"
  control: "8px"
  group: "10px"
  box: "12px"
  sheet: "14px"
  round: "50%"
spacing:
  xxs: "4px"
  xs: "6px"
  sm: "8px"
  md: "12px"
  lg: "16px"
  xl: "20px"
  page-gutter: "20px"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.label}"
    rounded: "{rounded.control}"
    padding: "8px 14px"
  button-primary-hover:
    backgroundColor: "{colors.primary-hover}"
  button-tinted:
    backgroundColor: "{colors.primary-soft}"
    textColor: "{colors.primary}"
    rounded: "{rounded.control-sm}"
    padding: "5px 10px"
  button-tinted-hover:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
  button-ghost:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    rounded: "{rounded.control}"
    padding: "8px 14px"
  button-ghost-hover:
    backgroundColor: "{colors.surface-warm}"
  button-danger:
    backgroundColor: "{colors.zone-red}"
    textColor: "{colors.on-primary}"
    rounded: "{rounded.control}"
    padding: "8px 14px"
  input:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    rounded: "{rounded.control}"
    padding: "8px 11px"
  tag:
    backgroundColor: "{colors.tag-gray-bg}"
    textColor: "{colors.tag-gray}"
    typography: "{typography.label}"
    rounded: "{rounded.tag}"
    padding: "1px 7px"
  board-group:
    backgroundColor: "{colors.surface-warm}"
    rounded: "{rounded.group}"
    padding: "10px"
  card:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    rounded: "{rounded.control}"
    padding: "11px 12px"
  box:
    backgroundColor: "{colors.paper}"
    rounded: "{rounded.box}"
    padding: "20px"
  header-band:
    backgroundColor: "{colors.header-navy}"
    textColor: "{colors.on-primary}"
    padding: "26px 20px"
  footer-madeby:
    backgroundColor: "{colors.charcoal-chip}"
    rounded: "{rounded.control}"
    padding: "7px 12px"
---

# Design System: Штаб FLL

## Overview

**Creative North Star: "The Team's Notion Page"**

A familiar, calm productivity workspace played straight at Notion's craft level. The body of every view is a white page: warm charcoal text, warm off-white group surfaces, hairlines barely darker than the paper, and soft pastel tags carrying every status, category, Core Value, role and score zone. One purple does the work of "this is the main action". Nothing glows, nothing is costumed; a member should read the board, the run log and the stories at a glance.

The one decoration is the header: a full-bleed deep navy band with the workspace icon, product name, team and user on the left, a handful of Notion brand-colour sticker dots in the free space, and the tournament countdown in a translucent card on the right. Below the band the page returns to quiet light work. Density is medium: 15px body, 8–16px gaps, cards that hold a title, a tag row, a meta line and actions without crowding.

The user rejected dark Linear-style looks and a notebook-grid concept, and declined coloured board columns, multi-coloured Core Values tiles and tab icons. The PEAK logo is a white wordmark and appears only as "Made by PEAK" on a dark chip in the footer; team photos are never used.

**Key Characteristics:**
- White canvas, warm grey surfaces (#f7f6f3 family), warm hairlines.
- Pastel bg/text tag pairs as the only colour language for meaning.
- One purple primary; tinted purple for secondary in-card actions.
- Inter throughout, tabular numerals everywhere numbers appear.
- Depth from a 1px ring plus a small soft shadow, never from glow.
- A single navy header band with sticker dots as the only ornament.

## Colors

A warm-neutral Notion palette: near-white paper, warm charcoal ink, pastel tag pairs, one violet-purple accent, and one navy band.

### Primary
- **Workspace Purple** (primary): the filled main action (add task, save, start timer, record run, sign in), the workspace icon, the timer bar, the score chart line and points, the checkbox accent, upload progress. Hover deepens to **Deep Purple** (primary-hover).
- **Purple Wash** (primary-soft): tinted in-card actions at rest, the selected run-log row, the pressed Core Values tile and pressed reel item (with a 1px purple ring or border).

### Secondary
- **Header Navy** (header-navy): only the full-bleed header band and the page `theme-color`. Text on it is white; secondary text is **Navy Mist** (on-navy-muted). Buttons inside the band invert to white fill with navy text; inputs inside it are white with no border.
- **Link Blue** (link-blue): text links and video links. **Focus Blue** (focus-blue): the 2px focus outline and the focused-input border.

### Neutral
- **Paper** (paper): page background, cards, boxes, inputs.
- **Warm Surface** (surface-warm): board groups, stat tiles, login option cards, banners, the run score field at rest, ghost hover. **Warm Surface 2** (surface-warm-2): count badges, pressed filter chips, empty progress tracks. **Warm Surface 3** (surface-warm-3): upload bar track.
- **Hairline** (hairline): table rows, box borders, tab baseline, footer rule. **Hairline Strong** (hairline-strong): input, ghost button and stepper borders. **Hairline Hover** (hairline-hover): input hover border, strike-through colour.
- **Ink** (ink) for text, **Ink 2** (ink-2) for secondary body, **Muted** (muted) for meta, counts and table headers, **Faint** (faint) for placeholders and zero counts.
- **Charcoal Chip** (charcoal-chip): the toast and the "Made by PEAK" footer chip.

### Tag pairs
Nine pastel pairs (gray, blue, yellow, green, red, purple, orange, pink, brown), always used as background plus its own darker text, never mixed across pairs. Fixed mappings in the build:
- Board status pills: Свободные gray, В работе blue, На проверке yellow, Принято green (each with a 7px dot in currentColor).
- Task categories: robot blue, project orange, Core Values green, organisation purple.
- Core Values: Discovery blue, Innovation purple, Impact orange, Inclusion pink, Teamwork green, Fun yellow.
- Roles: build purple, code blue, engineering green, PM yellow, design pink, captain orange, mentor brown. Role avatars use a saturated version of the same hue with white initials.
- Score zones: red (≤299), yellow (300–430), green (>430) use the red/yellow/green pairs for score badges and the score field, and **Zone Red / Zone Yellow / Zone Green** for progress fills and the timer's warning and critical states.

### Named Rules
**The Tag Pair Rule.** Meaning is carried by a pastel background with its own darker text from the same pair. No saturated fills for categories, no coloured text on white for status.

**The One Purple Per Form Rule.** Each form or box has at most one filled purple button; everything else is ghost, tinted or a link button. Inside cards the actions are tinted purple and only fill on hover.

**The Red Means Something Rule.** Red appears only for real errors (failed upload, overdue date, weak mission, destructive confirm) and for the red score zone. Never as decoration or emphasis.

## Typography

**Display Font:** Inter (with -apple-system, Segoe UI, system-ui)
**Body Font:** Inter (same stack)

**Character:** One neutral sans in four weights (400, 500, 600, 700), tight negative tracking on large sizes, tabular numerals and Inter's `cv11`/`ss03` alternates on the whole body so scores, counts and timers line up.

### Hierarchy
- **Display** (700, clamp 26–36px, 1.1, -0.025em): the product name in the header band.
- **Numeral** (700, clamp 64–104px, 1, -0.04em): the match timer. Related big numbers: countdown 40px (28px on phones), run score field 48px, round total 40px, goal 30px, stat tiles 26px, Core Values counts 24px.
- **Headline** (700, 30px, 1.2, -0.02em): the page title of each tab. Team name 22px, login heading 26px use the same treatment.
- **Title** (600, 17px, 1.3): box headings. **Card title** (600, 15px, 1.4): task titles; done tasks go muted with a strike-through.
- **Body** (400, 15px, 1.55): default text; Core Values stories cap at 72ch.
- **Label** (500, 13px, 1.55): tags, pills, meta lines, small buttons, table headers; 12px for sub-lines.

### Named Rules
**The Tabular Rule.** Every number in the product uses tabular figures; never switch to proportional numerals for a "nicer" score.

## Layout

A centred page column (max 1160px) with 20px side gutters that respect safe-area insets (16px at ≤480px). The header band breaks out to full viewport width while its content stays aligned with the column. Below it: underlined view tabs, a page head (title plus one muted line), then the view's content.

- **Board:** auto-fit grid of status groups (min 250px, 16px gap); cards stack inside with 8px gaps.
- **Training:** a two-column match grid (1fr / 1.15fr, 16px gap) of boxes; stats as an auto-fit grid of 150px tiles.
- **Core Values:** a six-column tile grid with the "all" tile spanning the full row; stories as a single column list.
- **Team:** auto-fill grid of 240px member cards.
- **Rhythm:** 4/6/8px inside components, 12–16px between siblings, 20px box padding, 26px under the tabs, 48px above the footer.

**Responsive:**
- ≤1000px: the sticker-dot filler in the header is hidden; brand and countdown sit on their own.
- ≤820px: Core Values tiles drop to 3 columns, the match grid and story form go to one column, the add-task row and mission form wrap to two columns with the title field and button full width, the "me" filter goes full width.
- ≤640px: login/register forms go single column with 20px padding; the countdown card goes full width and compact (28px numeral, sub-line hidden); header padding shrinks to 18px; footer centres; the page-head description and banner shrink or hide.
- ≤480px: tabs tighten (14px, 2px gap) and fade out at the right edge to signal horizontal scroll; boxes pad 16px; gutters 16px; Core Values tiles 2 columns.
- Must work at 360px with no horizontal page scroll.

## Elevation & Depth

Flat and tonal by default. Group surfaces are distinguished by warm grey fills, not shadow. Content cards (task cards, Core Values tiles and stories, login sheet, play icon) carry a hairline ring plus a small soft shadow that grows slightly on hover. Boxes on the training and team pages use a 1px hairline border instead. The only larger shadow is the floating toast.

### Shadow Vocabulary
- **Ring** (`0 0 0 1px rgba(15,15,15,.06), 0 2px 4px rgba(15,15,15,.06)`): resting cards and tiles.
- **Ring Hover** (`0 0 0 1px rgba(15,15,15,.08), 0 4px 10px rgba(15,15,15,.08)`): hovered cards and tiles.
- **Ghost Lift** (`0 1px 2px rgba(15,15,15,.04)`): ghost buttons.
- **Toast** (`0 8px 24px rgba(15,15,15,.2)`): the floating toast only.
- **Focus Halo** (`0 0 0 3px rgba(35,131,226,.18)`): focused inputs, with a Focus Blue border.

### Named Rules
**The Neutral Shadow Rule.** Shadows are neutral near-black at low alpha. No coloured glows, no hard offset shadows.

## Shapes

Gently rounded and consistent: 3px on thin bars, 5px on tags and pills, 6px on small buttons and filter chips, 8px on buttons, inputs and task cards, 10px on board groups, stat tiles and Core Values tiles, 12px on boxes, the countdown card and the workspace icon, 14px on the login sheet. Avatars and status dots are circles. Borders are 1px hairlines; the only 2px line is the active-tab underline in ink.

## Components

### Header band
Full-bleed navy band (26px vertical padding, 18px on phones). Left: a 48px purple workspace icon with "FLL", the product name in Display, a muted navy-mist tagline, and the signed-in user chip (role avatar, name, link buttons). Middle: a flexible filler (min 120px wide, 64px tall) painted with six small Notion brand-colour dots (yellow, pink, teal, orange, violet, green; 4–8px radius), hidden at ≤1000px. Right: the countdown in a translucent card (white at 7% fill, white 14% border, 12px radius) with a 40px numeral.

### Navigation (view tabs)
A row of text tabs on a hairline baseline; 15px medium, muted at rest, ink on hover, and ink with a 2px ink underline when current. Each tab may carry a count badge (12px, Warm Surface 2, 5px radius). Horizontally scrollable without a visible scrollbar.

### Buttons
- **Shape:** 8px radius, 8px 14px padding, 14px medium; small variant 6px radius, 5px 10px, 13px.
- **Primary:** Workspace Purple fill, white text; hover Deep Purple.
- **Tinted (in cards):** Purple Wash fill with purple text; on hover fills purple with white text.
- **Ghost:** Paper fill, ink text, Hairline Strong border, Ghost Lift; hover Warm Surface. Inside cards the ghost loses border and shadow and reads as muted text that gains a hover wash.
- **Link button:** no chrome, 13px medium muted text, hover wash.
- **Danger:** Zone Red fill, used only for the second-step destructive confirm.
- **Focus:** 2px Focus Blue outline, 2px offset. Disabled at 50% opacity.

### Tags and pills
5px radius, 1px 7px padding, 13px medium, from one tag pair. Status pills in board group headers add a 7px dot. Score badges are 600 weight with a 44px minimum width. Filter chips are borderless text buttons that take Warm Surface 2 when pressed.

### Board groups and task cards
Each status group is a Warm Surface panel (10px radius, 10px padding) with a status pill and a muted count; the review group's count turns yellow-ink when it needs attention. Task cards are Paper with the Ring shadow, 8px radius, 11px 12px padding, a 15px semibold title, a category tag, a 13px muted meta line (owner, due date; overdue dates become a red tag) and an action row. On hover-capable devices the edit and delete actions are hidden until the card is hovered or focused.

### Boxes
Paper, 1px Hairline border, 12px radius, 20px padding (16px on phones), with a 17px semibold heading. Used for every training and team block.

### Inputs / Fields
Paper fill, 1px Hairline Strong border, 8px radius, 8px 11px padding, faint inner top shadow. Hover: Hairline Hover border. Focus: Focus Blue border with the Focus Halo. Selects use a drawn chevron. The steppers join a minus button, a centred number input and a plus button into one 34px control.

### Member stats (property list)
Inside member cards, stats read like a Notion property list: label muted on the left, value 14px semibold ink on the right, separated by hairlines, the last row unruled.

### Match timer
A box with the Numeral countdown centred, a 6px purple progress bar on Warm Surface 2, and full-width action buttons. Warning state turns numeral and bar Zone Yellow; critical and finished states turn them Zone Red.

### Score zones
Run score field, score badges, zone legend squares and progress fills (goal bar, mission rank bars) all draw from the zone pair of their value. The score chart uses a 2.5px purple line, white-stroked purple points, hairline gridlines and a dashed ink goal line.

### Footer
A hairline-ruled strip with muted 13px text and the "Made by PEAK" chip: Charcoal Chip fill, 8px radius, 11px uppercase label with 0.12em tracking, then the white PEAK wordmark at 20px height.

## Do's and Don'ts

### Do:
- **Do** carry every status, category, Core Value, role and score zone as a tag pair: pastel background plus its own darker text.
- **Do** keep one filled purple button per form or box; use tinted, ghost or link buttons for the rest.
- **Do** use the Ring shadow on content cards and a 1px hairline border on boxes; groups are tonal Warm Surface panels.
- **Do** keep tabular numerals on every score, count, date and timer.
- **Do** keep the navy band as the only dark surface besides the toast and the footer chip.
- **Do** keep the sticker dots inside the header filler between brand and countdown, and hide them at ≤1000px.
- **Do** show the PEAK logo only as the white wordmark on the dark "Made by PEAK" chip in the footer.

### Don't:
- **Don't** use red outside real errors, overdue dates, weak missions, destructive confirms and the red score zone.
- **Don't** use coloured glows or hard offset shadows; shadows stay neutral and soft.
- **Don't** use gradient text.
- **Don't** use coloured side-stripe borders on cards, banners or rows.
- **Don't** colour the board columns, make the Core Values tiles multi-coloured or add tab icons; the user declined all three.
- **Don't** use team photos, and don't place the PEAK logo anywhere but the footer chip.
- **Don't** introduce a dark theme or notebook-grid backgrounds; the user rejected both.
