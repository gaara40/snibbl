import 'package:firebase_auth/firebase_auth.dart';

bool isEmailPassSignedIn(User user) {
  return user.providerData.any(
    (info) => info.providerId == EmailAuthProvider.PROVIDER_ID,
  );
}

bool isGoogleSignedIn(User user) {
  return user.providerData.any(
    (info) => info.providerId == GoogleAuthProvider().providerId,
  );
}
