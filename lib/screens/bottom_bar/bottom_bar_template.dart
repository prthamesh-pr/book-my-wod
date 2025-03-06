import 'package:bookmywod_admin/screens/membership.dart';
import 'package:bookmywod_admin/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bottom_bloc.dart';
import '../../services/auth/auth_user.dart';
import '../../services/database/supabase_storage/supabase_db.dart';
import '../home_screen.dart';

class BottomBarTemplate extends StatefulWidget {
  final AuthUser? authUser;
  final SupabaseDb? supabaseDb;
  const BottomBarTemplate({
    super.key,
     this.authUser,
    this.supabaseDb
  });

  @override
  State<BottomBarTemplate> createState() => _BottomBarTemplateState();
}

class _BottomBarTemplateState extends State<BottomBarTemplate> {
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(
        authUser: widget.authUser ?? AuthUser(email: '',
            isEmailVerified: true,
            id: '',
            fullName: ''),
        supabaseDb: widget.supabaseDb??SupabaseDb(),
      ),
      Center(child: CircularProgressIndicator()), // Replace with Membership Screen
      MembershipPlanScreen(),
      Profile()

    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBloc(),
      child: Scaffold(
        body: BlocBuilder<BottomNavBloc, BottomNavState>(
          builder: (context, state) {
            int index = _getCurrentIndex(state);
            return _pages[index];
          },
        ),
        bottomNavigationBar: BlocBuilder<BottomNavBloc, BottomNavState>(
          builder: (context, state) {
            int currentIndex = _getCurrentIndex(state);
            return Container(
              margin: EdgeInsets.all(12), // Avoid screen edges
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Color(0xFF0F1E2E), // Dark background color
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomNavItem(Icons.home, "Home", 0, currentIndex, context),
                  _buildBottomNavItem(Icons.calendar_month, "Schedule", 1, currentIndex, context),
                  _buildBottomNavItem(Icons.workspace_premium, "Membership", 2, currentIndex, context),
                  _buildBottomNavItem(Icons.account_circle_sharp, "Profile", 3, currentIndex, context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Maps [BottomNavState] to corresponding index
  int _getCurrentIndex(BottomNavState state) {
    switch (state) {
      case BottomNavState.home:
        return 0;
      case BottomNavState.schedule:
        return 1;
      case BottomNavState.membership:
        return 2;
      case BottomNavState.profile:
        return 3;
      default:
        return 0;
    }
  }

  /// Custom method to create a bottom navigation bar item with an animated selection effect
  Widget _buildBottomNavItem(IconData icon, String label, int index, int currentIndex, BuildContext context) {
    bool isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () {
        context.read<BottomNavBloc>().updateTab(index);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 20 : 0, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.white, size: 24),
            if (isSelected) // Show text only for selected item
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  label,
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
