# Set up a separate Firebase backend

The public demo needs no Firebase project. These steps are for a real shared catalogue. They must not point to the old thesis backend.

1. Create a separate Firebase project. Enable Email/Password in Authentication and create a default Firestore database.
2. Deploy `firestore.rules` to that project. Use the explicit project ID so no old default project is selected:

   ```sh
   firebase login
   firebase deploy --only firestore:rules --project YOUR_PROJECT_ID
   ```

3. Copy `config/firebase.example.json` to `config/firebase.local.json`. Enter the new project's client API key and project ID. The local file is ignored by Git and excluded from packaging. Do not put a service account or private key in it.
4. Build/run with the local client configuration:

   ```sh
   flutter run -d chrome --dart-define-from-file=config/firebase.local.json
   flutter build web --release --dart-define-from-file=config/firebase.local.json
   flutter build apk --debug --dart-define-from-file=config/firebase.local.json
   ```

5. Register an account in the app. Promote a chosen administrator **only in a trusted environment** using the Firebase Admin SDK and Application Default Credentials:

   ```js
   // Trusted administrator environment only; never run in Flutter or a browser.
   import { initializeApp, applicationDefault } from 'firebase-admin/app';
   import { getAuth } from 'firebase-admin/auth';
   initializeApp({ credential: applicationDefault(), projectId: process.env.GOOGLE_CLOUD_PROJECT });
   const user = await getAuth().getUser(process.env.ADMIN_UID);
   await getAuth().setCustomUserClaims(user.uid, { ...user.customClaims, admin: true });
   ```

6. Sign out and sign in again to obtain the claim. Create a station before creating materials. Accounts are managed in Firebase Console; the app does not expose arbitrary account deletion or a student directory.
7. Validate reader/admin separation against the deployed configuration with disposable users before production use. The public package does not contain your credentials, database exports, or production integration results.

## Security rules validation

The package includes emulator tests in `backend-tests/`. They test unauthenticated denial, administrator-only writes, profile ownership, request ownership, and prevention of role escalation. Install Node.js and Java, then:

```sh
cd backend-tests
npm install
cd ..
firebase emulators:exec --only firestore --project demo-reading-stations "node --test backend-tests/rules.test.cjs"
```

The `demo-` project ID is for local emulator tests. No credentials are required. See VALIDATION for whether these tests were actually run in the preparation environment.

## Important operational details

- This adapter uses HTTPS Firebase Auth and Firestore REST APIs; no native Firebase plugin setup is needed for Android or web.
- Auth tokens live in memory. Closing the app signs the user out; credentials are never persisted by this app.
- Account registration can succeed even if profile creation fails. The user can sign in again to retry profile initialization.
- Firestore requests are filtered by owner; rules are not used as result filters.
- The app uses explicit refresh, not live subscriptions. Catalogue search runs on the loaded collection; add pagination and indexed server-side search for large catalogues.
- Optional resource URLs are externally hosted HTTPS links. File uploads and Firebase Storage access are not part of this rebuild.
- Configure rate limits, budgets, abuse controls, and verified-email policies before real campus adoption.

Official references: [Flutter web deployment](https://docs.flutter.dev/deployment/web), [Firebase REST authentication](https://firebase.google.com/docs/reference/rest/auth), [Firestore REST](https://firebase.google.com/docs/firestore/use-rest-api), [custom administrator claims](https://firebase.google.com/docs/auth/admin/custom-claims).
