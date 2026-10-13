# Focus Clock: Google sign-in page (testing)

GitHub Pages for the Focus Clock, served at **https://ramgopal.dev/focus-clock/**.

It holds the home page, the privacy policy, and the Google sign-in relay that the clock's QR
code opens: `https://ramgopal.dev/focus-clock/focus-clock-signin/`

That exact address must be an **Authorized redirect URI** of the Google Web client and the
firmware's **Google redirect page URL**. `focus-clock-signin/index.html` needs the Google
**Client ID** (public). Never put the client secret here; this repo is public.

The firmware-update files (`ota/`, `scripts/`) are kept on the `full-site` branch and will be
added later.
