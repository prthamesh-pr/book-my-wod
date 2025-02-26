import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
  });

  final Map<String, dynamic> event;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(
          '/booking',
          extra: {
            'eventDetails': event,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              event['assets'],
              width: 80,
              height: 100,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: event['Name'],
                        style: GoogleFonts.barlow(
                          textStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: ' ${event['Seats Left']}',
                        style: GoogleFonts.barlow(
                          textStyle: TextStyle(
                            fontSize: 16,
                            color: customBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/clock.svg'),
                    SizedBox(width: 8),
                    Text(
                      event['Time'],
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: customGrey,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/person.svg'),
                    SizedBox(width: 8),
                    Text(
                      event['Seat'],
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
