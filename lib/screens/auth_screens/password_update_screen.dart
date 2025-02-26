// ignore_for_file: use_build_context_synchronously

import 'package:bookmywod_admin/bloc/auth_bloc.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_logout.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_update_password.dart';
import 'package:bookmywod_admin/bloc/states/auth_state.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_update_password.dart';
import 'package:bookmywod_admin/shared/custom_text_field.dart';
import 'package:bookmywod_admin/shared/custom_button.dart';
import 'package:bookmywod_admin/shared/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordUpdateScreen extends StatefulWidget {
  const PasswordUpdateScreen({super.key});

  @override
  State<PasswordUpdateScreen> createState() => _PasswordUpdateScreenState();
}

class _PasswordUpdateScreenState extends State<PasswordUpdateScreen> {
  late final TextEditingController _passwordController;
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateUpdatePassword) {
          if (state.hasUpdatedPassword) {
            _passwordController.clear();
            await showSnackbar(
              context,
              'Password reset link sent',
              type: SnackbarType.success,
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
                  'Update Password',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.09,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Provide your updated password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  prefixIcon: Icon(Icons.lock),
                  label: 'Password',
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
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Update Password',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newPassword = _passwordController.text;
                      context.read<AuthBloc>().add(
                            AuthEventUpdatePassword(newPassword: newPassword),
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
                      color: Colors.white,
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
