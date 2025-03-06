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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: customDarkBlue,
        title: Text(
          widget.catagoryName,
          style: GoogleFonts.barlow(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
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
            icon: const Icon(Icons.add, color: Colors.white),
          )
        ],
      ),
      body: StreamBuilder(
        stream: widget.supabaseDb.getAllSessionsByCatagory(widget.catagoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingScreen());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text(
                'No Session yet created',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final data = snapshot.data ?? [];

          return Column(
            children: [
              // Date Selector Section
              Container(
                width: double.infinity,

                decoration: const BoxDecoration(
                  color: customDarkBlue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.1,
                        child: ListView.builder(
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
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        DateFormat('EEEE, d MMMM yyyy').format(weekDates[selectedIndex]),
                        style: GoogleFonts.barlow(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),

              // Session List Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: data.isEmpty
                      ? const Center(
                    child: Text(
                      'No Sessions Available',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                      : ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final session = data[index];
                      String formatTime(String time) {
                        return DateFormat.jm()
                            .format(DateFormat("HH:mm").parse(time))
                            .replaceAllMapped(RegExp(r'([APM]+)$'), (match) => ' ${match.group(1)}'); // Adds space before AM/PM
                      }

                      String startTime = session.timeSlots.isNotEmpty
                          ? formatTime(session.timeSlots[0]['start_time']!)
                          : 'N/A';

                      String endTime = session.timeSlots.isNotEmpty
                          ? formatTime(session.timeSlots[0]['end_time']!)
                          : 'N/A';


                      return GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push('/session-details', extra: {
                            'sessionModel': session,
                            'catagoryId': widget.catagoryId,
                            'creatorId': widget.creatorId,
                            'supabaseDb': widget.supabaseDb,
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: customDarkBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  session.coverImage ?? 'https://placeholder.com/default-image.jpg',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error, color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      session.name,
                                      style: GoogleFonts.barlow(fontSize: 20, color: customWhite),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/clock.svg',
                                          width: 16,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '$startTime - $endTime',
                                          style: const TextStyle(fontSize: 16, color: customWhite),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: customBlue, width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${session.entryLimit}/15',
                                  style: GoogleFonts.barlow(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
