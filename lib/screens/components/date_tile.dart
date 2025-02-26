import 'package:flutter/material.dart';

class DateTile extends StatelessWidget {
  final String day;
  final String weekday;
  final bool isSelected;
  final VoidCallback onTap;

  const DateTile({
    super.key,
    required this.day,
    required this.weekday,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double tileWidth = screenWidth * 0.12; // Adjusts based on screen width

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: tileWidth.clamp(50, 80), // Ensures proper size on all screens
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                color: Colors.white,
                fontSize: tileWidth * 0.4, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5), // Ensures spacing between text
            Text(
              weekday,
              style: TextStyle(
                color: Colors.white70,
                fontSize: tileWidth * 0.3, // Responsive font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
