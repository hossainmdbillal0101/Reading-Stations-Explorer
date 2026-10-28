# Validation record

Prepared on 28 October 2026 (Asia/Kuala_Lumpur).

## Confirmed results

| Check | Result |
| --- | --- |
| Dependency resolution | Passed using a prepared local package cache and committed lockfile |
| Static analysis | `dart analyze lib test`: no issues found |
| Functional Flutter tests | 9 passed: reader restrictions, catalogue/station changes, favourite persistence, request resolution, search states, responsive navigation, Firebase codec and request ownership query |
| Firestore emulator rules tests | 3 passed: anonymous/admin access, profile ownership and role escalation prevention, owned request access and resolution |
| Web release compilation | Passed with Flutter 3.10.4 / Dart 3.0.3 |
| Android debug APK compilation | Passed with Flutter 3.10.4, Gradle 7.5, local JDK 15; final source compiled with Flutter assemble and packaged by Gradle |
| Rendered UI previews | Desktop and mobile widget rendering captured; this is separate from browser/device testing |
| Publication scan | Run again when packaging; see START-HERE and checksums with delivered files |

## Limits of these results

- The APK is a debug build, not a store-signed release. It has not been installed on a physical Android device during preparation. Debug builds contain diagnostics and should not be used as a production release.
- Browser automation could not attach to the local preview. Successful web compilation and Flutter widget tests do not claim live browser acceptance testing.
- The Firebase REST adapter has mocked API tests; the rules were exercised against the local Firestore emulator. No live Firebase project, real user account, or production database was accessed by the rebuild.
- No new usability study, performance benchmark, or campus deployment is claimed. The original thesis testing is historical and is not reused as evidence for this rebuild.
- GitHub Actions and Pages workflows are prepared but have not run in your GitHub account. Actual publishing requires an account/repository destination and Pages configuration.
- Your live portfolio Worker was not changed. A separate updated portfolio copy was prepared from the supplied public URL, preserving the research, about, journey, and contact sections exactly. The original external CSS/JS returned HTTP 403 to the preparation client, so the delivered copy uses new self-contained styling and accordion behaviour.
- GitHub repository access was verified on 28 October 2026 after the connector installation was completed. The repository is private and supports source uploads. No live website deployment is claimed by this source package.
- Flutter 3.10.4 is the installed reproducible baseline, not the latest supported SDK. Modernizing Flutter/Android tooling is recorded as the next development milestone.

## Environment issues resolved during preparation

The installed Dart package manager initially crashed while fetching packages. A local package cache allowed dependency resolution. Flutter's default sandbox temporary directory also caused a test compiler access error; using a workspace temporary directory allowed the functional suite to complete. Initial UI tests found an overflowing station selector; making the selector expand within its constraint resolved it.

These are preparation-environment observations. Normal setup remains `flutter pub get` with the committed dependency lockfile. See FIREBASE.md for emulator test commands and PUBLISHING.md for build/publication commands.

A final nested Windows Flutter/Gradle run intermittently exited with `0xC0000008` (invalid handle), even though direct Flutter compilation succeeded. The final APK was produced by running Flutter assemble successfully, then Gradle packaging against those fresh assets. The optional `scripts/build_android_windows.ps1` records that sequence; it never skips Flutter compilation before packaging. Standard CI build commands remain in the workflows.
