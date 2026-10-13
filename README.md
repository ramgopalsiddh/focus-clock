# Focus Clock website

Public pages for the Focus Clock, served by GitHub Pages at **https://ramgopal.dev/focus-clock/**.
The firmware source is in a separate private repo; nothing secret belongs here.

| Path | What it is |
| --- | --- |
| `index.html` | Home page |
| `privacy/` | Privacy policy (needed for Google sign-in verification) |
| `focus-clock-signin/` | Google sign-in relay: phone -> Google -> code handed to the clock on the home Wi-Fi |
| `ota/version.json` | Latest firmware version that clocks check once a day |
| `ota/focus_clock-<version>.bin` | Signed firmware images |

## Google sign-in

`focus-clock-signin/index.html` needs the Google OAuth **Client ID** (public) in `CLIENT_ID`.
The same address, `https://ramgopal.dev/focus-clock/focus-clock-signin/`, must be:

- an **Authorized redirect URI** of the Web client in Google Cloud, and
- the firmware's menuconfig **Focus Clock > Calendar accounts > Google redirect page URL**.

Never put the **client secret** here.

## Publishing a firmware update

1. In the firmware repo: raise `PROJECT_VER` in `CMakeLists.txt`, then `idf.py build`.
2. Here: `scripts/publish_firmware.sh` (or `--auto` to let clocks install at night).
3. `git add ota && git commit -m "Firmware vX.Y.Z" && git push`.

Clocks only accept images signed with the firmware signing key, and only a higher version.
Each version gets its own file name so caches never serve an old image under a new name.

## Never commit

The firmware signing key (`firmware/keys/*.pem`), `sdkconfig`, `.env` files or any
secret. This repo is public.
