import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shelf/supports/applog/applog.dart';
import '../../../../firebase_authentication_service/validator.dart';
import '../../../../utility/constant/constant.dart' as constant;
import '../../../../utility/customBackground/abstract_background.dart';
import '../../../../utility/customBackground/bottom_circular_clipper.dart';
import '../../../../utility/widget/file_photo_picker/file_photo_picker.dart';
import '../../../../utility/widget/form_widget/register_custom_text_field.dart';

class EditProfileView extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfileView({super.key, required this.userData});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}


class _EditProfileViewState extends State<EditProfileView> {

  final _nameTextController = TextEditingController();
  final _contactTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _bioTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusAddress = FocusNode();
  final _focusEmail = FocusNode();
  final _focusBio = FocusNode();

  bool _isProcessing = false;

  void initState() {
    super.initState();
    // Populate the text fields with user data
    _nameTextController.text = widget.userData['name'] ?? '';
    _contactTextController.text = widget.userData['contact'] ?? '';
    _emailTextController.text = widget.userData['email'] ?? '';
    _bioTextController.text = widget.userData['bio'] ?? '';
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _focusName.dispose();
    _focusAddress.dispose();
    _focusEmail.dispose();
    super.dispose();
  }

  //variable for photo picker
  String? photoName;
  File? selectedPhoto;

  void resetSelection() {
    setState(() {
      photoName = null;
      selectedPhoto = null;
      print('Selection reset');
    });
  }

  Future<void> updateUserProfile() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final user = _auth.currentUser;

      if (user != null) {
        String? photoUrl;

        if (selectedPhoto != null) {
          // Upload photo to Firebase Storage
          final storageRef = FirebaseStorage.instance.ref().child('user_photos/${user.uid}/$photoName');
          await storageRef.putFile(selectedPhoto!);
          photoUrl = await storageRef.getDownloadURL();
        }

        // Update Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'userPhoto': photoUrl,
          'name': _nameTextController.text,
          'contact': _contactTextController.text,
          'email': _emailTextController.text,
          'bio': _bioTextController.text,
        });

        // Update Firebase Authentication
        await user.updateDisplayName(_nameTextController.text);
        await user.updateEmail(_emailTextController.text);

        if (photoUrl != null) {
          await user.updatePhotoURL(photoUrl);
        }

        // Reauthenticate user if necessary
        await user.reload();
        User? updatedUser = _auth.currentUser;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // Prompt user to re-authenticate and then retry updating email
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please re-authenticate to update email')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${e.message}')),
        );
        AppLog.i("Update profile Error:", "${e.message}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
      AppLog.i("Update profile Error:", "${e}");
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constant.primaryColor,
      appBar: AppBar(
        backgroundColor: constant.primaryColor,
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: ClipPath(
                        clipper: BottomCircularClipper(),
                        child: CustomPaint(
                          painter: AbstractBackgroundPainter(),
                        ),
                      ),
                    ),
                    profileImageSetting(),
                  ],
                ),
                editProfileData(),
                updateButton(),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileImageSetting() {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, top: 60.0, right: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile Picture",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text("Change Profile Picture for your account"),
          const SizedBox(
            height: 12,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: constant.kBackGroundColor,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  spreadRadius: 3,
                  color: Colors.black12,
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: selectedPhoto != null
                          ? FileImage(selectedPhoto!)
                          : (widget.userData['userPhoto'] != null
                          ? NetworkImage(widget.userData['userPhoto'])
                          : AssetImage('assets/icons/user.png')) as ImageProvider,
                    ),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: constant.primaryColor,
                          foregroundColor: Colors.black,
                          elevation: 3,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          textStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10)) // Change button shape
                      ),
                      onPressed: () => pickPhoto(context, (name, photo) {
                        setState(() {
                          photoName = name;
                          selectedPhoto = photo;
                        });
                      }),
                      child: Text('Choose Profile Picture'),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: resetSelection,
                      icon: Icon(Icons.delete),
                      color: Colors.black54,
                    ),
                    Spacer(),
                  ],
                ),
                if (photoName != null) Text('$photoName'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget editProfileData() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile Settings",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text("Change identifying details for your account"),
          const SizedBox(
            height: 12,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: constant.kBackGroundColor,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  spreadRadius: 3,
                  color: Colors.black12,
                )
              ],
            ),
            child: Column(
              children: [
                RegisterCustomTextField(
                  maxLines: 1,
                  controller: _nameTextController,
                  focusNode: _focusName,
                  validator: (value) => Validator.validateName(
                    name: value,
                  ),
                  labelText: 'Name',
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 12.0),
                RegisterCustomTextField(
                  maxLines: 1,
                  controller: _contactTextController,
                  focusNode: _focusAddress,
                  validator: (value) => Validator.validateAddress(
                    address: value,
                  ),
                  labelText: 'Contact',
                  prefixIcon: Icons.phone,
                ),
                const SizedBox(height: 12.0),
                RegisterCustomTextField(
                  maxLines: 1,
                  controller: _emailTextController,
                  focusNode: _focusEmail,
                  validator: (value) => Validator.validateEmail(
                    email: value,
                  ),
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 12.0),
                RegisterCustomTextField(
                  maxLines: 4,
                  controller: _bioTextController,
                  focusNode: _focusBio,
                  validator: (value) => Validator.validatePassword(
                    password: value,
                  ),
                  labelText: 'Bio',
                  prefixIcon: Icons.description_outlined,
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget updateButton() {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: constant.kLightBlackColor,
          foregroundColor: Colors.black,
          elevation: 3,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _isProcessing
            ? null
            : () async {
          if (_nameTextController.text.isEmpty ||
              _emailTextController.text.isEmpty ||
              _contactTextController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please fill all the fields')),
            );
            return;
          }

          await updateUserProfile();
          resetSelection();
        },
        child: _isProcessing
            ? CircularProgressIndicator()
            : Text('Update'),
      ),
    );
  }
}
