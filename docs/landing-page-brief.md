# BagiStruk Landing Page Brief

Audience: code agent or designer/developer implementing the public landing page for BagiStruk.

Goal: create a clear, trustworthy, mobile-first landing page that explains BagiStruk, supports Google Play release readiness, and gives users a public source for product, privacy, and terms information.

## Product Positioning

BagiStruk is a split-bill app for receipt photos. Users take or pick receipt photos, OCR extracts bill items, users review/correct the result, assign items to participants, then track payment settlement.

Primary message:

> Split bills from receipt photos, without rebuilding the receipt by hand.

Tone:

- Practical, friendly, concise.
- Trustworthy rather than flashy.
- Consumer-facing, not developer-heavy.
- Bilingual: English and Bahasa Indonesia.
- English is the default language.
- Bahasa Indonesia must be available through a visible language switcher.

## Internationalization

The landing page must support two languages:

- Default: English.
- Secondary: Bahasa Indonesia.

URL strategy:

- Prefer `/` for English.
- Prefer `/id` for Bahasa Indonesia.
- If the chosen framework uses locale prefixes for every language, `/en` and `/id` are acceptable, but English must still be the default route.

Language switcher:

- Show a compact language switcher in the header or footer.
- Use clear labels: `EN` and `ID`, or `English` and `Indonesia`.
- Preserve the current page/section where possible when switching language.
- Persist the user's language choice only if the implementation already has a lightweight first-party preference mechanism.

Content requirements:

- All user-facing landing page copy must be translated.
- Do not mix English and Indonesian in the same sentence except for product names, brand terms, or technical proper nouns.
- Privacy Policy and Terms links may point to bilingual legal pages or to pages that visibly contain both English and Indonesian content.
- Metadata must be localized per route:
  - English title/description for `/`.
  - Indonesian title/description for `/id`.

Suggested English primary message:

> Split bills from receipt photos, without rebuilding the receipt by hand.

Suggested Indonesian primary message:

> Bagi tagihan dari foto struk, tanpa mengetik ulang semuanya.

## Recommended Page Structure

### 1. Hero

Purpose: immediately show what BagiStruk is and why it matters.

Content:

- H1: `BagiStruk`
- English supporting copy: `Scan receipts, review the OCR result, and split the bill with friends in a few steps.`
- Indonesian supporting copy: `Scan struk, cek hasil OCR, lalu bagi tagihan ke teman dalam beberapa langkah.`
- English primary CTA: `Join the waitlist` or `Request testing access`
- Indonesian primary CTA: `Gabung waitlist` or `Minta akses testing`
- English secondary CTA: `See how it works`
- Indonesian secondary CTA: `Lihat cara kerja`
- English status note: `Preparing for Google Play internal testing.`
- Indonesian status note: `Sedang disiapkan untuk Google Play internal testing.`

Visual:

- Use real app screenshots when available.
- Until screenshots are ready, use the placeholder assets from `docs/assets/screenshots/`.
- Show the app UI in a phone mockup or clean screenshot strip.
- The first viewport must clearly signal the product name and actual app experience.

Avoid:

- Generic gradient-only hero.
- Abstract illustration that does not show the app.
- Large marketing claims without showing the workflow.

### 2. Workflow

Purpose: explain the app in a scan-friendly sequence.

Recommended steps:

1. `Ambil foto struk`
2. `Review hasil OCR`
3. `Tentukan peserta`
4. `Bagi item dan pantau pembayaran`

Each step should use one short sentence and, ideally, a small screenshot or icon.

### 3. Feature Highlights

Keep this section compact. Recommended features:

- Multi-photo receipt OCR.
- Editable OCR results before saving.
- Item-level participant assignment.
- Proportional tax and service splitting.
- Settlement tracking.
- Anonymous-first use with option to create a permanent account.
- Bahasa Indonesia and English UI.

Do not overload the page with implementation details such as Riverpod, Supabase, RLS, or LLM provider names unless placed in a small technical note near the bottom.

### 4. Trust And Privacy

Purpose: reduce concern around receipt photos, accounts, and AI processing.

Recommended copy:

- `Foto struk dipakai untuk memproses OCR dan mengekstrak item tagihan.`
- `API key OCR disimpan di server, bukan di aplikasi.`
- `Kamu bisa meminta penghapusan akun dan data sesuai kebijakan privasi.`

Link to:

- `docs/privacy-policy.md`
- `docs/terms-of-service.md`

If the landing page will be hosted publicly, expose these as stable public URLs such as:

- `/privacy`
- `/terms`

### 5. Screenshots

Use 3-4 screenshots:

- Scan receipt.
- Review extracted bill.
- Assign items to participants.
- Track settlement.

Current placeholders:

- `docs/assets/screenshots/scan-receipt.svg`
- `docs/assets/screenshots/review-bill.svg`
- `docs/assets/screenshots/split-bill.svg`
- `docs/assets/screenshots/settlement.svg`

Replace placeholders with final PNG/JPEG screenshots before public launch.

### 6. Availability / CTA

Choose one CTA based on release state:

- Before Play Store public release: `Gabung waitlist`
- Internal testing: `Minta akses testing`
- Production release: `Download di Google Play`

If using waitlist, keep the form minimal:

- Email input.
- Optional checkbox for product updates.
- Submit button with disabled/loading/success/error states.
- First-party anti-bot if a backend exists, for example a hidden honeypot field plus server-side rate limiting.

### 7. FAQ

Recommended questions:

- `Apakah hasil OCR selalu akurat?`
  - Answer: users should review and correct items before saving or sharing.
