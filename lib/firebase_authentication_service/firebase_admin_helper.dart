import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAdminHelper {
  static Future<User?> registerAdminUsingEmailPassword({
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
        TaskSnapshot snapshot = await storage
            .ref('adminPhotos/${user.uid}')
            .putFile(userPhoto);
        photoURL = await snapshot.ref.getDownloadURL();
        await user.updatePhotoURL(photoURL);
      }

      await user.reload();
      user = auth.currentUser;

      // Prepare admin data to save to Firestore
      Map<String, dynamic> adminData = {
        'name': name,
        'contact': contact,
        'email': email,
        'bio': bio,
        'role': 'admin', // Specify role as admin
      };
      if (photoURL != null) {
        adminData['photoURL'] = photoURL;
      }
      if (bio != null) {
        adminData['bio'] = bio;
      }

      // Save additional admin information to Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('admins').doc(user!.uid).set(adminData);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('Error: ${e.message}');
      }
    } catch (e) {
      print('Error: $e');
    }

    return user;
  }

  static Future<User?> signInAdminUsingEmailPassword({
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

      // Check if the user has admin privileges
      DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance
          .collection('admins')
          .doc(user!.uid)
          .get();

      if (!adminSnapshot.exists) {
        print('No admin found for that email.');
        await auth.signOut();
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      } else {
        print('Error: ${e.message}');
      }
    } catch (e) {
      print('Error: $e');
    }

    return user;
  }

  static Future<void> deleteUser({
    required String uid,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> deleteAdmin({
    required String uid,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('admins').doc(uid).delete();
      await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      print('Error: $e');
    }
  }
}
