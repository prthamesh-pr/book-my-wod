import 'package:bookmywod_admin/screens/components/event_card.dart';
import 'package:bookmywod_admin/shared/constants/all_event_constants.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:flutter/material.dart';

class AllSessionView extends StatefulWidget {
  const AllSessionView({super.key});

  @override
  State<AllSessionView> createState() => _AllSessionViewState();
}

class _AllSessionViewState extends State<AllSessionView> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        title: Text(
          'All Session',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.white10,
                ),
                itemCount: allEvents.length,
                itemBuilder: (context, index) {
                  final event = allEvents[index];
                  return EventCard(event: event);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
