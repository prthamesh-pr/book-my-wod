import 'package:bookmywod_admin/screens/components/date_tile.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:bookmywod_admin/shared/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SessionView extends StatefulWidget {
  final SupabaseDb supabaseDb;
  final String catagoryName;
  final String creatorId;
  final String catagoryId;
  final String gymId;

  const SessionView({
    super.key,
    required this.supabaseDb,
    required this.catagoryName,
    required this.creatorId,
    required this.catagoryId,
    required this.gymId,
  });

  @override
  State<SessionView> createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = DateTime.now().weekday - 1;
  }

  List<DateTime> getWeekDates() {
    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = getWeekDates();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customDarkBlue,
        title: Text(
          widget.catagoryName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).push('/create-session', extra: {
                'supabaseDb': widget.supabaseDb,
                'catagoryId': widget.catagoryId,
                'creatorId': widget.creatorId,
                'gymId': widget.gymId,
              });
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: widget.supabaseDb.getAllSessionsByCatagory(widget.catagoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingScreen(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('No Session yet created'),
            );
          } else if (snapshot.data == null) {
            return Center(
              child: Text('No Session yet created'),
            );
          } else {
            final data = snapshot.data ?? [];

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: customDarkBlue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              DateTime date = weekDates[index];

                              return DateTile(
                                day: DateFormat('d').format(date),
                                weekday: DateFormat('EEE').format(date),
                                isSelected: index == selectedIndex,
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                              );
                            }),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        DateFormat('EEEE, d MMMM, yyyy')
                            .format(weekDates[selectedIndex]),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        final session = data[index];
                        return GestureDetector(
                          onTap: () {
                            GoRouter.of(context)
                                .push('/session-details', extra: {
                              'sessionModel': session,
                              'catagoryId': widget.catagoryId,
                              'creatorId': widget.creatorId,
                              'supabaseDb': widget.supabaseDb,
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration:
                                    BoxDecoration(color: Colors.transparent),
                                child: Row(
                                  children: [
                                    Image.network(
                                      session.coverImage ??
                                          'https://placeholder.com/default-image.jpg',
                                      width: 100, // Add appropriate dimensions
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error);
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          session.name,
                                          style: GoogleFonts.barlow(
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                'assets/icons/clock.svg'),
                                            SizedBox(width: 8),
                                            Text(
                                              session.timeSlots
                                                      .take(2)
                                                      .map((slot) {
                                                    final startTime =
                                                        slot['start_time'] ??
                                                            '';
                                                    final endTime =
                                                        slot['end_time'] ?? '';
                                                    return '$startTime - $endTime';
                                                  }).join(', ') +
                                                  (session.timeSlots.length > 2
                                                      ? '...'
                                                      : ''),
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
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
                                            SvgPicture.asset(
                                                'assets/icons/person.svg'),
                                            SizedBox(width: 8),
                                            Text(
                                              session.entryLimit.toString(),
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
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 16,
                      ),
                      itemCount: data.length,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