- `Apakah bisa dipakai tanpa akun?`
  - Answer: some flows can start anonymously; permanent account keeps history safer.
- `Data apa yang diproses?`
  - Answer: receipt photos, bill items, participant names, and account data where relevant.
- `Kapan tersedia di Google Play?`
  - Answer: currently preparing for internal testing; update when release state changes.

### 8. Footer

Include:

- Product name.
- Short description.
- Privacy Policy.
- Terms of Service.
- GitHub repository if public.
- Contact email from privacy policy: `alam.aby.b@gmail.com`.

## Visual Direction

Preferred feel:

- Clean, warm, practical, mobile-app focused.
- Light background with strong contrast.
- Use teal/green as an accent if matching existing BagiStruk visuals, balanced with neutral surfaces.
- Avoid a one-note palette; add neutral grays and one supporting accent for warnings/status.

Layout guidance:

- Mobile-first.
- Single-column on mobile.
- Two-column hero on desktop is acceptable only if the product screenshot remains prominent.
- Keep sections unframed where possible; use cards only for repeated items such as workflow steps or FAQ rows.
- Do not place cards inside cards.
- Text must not overlap screenshots or CTA buttons at any viewport.

Suggested sections order:

1. Hero with product screenshot.
2. Workflow.
3. Feature highlights.
4. Screenshot gallery.
5. Trust/privacy note.
6. CTA/waitlist.
7. FAQ.
8. Footer.

## Copy Draft

English hero:

```text
BagiStruk
Scan receipts, review the OCR result, and split the bill with friends in a few steps.
```

Indonesian hero:

```text
BagiStruk
Scan struk, cek hasil OCR, lalu bagi tagihan ke teman dalam beberapa langkah.
```

English short value props:

```text
No need to type every item by hand.
Review and correct OCR results before saving.
Split tax and service proportionally.
Track who has paid.
```

Indonesian short value props:

```text
Tidak perlu mengetik ulang semua item.
Tetap bisa koreksi hasil OCR sebelum disimpan.
Pajak dan service dibagi proporsional.
Pantau siapa yang sudah bayar.
```

English CTA examples:

```text
Join the waitlist
Request testing access
Download on Google Play
```

Indonesian CTA examples:

```text
Gabung waitlist
Minta akses testing
Download di Google Play
```

English privacy note:

```text
BagiStruk processes receipt photos to recognize bill items. You should still review OCR results before saving or sharing.
```

Indonesian privacy note:

```text
BagiStruk memproses foto struk untuk mengenali item tagihan. Hasil OCR tetap perlu kamu cek sebelum disimpan atau dibagikan.
```

## SEO And Metadata

Recommended metadata:

- English title: `BagiStruk - Split bills from receipt photos`
- English description: `BagiStruk helps you scan receipt photos, review extracted bill items, split costs with friends, and track settlement.`
- Indonesian title: `BagiStruk - Bagi tagihan dari foto struk`
- Indonesian description: `BagiStruk membantu kamu scan foto struk, mengecek hasil OCR, membagi tagihan dengan teman, dan memantau pembayaran.`
- Open Graph image: use a final 1200x630 product graphic when available.
- Favicon/app icon: use final launcher icon source when ready.

Recommended keywords/topics:

- split bill app
- receipt scanner
- OCR receipt
- bill splitter Indonesia
- aplikasi bagi tagihan
- aplikasi scan struk

## Technical Recommendations

If this is implemented inside this Flutter repo:

- A static landing page can live under `web/` if it should ship with Flutter Web.
- A separate site can live in a new `landing/` or external repo if using Next.js/Astro.
- For a simple product landing, prefer static generation/SSG over server-rendered dynamic pages.
- Keep privacy and terms available as public HTML pages, not only Markdown files in the repo.
- Reuse existing copy from `README.md`, `docs/privacy-policy.md`, and `docs/terms-of-service.md`.

If using Next.js:

- Use static rendering for the landing page.
- Use environment validation for any waitlist/backend integration.
- Use a small server action/API route for waitlist submission only if needed.
- Add loading, disabled, success, and error states for form submission.
- Add rate limiting or first-party anti-bot protection for the waitlist endpoint.

If using Flutter Web:

- Keep the landing page lightweight and fast.
- Ensure SEO metadata is available in `web/index.html`.
- Consider a separate static HTML landing page if SEO is more important than code reuse.

## Asset Checklist

Needed before public launch:

- Final phone screenshots:
  - Scan receipt.
  - Review bill.
  - Split participants/items.
  - Settlement tracking.
- Feature graphic:
  - 1024x500 for Play Store.
  - 1200x630 for social sharing/Open Graph.
- App icon:
  - 1024x1024 PNG source with adaptive-icon safe padding.
- Optional short demo video or GIF:
  - Keep under 20 seconds.
  - Show scan -> review -> split -> settlement.

Existing placeholders:

- `docs/assets/play-store/feature-graphic-placeholder.svg`
- `docs/assets/screenshots/*.svg`

## Acceptance Criteria

- The first viewport clearly communicates `BagiStruk` and shows the app experience.
- English is the default language.
- Bahasa Indonesia is available through a visible language switcher.
- All landing copy and metadata are localized for English and Bahasa Indonesia.
- Page works well on mobile widths from 360px upward.
- CTA has clear state based on release stage.
- Privacy Policy and Terms links are visible in footer.
- No broken images or placeholder alt text in public release.
- Lighthouse-style basics are covered: title, description, responsive layout, image alt text, accessible contrast.
- If a waitlist form exists, repeated submission is prevented and success/error feedback is shown.
