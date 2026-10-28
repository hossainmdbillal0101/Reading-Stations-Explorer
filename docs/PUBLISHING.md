# Publish on GitHub and link your portfolio

## Prepare the repository

Upload the **contents** of the `reading-stations-explorer` folder at the repository root. Do not upload the enclosing outputs folder, private thesis files, local build caches, or the source folder from your old drive.

Run the publication check first:

```sh
python scripts/check_publication.py
flutter analyze
flutter test
flutter build web --release
```

Read VALIDATION.md for remaining limitations, and NOTICE.md before selecting a license. Repository publication does not grant permission to redistribute the original academic report or third-party materials.

Use your supplied repository [https://github.com/hossainmdbillal0101/Reading-Stations-Explorer](https://github.com/hossainmdbillal0101/Reading-Stations-Explorer). Repository access was verified through the connected GitHub account on 28 October 2026. The repository is private. Keep its visibility and the live deployment as separate decisions. You can use GitHub's upload interface or:

```sh
git init
git add .
git status
git commit -m "Rebuild reading stations explorer for mobile and web"
git branch -M main
git remote add origin https://github.com/hossainmdbillal0101/Reading-Stations-Explorer.git
git push -u origin main
```

Check `git status` and staged files before committing. A ZIP includes hidden `.github` and `.gitignore` files; retain these when extracting.

## Publish the demo website

1. Open repository Settings → Pages → Source → GitHub Actions.
2. Open Actions → Deploy demo to Pages → Run workflow on `main`.
3. Wait for the build and deployment to pass. The deployment URL appears in the workflow environment and Pages settings.
4. Test that URL on desktop and a phone, including a page reload. This workflow sets the repository base path automatically.

The workflow builds **demo mode only**. No Firebase configuration is injected. It is manually triggered so a source push does not silently publish a site. Private repository Pages availability depends on your GitHub plan.

### Alternative: Cloudflare Pages

The delivered `reading-stations-explorer-web-demo.zip` contains the compiled demo with `index.html` at the ZIP root. It can be used for a separate Cloudflare Pages direct-upload project. Do not replace your existing portfolio with the reading app. Keep the portfolio at its own address and link its project card to this demo and the GitHub repository. The source ZIP is for GitHub; the web-demo ZIP is for static hosting.

## Android build

The checks workflow creates a debug APK artifact for device testing. Install only on your own test device. Debug signing is not suitable for a Play Store release. Create and protect a release signing key separately before distributing a production APK or Android App Bundle. Keystores and signing passwords must never be committed.

## Connect your portfolio

Add the verified GitHub repository URL and live Pages URL to the project entry in PORTFOLIO.md and your portfolio's project card. Use the source and demo as separate buttons. The generated description avoids invented adoption metrics and identifies the portfolio rebuild.

An actual connection to an existing portfolio needs its URL and editable source/project access. This package includes the copy and deployment workflow; it does not claim to have changed an unavailable portfolio.
