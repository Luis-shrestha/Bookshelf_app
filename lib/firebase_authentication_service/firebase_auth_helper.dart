import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../supports/applog/applog.dart';

class FirebaseAuthHelper {
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String contact,
    required String email,
    required String password,
    File? userPhoto,
    String? bio,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateDisplayName(name);

      String? photoURL;
      if (userPhoto != null) {
        // Upload photo to Firebase Storage
        FirebaseStorage storage = FirebaseStorage.instance;
        TaskSnapshot snapshot =
            await storage.ref('userPhotos/${user.uid}').putFile(userPhoto);
        photoURL = await snapshot.ref.getDownloadURL();
        await user.updatePhotoURL(photoURL);
      }

      await user.reload();
      user = auth.currentUser;

      // Send verification email
      await user!.sendEmailVerification();

      // Prepare user data to save to Firestore
      Map<String, dynamic> userData = {
        'name': name,
        'contact': contact,
        'email': email,
        'bio': bio,
        'role': 'user', // Specify role
      };
      if (photoURL != null) {
        userData['photoURL'] = photoURL;
      }
      if (bio != null) {
        userData['bio'] = bio;
      }

      // Save additional user information to Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(user!.uid).set(userData);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  static Future<bool> isEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;
      return updatedUser?.emailVerified ?? false;
    }
    return false;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      AppLog.i("Firebase auth helper", "${user}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AppLog.i('No user found for that email.', '');
      } else if (e.code == 'wrong-password') {
        AppLog.i('Wrong password provided.', '');
      }
    }

    return user;
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}
