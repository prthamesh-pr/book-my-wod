import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: customGrey,
      body: Center(
        child: CircularProgressIndicator(
          color: customWhite,
        ),
      ),
    );
  }
}
