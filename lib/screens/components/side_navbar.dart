import 'package:bookmywod_admin/bloc/auth_bloc.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_logout.dart';
import 'package:bookmywod_admin/screens/membership.dart';
import 'package:bookmywod_admin/screens/reportscreen/report.dart';
import 'package:bookmywod_admin/services/auth/auth_user.dart';
import 'package:bookmywod_admin/services/database/models/trainer_model.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SideNavbar extends StatelessWidget {
  final TrainerModel userModel;
  final AuthUser authUser;
  final SupabaseDb supabaseDb;

  const SideNavbar({
    super.key,
    required this.userModel,
    required this.authUser,
    required this.supabaseDb,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Container(
        color: customBlue, // Change drawer background color here
        child: Column(
          children: [
            SizedBox(height: 40),
            Container(
              color: customBlue,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: Column(
                children: [
                  // Profile Header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          userModel.avatarUrl ?? "https://img.freepik.com/premium-photo/memoji-happy-man-white-background-emoji_826801-6839.jpg",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userModel.fullName,
                              style: GoogleFonts.barlow(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              authUser.email,
                              style: GoogleFonts.barlow(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Add Admin Button
                  Align(
                    alignment: Alignment.centerLeft, // Aligns the button to the left
                    child: SizedBox(
                      width: 200,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          GoRouter.of(context).push('/add-admin', extra: {
                            'authUser': authUser,
                            'userModel': userModel,
                            'supabaseDb': supabaseDb,
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.add,
                              size: 23,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Add Admin',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  color: customGrey, // Set the rest of the drawer white
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: SvgPicture.asset('assets/icons/run.svg'),
                      title: const Text('Activity'),
                    ),
                    ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MembershipPlanScreen()));
                      },
                      leading: SvgPicture.asset('assets/icons/membership.svg'),
                      title: const Text('Membership'),
                    ),
                    ListTile(
                      onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportScreen()));
                    },
                      leading: SvgPicture.asset('assets/icons/report.svg'),
                      title: const Text('Report'),
                    ),
                    ListTile(
                      leading: SvgPicture.asset('assets/icons/contact.svg'),
                      title: const Text('Contact Book My WOD Team'),
                    ),
                    ListTile(
                      leading: SvgPicture.asset('assets/icons/logout.svg'),
                      title: const Text('Logout'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Confirm Logout"),
                            content: const Text("Are you sure you want to logout?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                  context.read<AuthBloc>().add(AuthEventLogout()); // Trigger logout
                                },
                                child: const Text("Logout"),
                              ),
                            ],
                          ),
                        );
                      },
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
