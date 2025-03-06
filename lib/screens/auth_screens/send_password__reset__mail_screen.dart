// ignore_for_file: use_build_context_synchronously

import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookmywod_admin/bloc/auth_bloc.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_forgot_password.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_logout.dart';
import 'package:bookmywod_admin/bloc/states/auth_state.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_forgot_password.dart';
import 'package:bookmywod_admin/services/auth/auth_exceptions.dart';
import 'package:bookmywod_admin/shared/constants/regex.dart';
import 'package:bookmywod_admin/shared/custom_text_field.dart';
import 'package:bookmywod_admin/shared/custom_button.dart';
import 'package:bookmywod_admin/shared/show_snackbar.dart';

class SendPasswordResetMailScreen extends StatefulWidget {
  const SendPasswordResetMailScreen({super.key});

  @override
  State<SendPasswordResetMailScreen> createState() =>
      _SendPasswordResetMailScreenState();
}

class _SendPasswordResetMailScreenState
    extends State<SendPasswordResetMailScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _emailController.clear();
            await showSnackbar(
              context,
              'Password reset link sent to your registered email',
              type: SnackbarType.success,
            );
          }
          if (state.exception is UserNotFoundAuthException) {
            await showSnackbar(
              context,
              'User not found',
              type: SnackbarType.error,
            );
          }

          if (state.exception != null) {
            await showSnackbar(
              context,
              'Please check your credentials, and try again',
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png'),
                const SizedBox(height: 40),
                Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.09,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Provide your email address to reset your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  prefixIcon: Icon(Icons.email),
                  label: 'Email Address',
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
                CustomButton(
                  text: 'Reset Password',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                            AuthEventForgotPassword(
                              email: _emailController.text,
                            ),
                          );
                      showSnackbar(
                        context,
                        'A password reset email has been send to your email',
                        type: SnackbarType.success,
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthEventLogout());
                  },
                  child: Text(
                    'Back to login',
                    style: TextStyle(
                      color: customWhite,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
