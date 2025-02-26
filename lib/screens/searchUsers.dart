import 'package:bookmywod_admin/services/auth/auth_user.dart' as CustomAuth;
import 'package:bookmywod_admin/services/database/models/trainer_model.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchUserScreen extends StatefulWidget {
  final SupabaseDb supabaseDb;
  final CustomAuth.AuthUser authUser;

  const SearchUserScreen({super.key, required this.supabaseDb, required this.authUser});

  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  final SupabaseClient supabase = Supabase.instance.client;
  List<TrainerModel> allUsers = [];
  List<TrainerModel> filteredUsers = [];
  bool isLoading = true;
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
    _searchController.addListener(() {
      filterUsers(_searchController.text);
    });
  }
  Future<void> fetchUsers() async {
    try {
      final response = await supabase.from('profiles').select();

      if (response == null || response.isEmpty) {
        setState(() => isLoading = false);
        return;
      }

      setState(() {
        users = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching users: $error');
      setState(() {
        isLoading = false;
      });
    }
  }
  void filterUsers(String query) {
    setState(() {
      searchQuery = query.trim();
      if (searchQuery.isEmpty) {
        filteredUsers = allUsers;
      } else {
        filteredUsers = allUsers
            .where((user) => user.fullName.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Users")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for a user...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    filterUsers("");
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredUsers.isEmpty
                ? const Center(child: Text("No user found"))
                : ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        user.fullName[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      user.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("ID: ${user.authId}"),
                    onTap: () {
                      GoRouter.of(context).push('/chat/${widget.authUser.id}/${user.authId}');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
