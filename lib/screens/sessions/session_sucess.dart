import 'package:bookmywod_admin/screens/bottom_bar/bottom_bar_template.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouter;

void main() {
  runApp(const MaterialApp(
    home: SuccessScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F), // Dark Blue Background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Check Icon
              Container(
                width: 300,
                height: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const Image(image: AssetImage('assets/suc.png'))
              ),
              const SizedBox(height: 30),

              // Success Message
              const Text(
                "Session Added Successfully",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Subtext
              const Text(
                "Session added successfully, go by session categories to check it.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Back to Home Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).push('/home');
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomBarTemplate()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Back to Home",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
