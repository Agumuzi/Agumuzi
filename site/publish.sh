#!/usr/bin/env bash
set -euo pipefail

OWNER="Agumuzi"
REPO="agumuzi.github.io"
FULL="$OWNER/$REPO"
SOURCE="https://raw.githubusercontent.com/Agumuzi/Agumuzi/main/site"
SITE="https://agumuzi.github.io"

command -v gh >/dev/null || { echo "ERROR: GitHub CLI (gh) is required."; exit 1; }
command -v git >/dev/null || { echo "ERROR: Git is required."; exit 1; }
command -v curl >/dev/null || { echo "ERROR: curl is required."; exit 1; }
gh auth status -h github.com >/dev/null || { echo "ERROR: Run 'gh auth login' first."; exit 1; }
LOGIN="$(gh api user --jq '.login')"
if [[ "$LOGIN" != "$OWNER" ]]; then
  echo "ERROR: Active account is $LOGIN. Expected $OWNER."; exit 1
fi

if gh repo view "$FULL" --json name >/dev/null 2>&1; then
  echo "Existing repository found: $FULL"
else
  echo "Creating free public GitHub Pages user repository..."
  gh repo create "$FULL" --public --add-readme \
    --description "Independent macOS apps, network tools, and automation by Agumuzi"
fi

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
gh repo clone "$FULL" "$WORK/repo"
cd "$WORK/repo"

echo "Downloading published source files from Agumuzi/Agumuzi/site..."
for f in index.html style.css site.js; do
  curl --fail --location --silent --show-error "$SOURCE/$f" -o "$f"
done
touch .nojekyll

git add index.html style.css site.js .nojekyll
if ! git diff --cached --quiet; then
  ID="$(gh api user --jq '.id')"
  git -c user.name="$OWNER" -c user.email="$ID+$OWNER@users.noreply.github.com" \
    commit -m "site: publish Agumuzi personal portfolio"
  git push origin HEAD:main
else
  echo "Website files are already current."
fi

if gh api "repos/$FULL/pages" >/dev/null 2>&1; then
  echo "GitHub Pages is already enabled."
else
  echo "Enabling GitHub Pages (main branch, root folder)..."
  gh api -X POST "repos/$FULL/pages" \
    -f build_type=legacy \
    -f 'source[branch]=main' \
    -f 'source[path]=/' >/dev/null
fi

echo "Updating public GitHub profile website URL..."
if ! gh api -X PATCH user -f blog="$SITE" >/dev/null; then
  echo "WARNING: Could not update profile URL. Run: gh auth refresh -h github.com -s user"
fi
echo
echo "DONE. Pages site may require publishing time. Open: $SITE"
echo "Repository: https://github.com/$FULL"
