import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shelf/supports/applog/applog.dart';
import 'package:shelf/utility/widget/form_widget/register_custom_text_field.dart';
import '../../../utility/constant/constant.dart' as constant;
import '../../../firebase_authentication_service/firebase_auth_helper.dart';
import '../../../firebase_authentication_service/validator.dart';
import '../model/bloc/register_bloc/register_bloc.dart';

class UserRegisterPage extends StatelessWidget {
  const UserRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(),
        ),
      ],
      child: const RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _contactTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusAddress = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;
  bool _obscurePassword = false;

  @override
  void dispose() {
    _focusName.dispose();
    _focusAddress.dispose();
    _focusEmail.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void resetSelection() {
    setState(() {
      _nameTextController.clear();
      _contactTextController.clear();
      _emailTextController.clear();
      _passwordTextController.clear();
      print('Selection reset');
    });
  }

  void _hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.successMessage)));
          resetSelection();
        }
        if (state is RegisterErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              _focusName.unfocus();
              _focusAddress.unfocus();
              _focusEmail.unfocus();
              _focusPassword.unfocus();
            },
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(constant.reverseBitmap),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Register',
                          style: constant.kHeadingTextStyle.textTheme
                              .titleLarge, // Example usage
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        form(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget form() {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: <Widget>[
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
            maxLines: 1,
            controller: _passwordTextController,
            focusNode: _focusPassword,
            validator: (value) => Validator.validatePassword(
              password: value,
            ),
            labelText: 'Password',
            prefixIcon: Icons.lock,
            suffixIcon:
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
            suffixIconOnPressed: _togglePasswordVisibility,
            obscureText: _obscurePassword,
          ),
          const SizedBox(height: 32.0),
          signUpButton(),
          const SizedBox(
            height: 40,
          ),
          alreadyRegisterText(),
        ],
      ),
    );
  }

  Widget signUpButton() {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _isProcessing = true;
        });
        _showLoadingDialog(context);

        if (_registerFormKey.currentState!.validate()) {
          User? user = await FirebaseAuthHelper.registerUsingEmailPassword(
            name: _nameTextController.text,
            contact: _contactTextController.text.trim(),
            email: _emailTextController.text.trim(),
            password: _passwordTextController.text,
          );

          if (user != null) {
            // Show email verification dialog
            _showEmailVerificationDialog(context);

            // Wait for the user to verify the email before allowing login
            bool emailVerified = await FirebaseAuthHelper.isEmailVerified();
            if (emailVerified) {
              // Proceed with further actions if needed
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Email is not verified.'),
                ),
              );
            }
          }

          setState(() {
            _isProcessing = false;
          });
          _hideLoadingDialog(context);
        } else {
          setState(() {
            _isProcessing = false;
          });
          _hideLoadingDialog(context);
        }
        resetSelection();
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(200, 50),
        foregroundColor: Colors.black,
        elevation: 12,
      ),
      child: const Text('Sign up'),
    );
  }


  void _showEmailVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Verification'),
          content: const Text(
              'Please verify your email before proceeding. Check your email for the verification link.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget alreadyRegisterText() {
    return RichText(
      text: TextSpan(
        text: 'Already registered? ',
        style: const TextStyle(color: Colors.black),
        children: <TextSpan>[
          TextSpan(
            text: 'Sign in',
            style:
                const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Get a reference to the TabController
                final tabController = DefaultTabController.of(context);
                // Switch to the second tab (index 1 for Register)
                tabController.animateTo(0);
              },
          ),
        ],
      ),
    );
  }
}
