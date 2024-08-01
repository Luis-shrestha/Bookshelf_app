import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shelf/adminScreen/authenticationScreen/admin_login_register_view.dart';
import 'package:shelf/utility/widget/form_widget/custom_text_field.dart';
import '../../../firebase_authentication_service/firebase_auth_helper.dart';
import '../../../firebase_authentication_service/validator.dart';
import '../../../utility/constant/constant.dart' as constant;
import '../main_screen/home_screen.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;
  bool _obscurePassword = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(constant.bitmap),
                  fit: BoxFit.fill,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      title(),
                      loginForm(),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 12),
      child: Column(
        children: [
          const Text('Welcome to BookShelf app',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          Text(
            'Login First',
            style: constant.kHeadingTextStyle.textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          CustomTextField(
            focusNode: _focusEmail,
            validator: (value) => Validator.validateEmail(
              email: value,
            ),
            controller: _emailTextController,
            labelText: 'Email',
            prefixIcon: Icons.email,
          ),
          const SizedBox(height: 8.0),
          CustomTextField(
            focusNode: _focusPassword,
            validator: (value) => Validator.validatePassword(
              password: value,
            ),
            controller: _passwordTextController,
            labelText: 'Password',
            prefixIcon: Icons.lock,
            suffixIcon:
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            suffixIconOnPressed: _togglePasswordVisibility,
            obscureText: _obscurePassword,
          ),
          const SizedBox(height: 14.0),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                // onTap: (){},
                child: Text("forget password?"),
              ),
            ],
          ),
          const SizedBox(height: 14.0),
          loginButton(),
          const SizedBox(
            height: 40,
          ),
          RichText(
            text: TextSpan(
              text: "Don't have an account?",
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'Sign up',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigate to the Register Page
                      final tabController = DefaultTabController.of(context);
                      if (tabController != null) {
                        // Switch to the second tab (index 1 for Register)
                        tabController.animateTo(1);
                      }
                    },
                ),
              ],
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLoginRegisterView()));
            },
            child:  Text(
              "Admin Login",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                 fontSize: 16,
                shadows: [
                  Shadow(
                    color: Colors.black45, // Use a darker color for the shadow
                    blurRadius: 5.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginButton() {
    return _isProcessing
        ? const CircularProgressIndicator()
        : ElevatedButton(
      onPressed: () async {
        _focusEmail.unfocus();
        _focusPassword.unfocus();

        if (_formKey.currentState!.validate()) {
          setState(() {
            _isProcessing = true;
          });

          User? user = await FirebaseAuthHelper.signInUsingEmailPassword(
            email: _emailTextController.text,
            password: _passwordTextController.text,
          );

          setState(() {
            _isProcessing = false;
          });

          if (user != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(child: Text('Email or password Error')),
              ),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
          fixedSize: const Size(200, 50),
          backgroundColor: Colors.blue.shade100,
        elevation: 12,),
      child: Text(
        'Login',
        style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color),
      ),
    );
  }


}
