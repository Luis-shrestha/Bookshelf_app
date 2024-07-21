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
      // Create user with email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

      // Update the user's display name
      await user!.updateDisplayName(name);

      String? photoURL;
      if (userPhoto != null) {
        // Upload photo to Firebase Storage
        FirebaseStorage storage = FirebaseStorage.instance;
        TaskSnapshot snapshot = await storage
            .ref('userPhotos/${user.uid}')
            .putFile(userPhoto);
        photoURL = await snapshot.ref.getDownloadURL();
        await user.updatePhotoURL(photoURL);
      }

      // Prepare user data to save to Firestore
      Map<String, dynamic> userData = {
        'name': name,
        'contact': contact,
        'email': email,
        'userPhoto': userPhoto,
        'bio': bio,
      };
      if (photoURL != null) {
        userData['photoURL'] = photoURL;
      }
      if (bio != null) {
        userData['bio'] = bio;
      }

      // Save additional user information to Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(user.uid).set(userData);

      AppLog.i("User registered and data saved to Firestore:", "${user.uid}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AppLog.i('The password provided is too weak.', '');
      } else if (e.code == 'email-already-in-use') {
        AppLog.i('The account already exists for that email.', '');
      }
    } catch (e) {
      AppLog.i('Firebase auth helper', '${e}');
    }

    return user;
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
}

