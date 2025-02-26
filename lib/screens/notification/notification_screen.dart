import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:bookmywod_admin/shared/constants/notification_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todayNotifications = notifications
        .where((notification) => notification['category'] == 'Today')
        .toList();
    final lastWeekNotifications = notifications
        .where((notification) => notification['category'] == 'Last Week')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You have 3 unread notification',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),
            Expanded(
              child: ListView(
                children: [
                  // Today section
                  if (todayNotifications.isNotEmpty) ...[
                    Text(
                      'Today',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ...todayNotifications.map((notification) =>
                        NotificationTile(notification: notification)),
                    SizedBox(height: 16),
                  ],

                  // Last Week section
                  if (lastWeekNotifications.isNotEmpty) ...[
                    Text(
                      'Last Week',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ...lastWeekNotifications.map((notification) =>
                        NotificationTile(notification: notification)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: customDarkBlue,
            ),
            child: SvgPicture.asset('assets/icons/history.svg'),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  notification['description'],
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Text(
            notification['time'],
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
