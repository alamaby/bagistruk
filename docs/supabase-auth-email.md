# Supabase Auth Email Setup

This app uses Supabase Auth for email verification and password reset links.
For mobile registration, BagiStruk promotes an anonymous session into an
email/password account using `updateUser(email, password)`. Supabase therefore
sends the **Change email address** template, even though the user experience is
"create account".

## Required Dashboard Configuration

In Supabase Dashboard, open **Authentication -> URL Configuration**:

- Set **Site URL** to `https://bagistruk.vercel.app`.
- Add `bagistruk://auth/callback` to **Redirect URLs**.
- If `AUTH_EMAIL_REDIRECT_TO` is overridden, add that exact URL too.

## Email Templates

Open **Authentication -> Email Templates** and apply the repo templates:

| Supabase template | Subject | Source file |
| --- | --- | --- |
| Change email address | Verify your BagiStruk account email | `supabase/templates/auth-email-change.html` |
| Confirm signup | Confirm your BagiStruk registration | `supabase/templates/auth-confirm-signup.html` |

The **Change email address** template is the important one for the current app
registration flow. Keep the `{{ .ConfirmationURL }}` variable exactly as-is.

## Resend Custom SMTP

Use Resend through Supabase Auth custom SMTP. This keeps Supabase responsible
for auth token generation and verification, while Resend handles delivery from
the BagiStruk sender domain.

In Supabase Dashboard, open **Authentication -> SMTP Settings** and configure:

| Field | Value |
| --- | --- |
| Host | `smtp.resend.com` |
| Port | `465` with SSL, or `587` with STARTTLS |
| Username | `resend` |
| Password | Resend API key |
| Sender email | Verified sender, for example `BagiStruk <noreply@your-domain>` |

Before enabling this in production, verify the sender domain in Resend and send
a test email from Supabase Dashboard.

## Manual QA

- Register from a guest session with email/password.
- Confirm the email subject is not "Confirm Email Change".
- Tap the CTA and ensure it opens BagiStruk through `bagistruk://auth/callback`.
- Use password reset and ensure that email also uses the configured sender and
does not redirect to localhost.
