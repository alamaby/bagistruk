# Landing Page Feature Documentation Site Plan

Created: 2026-09-13 07:00:00

## Objective

Document every shipped BagiStruk app feature on the public landing page
(`https://bagistruk.alamaby.com`) via dedicated per-feature routes
(bilingual EN/ID), add SVG screenshot placeholders for the user to replace
with real captures later, and fix the vercel.app → custom-domain drift.
Work happens in the sibling repo `bagistruk-landing-page`.

## Scope

- New per-feature documentation routes under `/docs/*` and `/id/docs/*`
  (20 entries, EN + ID).
- `src/content.ts` gains a `docs` nav label; full catalog lives in a new
  `src/docsContent.ts` (mirrors `legalContent.ts` / `emailCampaignContent.ts`).
- SVG placeholders in `public/screenshots/` + image-based Screenshots section.
- Domain fix to `bagistruk.alamaby.com` (canonical, OG, sitemap, robots).
- No backend changes; no app-repo changes except flagging the history-window
  drift (DB 7/90 vs client 30/365 — documenting 30/365 per user decision).

## Milestones

1. Content model + feature catalog (bilingual).
2. Doc routes + shared renderer + nav/footer/sitemap wiring.
3. Screenshot placeholders + image-based screenshots section.
4. Domain/SEO fix + OG image note.
5. TODO/memory updates + build verification.

## Tasks

- [x] Phase 1 — content model: `src/docsContent.ts` with 20 entries
  (scan, review, split, settlement, manual, participants, reminders,
  share-link, export, history, search-category, insight, trash, templates,
  plus-ocr, credits, account, settings, onboarding-about, ads-consent),
  each EN+ID with summary + sections; extend `features.items` (7→12),
  fix `guide.secondary` history windows to 30/365, extend `trust.points`
  with ads + billing.
- [x] Phase 2 — routes: extend `getPage()`, `pagePathForLang()`,
  `getCanonicalUrl()` for `docs` / `docs_feature`; new
  `src/components/Docs.tsx` (index + detail); header/footer Docs links;
  `AnalyticsPage` gains `docs` + `docs_feature`; sitemap entries.
- [x] Phase 3 — screenshots: `public/screenshots/*.svg` placeholders (20 files)
  + `README.md`; `screenshots.items` in `content.ts`; App screenshots section
  renders `<img>`.
- [x] Phase 4 — domain: replace `bagistruk.vercel.app` with
  `bagistruk.alamaby.com` in `index.html`, `App.tsx` SITE_URL, `robots.txt`,
  `sitemap.xml`, `api/unsubscribe.ts`; note `og-image.png` export still pending.
- [x] Phase 5 — wrap-up: TODO claim-review checkbox, PROJECT_MEMORY entry,
  `npm run build` verification.

## Risks

- 20 pages × 2 languages is a large content surface; stale copy risk.
  Mitigation: single `docsContent.ts` source of truth.
- History window: documenting 30/365 while DB returns 7/90. Flagged as an
  app-repo bug to fix separately (see Notes).
- Domain cutover: if DNS is not wired to Vercel yet, canonical/OG will point
  at a dead host until DNS is set.
- SPA client routing: `vercel.json` rewrite already covers new routes, but
  deep-link refresh must be tested.

## Progress Log

- 2026-09-13 07:00:00 — Plan written; implementation started in
  `bagistruk-landing-page`.
- 2026-09-13 08:00:00 — All phases done: 20-entry bilingual docs catalog,
  `/docs` routes + renderer, 20 SVG placeholders, domain cutover,
  TODO/memory updates. `npm run build` passes (vite, 2.5s);
  `npx tsc --noEmit` shows 1 pre-existing error in unused `Waitlist.tsx`
  (missing `waitlist` copy — untouched by this change). Bundle verified:
  docs slugs present, 0 `vercel.app` references. Not committed (user review
  pending); `vercel.json` dirty state and untracked TODO/PROJECT_MEMORY/api
  pre-date this change.

## Notes

- Counter-argument: 20 standalone routes may be heavy; low-weight topics
  (about, onboarding, ads-consent) could merge later if maintenance bites.
- Screenshot SVGs carry a `TODO` marker for replacement with real PNGs.
- Source inventory: app routes in `lib/core/router/app_router.dart`, screens
  under `lib/presentation/*/screens`, credits in
  `supabase/migrations/20260601120000_ocr_credit_entitlements.sql`,
  history window DB `bill_history_window_days()` (7/90) vs client
  `PlusFeatureLimits` (30/365).
