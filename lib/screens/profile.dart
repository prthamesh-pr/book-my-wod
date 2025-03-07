import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final supabase = Supabase.instance.client;
  Map<String, dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        setState(() => isLoading = false);
        return;
      }

      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      setState(() {
        profileData = response;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching profile: $error');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customDarkBlue,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: customBlue))
          : profileData == null
              ? const Center(child: Text("No profile data found", style: TextStyle(color: Colors.white)))
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // App Bar with Avatar
                    SliverAppBar(
                      expandedHeight: 280.0,
                      floating: false,
                      pinned: true,
                      backgroundColor: customDarkBlue,
                      flexibleSpace: FlexibleSpaceBar(
                        background: _buildProfileHeader(),
                      ),
                      title: const Text(
                        "Profile",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: customBlue),
                          onPressed: () {
                            // Handle edit profile action
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: customBlue),
                          onPressed: () {
                            // Handle settings action
                          },
                        ),
                      ],
                    ),
                    // Profile Content
                    SliverToBoxAdapter(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: customGrey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Personal Info Section
                              _buildSectionHeader("Personal Information", CupertinoIcons.person_fill),
                              const SizedBox(height: 16),
                              _buildInfoCard([
                                _profileDetailItem(CupertinoIcons.mail_solid, "Email", profileData!['email'] ?? "example@gmail.com"),
                                _profileDetailItem(CupertinoIcons.phone_fill, "Phone", "+91 98765 43210"),
                                _profileDetailItem(CupertinoIcons.location_solid, "City", "Mumbai, India"),
                              ]),
                              
                              const SizedBox(height: 24),
                              
                              // Work Info Section
                              _buildSectionHeader("Work Information", CupertinoIcons.briefcase_fill),
                              const SizedBox(height: 16),
                              _buildInfoCard([
                                _profileDetailItem(CupertinoIcons.building_2_fill, "Occupation", "Flutter Developer"),
                                _profileDetailItem(CupertinoIcons.calendar_badge_plus, "Joined", "March 2023"),
                                _profileDetailItem(CupertinoIcons.link, "Website", profileData!['website'] ?? "No website"),
                              ]),
                              
                              const SizedBox(height: 24),
                              
                              // Stats Section
                              _buildSectionHeader("Stats", CupertinoIcons.chart_bar_fill),
                              const SizedBox(height: 16),
                              _buildStatsRow(),
                              
                              const SizedBox(height: 24),
                              
                              // Logout Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await supabase.auth.signOut();
                                    // Navigate to login page
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: customBlue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    "LOGOUT",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30), // Added extra space at bottom
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildProfileHeader() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                customDarkBlue,
                customBlue.withOpacity(0.7),
              ],
            ),
          ),
        ),
        // Pattern overlay
        Opacity(
          opacity: 0.1,
          child: Image.network(
            'https://www.transparenttextures.com/patterns/cubes.png',
            repeat: ImageRepeat.repeat,
          ),
        ),
        // Profile info
        Padding(
          padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar with decorative border
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: customBlue, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: customBlue.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white24,
                  backgroundImage: profileData!['avatar_url'] != null
                      ? NetworkImage(profileData!['avatar_url'])
                      : null,
                  child: profileData!['avatar_url'] == null
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              // Username with visual emphasis
              Text(
                profileData!['username'] ?? 'Guest User',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black26,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Fullname
              Text(
                profileData!['full_name'] ?? 'Full Name Unavailable',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: customBlue, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: customDarkBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _profileDetailItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: customBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: customBlue, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildStatItem("Sessions", "24"),
          const SizedBox(width: 12),
          _buildStatItem("Completed", "18"),
          const SizedBox(width: 12),
          _buildStatItem("Reviews", "4.8"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: customDarkBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: customBlue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: customBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}