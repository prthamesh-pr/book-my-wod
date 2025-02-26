import 'package:bookmywod_admin/screens/bottom_bar/bottom_bar_template.dart';
import 'package:bookmywod_admin/utils/shared_preference_helper.dart';
import 'package:bookmywod_admin/bloc/states/auth_state.dart' as CustomAuthState;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookmywod_admin/bloc/auth_bloc.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_login.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_should_register.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_logged_out.dart';
import 'package:bookmywod_admin/services/auth/auth_exceptions.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:bookmywod_admin/shared/constants/regex.dart';
import 'package:bookmywod_admin/shared/custom_text_field.dart';
import 'package:bookmywod_admin/shared/custom_button.dart';
import 'package:bookmywod_admin/shared/show_snackbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as Supabase;

import '../../bloc/events/auth_event_signin_with_google.dart';

class SignInScreen extends StatefulWidget {

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool rememberMe = false;
  final SupabaseClient supabase = Supabase.Supabase.instance.client;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loadSaveCredentials();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSaveCredentials() async {
    final savedEmail = await SharedPreferrenceHelper.getString('email');
    final savedPassword = await SharedPreferrenceHelper.getString('password');
    final savedRememberMe =
        await SharedPreferrenceHelper.getBool('remember_me') ?? false;

    if (savedRememberMe) {
      setState(() {
        _emailController.text = savedEmail ?? '';
        _passwordController.text = savedPassword ?? '';
        rememberMe = savedRememberMe;
      });
    }
  }

  Future<void> _saveCredentials() async {
    if (rememberMe) {
      await SharedPreferrenceHelper.setString('email', _emailController.text);
      await SharedPreferrenceHelper.setString(
          'password', _passwordController.text);
      await SharedPreferrenceHelper.setBool('remember_me', rememberMe);
    } else {
      await SharedPreferrenceHelper.remove('email');
      await SharedPreferrenceHelper.remove('password');
      await SharedPreferrenceHelper.remove('remember_me');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      const webClientId = '281809501684-9g294ilcupmj39m8ah79id3nh6ge0ocg.apps.googleusercontent.com';

      /// TODO: update the iOS client ID with your own.
      /// iOS Client ID that you registered with Google Cloud.
      const iosClientId = 'my-ios.apps.googleusercontent.com';
      // Add your Android client ID here
      const androidClientId = '281809501684-meo33phfg32uedsfhjtcg10ibssi0uf8.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: androidClientId,  // Update with your Android Client ID
        scopes: ['email'],
        serverClientId: webClientId,
      );
      await googleSignIn.signOut();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return; // User canceled sign-in

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) throw 'No Access Token found.';
      if (idToken == null) throw 'No ID Token found.';

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomBarTemplate(),
          ),
        );
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, CustomAuthState.AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          await _saveCredentials();
          if (state.exception is UserNotFoundAuthException) {
            await showSnackbar(
              context,
              'User not found',
              type: SnackbarType.error,
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showSnackbar(
              context,
              'Cannot find a user with the credentials',
              type: SnackbarType.error,
            );
          } else if (state.exception is GenericAuthException) {
            await showSnackbar(
              context,
              'Authentication failed',
              type: SnackbarType.error,
            );
          }
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 120),
                  Image.asset('assets/logo.png'),
                  const SizedBox(height: 40),
                  Text(
                    'Sign In',
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.09),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email can't be empty";
                      } else if (!emailValid.hasMatch(value)) {
                        return "Invalid email provided";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    onVisibilityToggle: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Sign In',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final email = _emailController.text;
                        final password = _passwordController.text;
                        context.read<AuthBloc>().add(AuthEventLogin(email: email, password: password));
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(child: Text('or', style: TextStyle(fontSize: 30))),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton('assets/auth/google.svg', (){
                        context.read<AuthBloc>().add(
                          AuthEventSignInWithGoogle(),
                        );
                      }),
                      _buildSocialButton('assets/auth/facebook.svg', () {}),
                      _buildSocialButton('assets/auth/apple.svg', () {}),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don’t have any account? ", style: TextStyle(fontSize: 16)),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthEventShouldRegister());
                        },
                        child: Text('Sign Up', style: TextStyle(color: customBlue, fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(assetPath, width: 40, height: 40),
    );
  }
}
