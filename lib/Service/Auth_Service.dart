import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Create storage
final storage = FlutterSecureStorage();

class AuthClass {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> storeTokenAndData(UserCredential userCredential) async {
    try {
      // Retrieve ID token from the user
      String? token = await userCredential.user?.getIdToken();

      if (token != null) {
        // Store the token securely
        await storage.write(key: "token", value: token);

        // Optionally store user details (as string)
        await storage.write(key: "userCredential", value: userCredential.toString());
      } else {
        print("Error: Token is null.");
      }
    } catch (e) {
      print("Error in storing token and data: $e");
    }
  }

  Future<String?> getToken() async {
    try {
      // Retrieve the token securely
      return await storage.read(key: "token");
    } catch (e) {
      print("Error in getting token: $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      // Clear user data from secure storage
      await storage.delete(key: "token");
      await storage.delete(key: "userCredential");

      // Sign out from Firebase
      await auth.signOut();

      print("User logged out successfully");
    } catch (e) {
      print("Error in logout: $e");
    }
  }
}