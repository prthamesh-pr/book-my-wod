import 'package:bookmywod_admin/shared/constants/colors.dart';
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
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: 46,
          // height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 3,vertical: 10),
          // padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? customBlue : customDateBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: customDateBg, width: 1.5), // Subtle border for unselected
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day,
                style: TextStyle(
                  color: customWhite,
                  fontSize: tileWidth * 0.4, // Responsive font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                weekday,
                style: TextStyle(
                  color: customWhite,
                  fontSize: tileWidth * 0.3, // Responsive font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
