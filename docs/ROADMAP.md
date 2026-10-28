# Incremental project development

Use real changes and meaningful commits to show progress. Do not backdate commits or imply that automatically generated work was done on earlier days.

## First release

- Shared reader/admin application for Android and web.
- Local sample data and optional Firebase backend.
- Catalogue search, filters, favourites, requests, and admin CRUD.
- Documentation, behaviour tests, and publication safeguards.

## Suggested next sessions

1. Publish the validated demo, connect your portfolio, and collect feedback from two or three readers.
2. Upgrade from the validated Flutter baseline to a currently supported stable SDK, update Android tooling, and rerun all checks.
3. Set up a new Firebase staging project; run emulator security tests and live two-account acceptance checks.
4. Improve accessibility through keyboard, screen-reader, contrast, and large-text testing.
5. Add a station map only when verified coordinates and map-provider configuration are available.
6. Add server-side search/pagination and transactional station deletion for a growing catalogue.
7. Add verified-email onboarding, self-service password reset, account deletion, and an operational privacy policy for real users.
8. Add an authorized PDF upload pipeline with content-type checks, upload limits, malware review, and storage rules.

## Suggested commit style

Write commits around completed changes, such as `Add keyboard-accessible station filtering` or `Test request ownership in Firebase emulator`. Update CHANGELOG.md when a user-visible improvement is complete. Track unfinished work in issues with a concrete acceptance criterion.

This roadmap does not schedule automatic daily work. Each session should produce a real, reviewable improvement.
