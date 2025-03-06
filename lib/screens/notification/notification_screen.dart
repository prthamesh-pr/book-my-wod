// import 'package:bookmywod_admin/shared/constants/colors.dart';
// import 'package:bookmywod_admin/shared/constants/notification_constant.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final todayNotifications = notifications
//         .where((notification) => notification['category'] == 'Today')
//         .toList();
//     final lastWeekNotifications = notifications
//         .where((notification) => notification['category'] == 'Last Week')
//         .toList();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notification'),
//         backgroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'You have 3 unread notification',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             SizedBox(height: 5),
//             Divider(),
//             SizedBox(height: 5),
//             Expanded(
//               child: ListView(
//                 children: [
//                   // Today section
//                   if (todayNotifications.isNotEmpty) ...[
//                     Text(
//                       'Today',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8),
//                     ...todayNotifications.map((notification) =>
//                         NotificationTile(notification: notification)),
//                     SizedBox(height: 16),
//                   ],
//
//                   // Last Week section
//                   if (lastWeekNotifications.isNotEmpty) ...[
//                     Text(
//                       'Last Week',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8),
//                     ...lastWeekNotifications.map((notification) =>
//                         NotificationTile(notification: notification)),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class NotificationTile extends StatelessWidget {
//   final Map<String, dynamic> notification;
//
//   const NotificationTile({super.key, required this.notification});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 40,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: customDarkBlue,
//             ),
//             child: SvgPicture.asset('assets/icons/history.svg'),
//           ),
//           SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   notification['title'],
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   notification['description'],
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(width: 16),
//           Text(
//             notification['time'],
//             style: TextStyle(color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {"category": "Today", "title": "Upcoming Session Reminder", "description": "Sed ut perspiciatis unde omnis iste natusor sit voluptatem accusantium.", "time": "2 min"},
      {"category": "Today", "title": "Booking Confirmation", "description": "Sed ut perspiciatis unde omnis iste natusor sit voluptatem accusantium.", "time": "5 min"},
      {"category": "Today", "title": "Booking Cancellation Confirmation", "description": "Sed ut perspiciatis unde omnis iste natusor sit voluptatem accusantium.", "time": "5 min"},
      {"category": "Last Week", "title": "Upcoming Session Reminder", "description": "Sed ut perspiciatis unde omnis iste natusor sit voluptatem accusantium.", "time": "5 min"},
      {"category": "Last Week", "title": "Upcoming Session Reminder", "description": "Sed ut perspiciatis unde omnis iste natusor sit voluptatem accusantium.", "time": "5 min"},
    ];

    final todayNotifications =
    notifications.where((n) => n['category'] == 'Today').toList();
    final lastWeekNotifications =
    notifications.where((n) => n['category'] == 'Last Week').toList();

    return Scaffold(
      backgroundColor: Color(0xFF0F172A), // Dark background
      appBar: AppBar(
        backgroundColor: Color(0xFF0F172A),
        elevation: 0,
        title: Text("Notification", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You have 3 unread notification",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Divider(color: Colors.white24),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  // Today section
                  if (todayNotifications.isNotEmpty) ...[
                    sectionTitle("Today"),
                    ...todayNotifications
                        .map((notification) => NotificationTile(notification)),
                    SizedBox(height: 16),
                  ],
                  Divider(color: Colors.white24),

                  // Last Week section
                  if (lastWeekNotifications.isNotEmpty) ...[
                    sectionTitle("Last Week"),
                    ...lastWeekNotifications
                        .map((notification) => NotificationTile(notification)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Map<String, dynamic> notification;
  const NotificationTile(this.notification, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.2),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/history.svg',
                color: Colors.blueAccent,
                height: 20,
              ),
            ),
          ),
          SizedBox(width: 12),

          // Notification content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  notification['description'],
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Time
          Text(
            notification['time'],
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
