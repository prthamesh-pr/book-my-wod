// ignore_for_file: deprecated_member_use
import 'package:bookmywod_admin/sample.dart';
import 'package:bookmywod_admin/screens/components/create_catagory_component.dart';
import 'package:bookmywod_admin/screens/components/date_tile.dart';
import 'package:bookmywod_admin/screens/components/fitness_catagories_container.dart';
import 'package:bookmywod_admin/screens/components/side_navbar.dart';
import 'package:bookmywod_admin/screens/schedule/all_session_view.dart';
import 'package:bookmywod_admin/services/auth/auth_user.dart';
import 'package:bookmywod_admin/services/database/models/catagory_model.dart';
import 'package:bookmywod_admin/services/database/models/gym_model.dart';
import 'package:bookmywod_admin/services/database/models/trainer_model.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:bookmywod_admin/shared/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final AuthUser authUser;
  final SupabaseDb supabaseDb;

  const HomeScreen({
    super.key,
    required this.authUser,
    required this.supabaseDb
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  CatagoryModel? catagory;
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
    return FutureBuilder<TrainerModel?>(
        future: widget.supabaseDb.getTrainerByAuthId(widget.authUser.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: customWhite,
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }

          final trainerModel = snapshot.data;
          if (trainerModel == null) {
            return const Scaffold(
              body: Center(
                child: Text('User not found'),
              ),
            );
          }
          return Scaffold(
            drawer: SideNavbar(
              userModel: trainerModel,
              authUser: widget.authUser,
              supabaseDb: widget.supabaseDb,
            ),
            appBar: AppBar(
              backgroundColor: customDarkBlue,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder<GymModel?>(
                    future: widget.supabaseDb.getGym(trainerModel.gymId),
                    builder: (context, gymSnapshot) {
                      if (gymSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Text('Loading...');
                      }

                      if (gymSnapshot.hasError) {
                        return const Text('Error loading gym details');
                      }

                      final gym = gymSnapshot.data;
                      return Text(
                        gym?.name ?? '',
                        style: TextStyle(
                          color: customBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  Text(
                    '${trainerModel.fullName} ✨',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserListScreen(
                                  currentUserId: widget.authUser.id,
                                )));
                    // GoRouter.of(context).push('/search');
                  },
                  icon: Icon(
                    Icons.mail_outline,
                    color: customWhite,
                    size: 25,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    GoRouter.of(context).push('/notifications');
                  },
                  icon: Icon(
                    size: 25,
                    Icons.notifications_outlined,
                    color: customWhite,
                  ),
                )
              ],
            ),
            body: StreamBuilder(
                stream: widget.supabaseDb
                    .getAllCatagoriesByCreator(trainerModel.trainerId!),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Column(
                      children: [
                        Text('No Catagory yet created'),
                        const SizedBox(height: 16),
                        CreateCatagoryComponent(
                          widget: widget,
                          trainerModel: trainerModel,
                          gymId: catagory?.gymId ?? '',
                          creatorId: catagory?.createdAt ?? '',
                          catId: catagory?.catagoryId ?? '',
                        ),

                      ],
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return LoadingScreen();
                  } else if (snapshot.data == null) {
                    return const Text('No Catagory yet created');
                  } else {
                    final data = snapshot.data ?? [];
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: customDarkBlue,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 7,
                                        itemBuilder: (context, index) {
                                          DateTime date = weekDates[index];
                                          return DateTile(
                                            day: DateFormat('d').format(date),
                                            weekday:
                                                DateFormat('EEE').format(date),
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
                                    DateFormat('EEEE, d MMMM yyyy')
                                        .format(weekDates[selectedIndex]),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Todays Session',
                                  style: TextStyle(
                                    color: customWhite,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => AllSessionView(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'See All',
                                    style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                 catagory = data[index];
                                return FitnessCategoriesContainer(
                                  name: catagory!.name,
                                  categories:
                                      catagory!.features?.join(', ') ?? '',
                                  onTap: () {
                                    GoRouter.of(context).push(
                                      '/session-view',
                                      extra: {
                                        'supabaseDb': widget.supabaseDb,
                                        'catagoryName': catagory!.name,
                                        'catagoryId': catagory!.catagoryId,
                                        'creatorId': catagory!.uuidOfCreator,
                                        'gymId': trainerModel.gymId,
                                      },
                                    );
                                  },
                                  image: catagory!.image ??
                                      'assets/events/heavylifting.png',
                                  sessionCount: 5,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 16,
                              ),
                              itemCount: data.length,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 16,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 140,
                              decoration: BoxDecoration(
                                color: customDarkBlue,
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Add New Categories',
                                      style: TextStyle(
                                        color: customWhite,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    OutlinedButton(
                                        style: ButtonStyle(
                                          side: WidgetStatePropertyAll(
                                            BorderSide(
                                              color: customBlue,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          GoRouter.of(context).push('/create-catagory', extra: {
                                            'supabaseDb': widget.supabaseDb,
                                            'trainerModel': trainerModel,
                                            'catagoryId': catagory!.catagoryId,
                                            'creatorId': catagory!.uuidOfCreator,
                                            'gymId': catagory!.gymId,

                                          });
                                        },

                                        child: Text(
                                          'Add New Categories',
                                          style: TextStyle(
                                            color: customWhite,
                                            fontSize: 16,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            )

                          )
                        ],
                      ),
                    );
                  }
                }),
          );
        });
  }
}
