import 'package:flutter/material.dart';
import 'package:bookmywod_admin/screens/admin/components/owner_tile.dart';
import 'package:bookmywod_admin/shared/show_snackbar.dart';
import 'package:bookmywod_admin/services/auth/auth_user.dart';
import 'package:bookmywod_admin/services/database/models/trainer_model.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import '../../services/database/models/admin_model.dart';

class AddAdminView extends StatefulWidget {
  final AuthUser authUser;
  final SupabaseDb supabaseDb;
  final TrainerModel userModel;

  const AddAdminView({
    super.key,
    required this.authUser,
    required this.supabaseDb,
    required this.userModel,
  });

  @override
  State<AddAdminView> createState() => _AddAdminViewState();
}

class _AddAdminViewState extends State<AddAdminView> {
  late final TextEditingController _searchController;
  List<TrainerModel> _searchResults = [];
  List<AdminModel> _adminList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fetchAdmins();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  Future<void> _addAdmin(TrainerModel user) async {
    try {
      String uid = widget.userModel.authId;

      // Fetch admin by UID
      var admin = await widget.supabaseDb.getAdminByUid(uid);

      // Generate UUID for new admin
      String uuid = user.authId; // Use the existing auth ID

      // Ensure the user exists before inserting
      bool userExists = await widget.supabaseDb.doesUserExist(uuid);
      if (!userExists) {
        print("Error: The user with ID $uuid does not exist in the 'users' table.");
        showSnackbar(context, 'Error: User does not exist.', type: SnackbarType.error);
        return;
      }

      var adminData = await widget.supabaseDb.createAdmin(
        adminId: uuid,
        uid: uid,
        fullName: user.fullName,
        email: user.fullName ?? '',
        uidList: [{'uid': user.authId, 'isEnabled': true}],
      );

      if (adminData == null || adminData['id'] == null || adminData['id'].isEmpty) {
        print("Error: Failed to create admin. Received null or empty admin_id!");
        return;
      }

      admin = AdminModel.fromMap(adminData);

      // Ensure adminId is valid
      if (admin.adminId.isEmpty) {
        print("Error: Generated adminId is empty or invalid!");
        return;
      }

      // Update UID list if the user is not already present
      if (!admin.uidList.any((e) => e['uid'] == user.authId)) {
        List<Map<String, dynamic>> updatedUidList = [
          ...admin.uidList,
          {'uid': user.authId, 'isEnabled': true}
        ];

        print("Updating Admin with ID: ${admin.adminId}, New UID List: $updatedUidList");

        await widget.supabaseDb.updateAdmin(admin.adminId, updatedUidList);
      }

      // Fetch the latest admin list
      await _fetchAdmins();

      showSnackbar(context, '${user.fullName} added as admin', type: SnackbarType.success);
    } catch (e) {
      print("Error in _addAdmin: $e");
      showSnackbar(context, 'Error: ${e.toString()}', type: SnackbarType.error);
    }
  }

  Future<void> _fetchAdmins() async {
    try {
      final response = await widget.supabaseDb.getAdmins();
      setState(() {
        _adminList = response;
      });
    } catch (e) {
      showSnackbar(context, 'Failed to fetch admins', type: SnackbarType.error);
    }
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final results = await widget.supabaseDb.searchTrainersByName(query);
      setState(() => _searchResults = results);
    } catch (e) {
      setState(() => _searchResults = []);
    } finally {
      setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Add Admin', style: TextStyle(fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Member', style: TextStyle(fontSize: 20, color: Colors.white)),
                    const SizedBox(height: 10),
                    OwnerTile(
                        widget: widget,
                        userModel: widget.userModel,
                        authUser: widget.authUser),
                    const Divider(color: Colors.white24),
                    const Text('Admin', style: TextStyle(fontSize: 18, color: Colors.white)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 300,
                      child: _adminList.isEmpty
                          ? const Center(
                          child: Text('No admins added yet',
                              style: TextStyle(color: Colors.white70)))
                          : ListView.builder(
                        itemCount: _adminList.length,
                        itemBuilder: (context, index) {
                          final admin = _adminList[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: (admin.avatarUrl != null && admin.avatarUrl!.isNotEmpty)
                                  ? NetworkImage(admin.avatarUrl!)
                                  : const AssetImage('assets/home/default_profile.png') as ImageProvider,
                            ),
                            title: Text(admin.fullName ?? 'No Name',
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(admin.fullName ?? '',
                                style: TextStyle(color: Colors.white54)),
                            trailing:    DropdownButton(
                              value: 'Access',
                              dropdownColor: Colors.blueGrey.shade900,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                              items: [
                                DropdownMenuItem(
                                    value: 'Access', child: Text('Access', style: TextStyle(color: Colors.white))),
                                DropdownMenuItem(value: 'Disable', child: Text('Disable', style: TextStyle(color: Colors.white))),
                              ],
                              onChanged: (value) {  },

                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Add Admin', style: TextStyle(color: Colors.white, fontSize: 16)),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _searchController,
                            onChanged: _searchUsers,
                            decoration: InputDecoration(
                              hintText: 'Enter admin name',
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search, color: Colors.white),
                                onPressed: () => _searchUsers(_searchController.text),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: customDarkBlue,
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: _searchResults.isNotEmpty ? 200 : 0,
                            child: _isSearching
                                ? const Center(child: CircularProgressIndicator())
                                :
                            ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final user = _searchResults[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: user.avatarUrl != null
                                        ? NetworkImage(user.avatarUrl!)
                                        : const AssetImage('assets/home/default_profile.png')
                                    as ImageProvider,
                                  ),
                                  title: Text(user.fullName, style: TextStyle(color: Colors.white)),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.person_add, color: Colors.green),
                                    onPressed: () => {
                                      _addAdmin(user)
                                    }, // Implement add admin logic
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
