import 'package:bookmywod_admin/bloc/auth_bloc.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_create_gym.dart';
import 'package:bookmywod_admin/services/auth/auth_user.dart';
import 'package:bookmywod_admin/shared/custom_text_field.dart';
import 'package:bookmywod_admin/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateGymView extends StatefulWidget {
  final AuthUser authUser;
  const CreateGymView({
    super.key,
    required this.authUser,
  });

  @override
  State<CreateGymView> createState() => _CreateGymViewState();
}

class _CreateGymViewState extends State<CreateGymView> {
  late final TextEditingController _gymNameController;
  late final TextEditingController _gymAddressController;

  @override
  void initState() {
    _gymNameController = TextEditingController();
    _gymAddressController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _gymNameController.dispose();
    _gymAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Gym'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              label: 'Enter gym name',
              prefixIcon: Icon(Icons.sports_gymnastics),
              controller: _gymNameController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              label: 'Enter gym address',
              prefixIcon: Icon(Icons.location_on),
              controller: _gymAddressController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
                text: 'Create Gym',
                onPressed: () {
                  context.read<AuthBloc>().add(AuthEventCreateGym(
                        authUser: widget.authUser,
                        gymName: _gymNameController.text,
                        gymAddress: _gymAddressController.text,
                      ));
                })
          ],
        ),
      ),
    );
  }
}
