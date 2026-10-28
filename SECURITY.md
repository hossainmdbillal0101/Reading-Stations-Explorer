# Security and privacy

Never commit access tokens, passwords, service-account JSON, private keys, keystores, signing passwords, `.env` files, real student data, or local Firebase configuration. Keep the original report private unless you prepare and check a redacted public copy.

The default Pages build uses sample data only. Public demo visitors cannot switch to administrator or change the catalogue. Administrator controls require a configured live backend, authentication, and a signed administrator claim. In Firebase mode, authorization is enforced by Firestore rules against a signed Firebase custom claim; decoding a token in the UI is not treated as authorization by itself.

Firebase **client** configuration is ultimately readable inside a compiled client. An ignored JSON file prevents accidental repository publication; it cannot make client configuration secret after deployment. The public portfolio demo contains no Firebase configuration. Service-account keys and administrator tokens must never enter any client build.

Use a separate Firebase project, restrict its client API key to the required APIs, set appropriate application restrictions, deploy the supplied rules, and validate access with the emulator before admitting users. Rules deny access by default. Signed-in readers may read the catalogue, access their own profile, and create/read their own requests. Administrators can maintain the catalogue and resolve requests. No profile list or student directory is exposed.

Passwords are sent over HTTPS to Firebase Auth. ID/refresh tokens live in memory and are discarded on sign-out or application restart. The demo persists fictional catalogue data only; do not use it to store personal information.

External reading resources must use HTTPS and open outside the app. Only publish links and materials you have permission to distribute. Storage uploads are not implemented and storage rules deny all access.

If a credential was previously exposed, revoke/rotate it through its provider. Removing it from the latest commit does not remove it from Git history. Do not paste suspected credentials into a public issue.

This package includes a local publication scan, which detects common secret formats and prohibited filenames. It is one check, not a guarantee against every secret or identifying detail.
