// ignore_for_file: use_build_context_synchronously

import 'package:bookmywod_admin/bloc/auth_bloc.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_logout.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_register.dart';
import 'package:bookmywod_admin/bloc/states/auth_state.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_registering.dart';
import 'package:bookmywod_admin/services/auth/auth_exceptions.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:bookmywod_admin/shared/constants/regex.dart';
import 'package:bookmywod_admin/shared/custom_text_field.dart';
import 'package:bookmywod_admin/shared/custom_button.dart';
import 'package:bookmywod_admin/shared/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;
  late final TextEditingController _gymNameController;
  late final TextEditingController _gymAddressController;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _gymNameController = TextEditingController();
    _gymAddressController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _gymNameController.dispose();
    _gymAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showSnackbar(
              context,
              'Weak Password',
              type: SnackbarType.error,
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showSnackbar(
              context,
              'Email already in use',
              type: SnackbarType.error,
            );
          } else if (state.exception is GenericAuthException) {
            await showSnackbar(
              context,
              'Authentication failed',
              type: SnackbarType.error,
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showSnackbar(
              context,
              'Invalid email address',
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
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 120),
                  Image.asset(
                    'assets/logo.png',
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.09),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Join us and unlock endless possibilities!',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.055),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    label: 'Name',
                    prefixIcon: Icon(Icons.person),
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name can't be empty";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    label: 'Gym Name',
                    prefixIcon: Icon(Icons.sports_gymnastics),
                    controller: _gymNameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Gym name can't be empty";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    label: 'Gym Address',
                    prefixIcon: Icon(Icons.location_on),
                    controller: _gymAddressController,
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Gym address can't be empty";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    label: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    controller: _passwordController,
                    obscureText: true,
                    isVisible: _isPasswordVisible,
                    onVisibilityToggle: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid password';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      text: 'Sign Up',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          final name = _nameController.text;
                          context.read<AuthBloc>().add(
                                AuthEventRegister(
                                  email: email,
                                  password: password,
                                  fullName: name,
                                  gymName: _gymNameController.text,
                                  gymAddress: _gymAddressController.text,
                                ),
                              );
                          showSnackbar(
                            context,
                            'Verification email sent to $email',
                            type: SnackbarType.success,
                          );
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have any account? ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                AuthEventLogout(),
                              );
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: customBlue,
                            fontSize: 16,
                          ),
                        ),
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
}
