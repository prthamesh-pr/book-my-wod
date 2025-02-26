import 'package:bookmywod_admin/services/database/models/session_model.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:bookmywod_admin/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShowSessionDetailsView extends StatelessWidget {
  final SessionModel sessionModel;
  final SupabaseDb supabaseDb;
  final String creatorId;
  final String catagoryId;
  const ShowSessionDetailsView({
    super.key,
    required this.sessionModel,
    required this.supabaseDb,
    required this.creatorId,
    required this.catagoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Session Details"),
        backgroundColor: scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 16, right: 16),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    sessionModel.coverImage ??
                        'https://placeholder.com/default-image.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sessionModel.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    sessionModel.description!,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const Divider(),
                  SizedBox(height: 10),
                  Text('Time Slots', style: TextStyle(fontSize: 18)),
                  Text(
                    sessionModel.timeSlots.isNotEmpty
                        ? sessionModel.timeSlots.map((slot) {
                      final startTime = slot['start_time'] ?? 'N/A';
                      final endTime = slot['end_time'] ?? 'N/A';
                      return '$startTime - $endTime';
                    }).join(', ')
                        : 'No time slots available',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),


                  SizedBox(height: 10),
                  Text('Days', style: TextStyle(fontSize: 18)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sessionModel.days.map((day) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          '• $day',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: CustomButton(
                      text: 'Edit',
                      onPressed: () {
                        GoRouter.of(context).push('/create-session', extra: {
                          'supabaseDb': supabaseDb,
                          'catagoryId': catagoryId,
                          'creatorId': creatorId,
                          'sessionModel': sessionModel,
                          'gymId': sessionModel.gymId,
                        });
                      },
                      width: 120,
                      height: 40,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
