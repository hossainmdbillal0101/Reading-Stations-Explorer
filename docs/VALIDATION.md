# Validation

Updated 29 October 2026. The repository is public and the fictional-data demo is deployed at https://billal-reading-stations.pages.dev/.

## Automated checks

The Check and build workflow passed on the dependency-hardening commit 53d7ffd749134eba968113fcc26947f51980225b. It runs the publication scan, Flutter analysis and functional tests, web release compilation, Android debug APK compilation, and Firestore emulator access-control tests. The separate full-history Secret scan workflow also passed. See the repository Actions tab for exact run logs and future results.

The rules tests use locked Firebase 13.1.0 / rules-unit-testing 6.0.0 dependencies, Node 24, Java 21, and Firebase CLI 15.34.1. The grpc-js dependency is pinned to the patched 1.13.6 release through an npm override. npm audit reported zero known vulnerabilities in backend-tests when checked.

## Live publication checks

The deployed files were compared against the verified release assets. HTTPS, HSTS, clickjacking protection, MIME-type protection, and Content Security Policy headers were checked. The public demo has no Firebase project configuration and uses fictional sample data. These checks do not replace a full browser, accessibility, or penetration test.

## Limits and next milestone

- The reproducible application baseline remains Flutter 3.10.4 / Dart 3.0.3. A supported Flutter and Android toolchain upgrade is a separate tested migration; this audit does not claim it has happened.
- Debug APKs are demonstration builds and have not been tested on a physical phone during this audit.
- Emulator tests verify the supplied rules and mocked API tests verify the REST adapter. They do not establish that an independently configured production Firebase project is secure.
- Historical thesis source is reference material only. Its obsolete dependency manifests were retired from the public tree; it is excluded from current builds and analysis.
- No new campus deployment, usability study, performance benchmark, or certification is claimed. Scans report known patterns and advisories; they cannot prove an absence of all vulnerabilities.
