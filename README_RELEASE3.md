
# Dayline — Release 3 Notes

- ✅ **Sign in with Apple** integrated with Firebase Auth (nonce + idToken).
- ✅ **APNs token saved** to Firestore on registration (users.apnsToken).
- ✅ **Poll vote** now uses Firestore transaction (prevents race conditions / revotes).
- ✅ **Tasks**: Assign users on create + Done toggle in detail screen.
- ✅ **Chat**: unified pagination via ChatService (initial + load more).
- ✅ Minor: Group IDs use Firestore IDs; ICS escaping preserved.

> Capabilities to enable: Push Notifications, Sign in with Apple, Background Modes (remote-notification).
