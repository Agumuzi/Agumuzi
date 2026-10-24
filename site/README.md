# Agumuzi portfolio website (staging)

This directory contains the source for a lightweight, bilingual, responsive developer portfolio at https://agumuzi.github.io/.

**Status:** Staged here only. The personal root Pages address is not live until the public repository named `Agumuzi/agumuzi.github.io` is created and Pages is enabled.

## Deploy

From your own authenticated Mac (GitHub CLI must be signed in as `Agumuzi`):

1. Download [publish.sh](publish.sh) and inspect it.
2. Run it with `bash publish.sh`.

It creates the required public repository if absent, copies `index.html`, `style.css`, and `site.js` to its root, pushes a commit, enables Pages from `main` root, and attempts to set your public GitHub profile URL.

The script does not touch FinTrack, Currency Tracker, or CR-Hopper. The website references their already-public logos and links without copying any private code or personal data.

## Updating later

Edit the files in this staging directory, then rerun the deployment script. No build tool, external tracker, or paid domain is needed. English is the default language; Chinese is an optional client-side toggle.
