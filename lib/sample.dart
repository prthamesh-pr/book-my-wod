import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserListScreen extends StatefulWidget {
  final String currentUserId;

  const UserListScreen({super.key, required this.currentUserId});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .neq('id', widget.currentUserId);

      if (response == null || response.isEmpty) {
        setState(() => isLoading = false);
        return;
      }

      setState(() {
        users = List<Map<String, dynamic>>.from(response).map((user) {
          List messages = user['messages'] ?? [];
          final lastMessage = messages.isNotEmpty ? messages.first : null;

          return {
            "id": user["id"],
            "full_name": user["full_name"],
            "last_message": lastMessage?["content"] ?? "No messages yet",
            "timestamp": lastMessage?["created_at"] ?? "",
            "unread_count":
            messages.where((msg) => msg["read_status"] == false).length,
          };
        }).toList();
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching users: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1621), // Dark background
      appBar: AppBar(
        title: const Text(
          'Message',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: customWhite),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SvgPicture.asset(
              'assets/icons/contact.svg',
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(customWhite, BlendMode.srcIn),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildChatHeader(),
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            )
                : users.isEmpty
                ? const Center(
              child: Text(
                'No users found',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            )
                : _buildChatList(),
          ),
        ],
      ),
    );
  }

  /// **Search Bar**
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF1E2A38), // Dark search bar
          hintText: 'Search',
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: customWhite),
      ),
    );
  }

  /// **Chat Header**
  Widget _buildChatHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Chat',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: customWhite),
          ),
          const Icon(Icons.more_horiz, color: Colors.white70),
        ],
      ),
    );
  }

  /// **Chat List**
  Widget _buildChatList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: users.length,
      separatorBuilder: (context, index) => const Divider(color: Colors.white10),
      itemBuilder: (context, index) {
        final user = users[index];
        final String name = user['full_name'] ?? 'Unknown';
        final String userId = user['id'] ?? '';
        final String avatarText = name.isNotEmpty ? name[0].toUpperCase() : "?";
        final String lastMessage = user['last_message'] ?? 'No messages yet';
        final String timestamp = _formatTimestamp(user['timestamp']);
        final int unreadCount = user['unread_count'] ?? 0;
        final bool hasUnreadMessages = unreadCount > 0;

        return ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: hasUnreadMessages ? Colors.redAccent : Colors.blueAccent,
            child: Text(
              avatarText,
              style: const TextStyle(color: customWhite, fontSize: 18),
            ),
          ),
          title: Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: customWhite),
          ),
          subtitle: Text(
            lastMessage,
            style: TextStyle(
              color: hasUnreadMessages ? Colors.white : Colors.white70,
              fontSize: 14,
              fontWeight: hasUnreadMessages ? FontWeight.bold : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                timestamp,
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
              const SizedBox(height: 4),
              if (hasUnreadMessages)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "$unreadCount",
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          onTap: () {
            GoRouter.of(context).push('/chat/${widget.currentUserId}/$userId');
          },
        );
      },
    );
  }
}

/// **Timestamp Formatter**
String _formatTimestamp(String timestamp) {
  if (timestamp.isEmpty) return '';

  DateTime dateTime = DateTime.parse(timestamp).toLocal();
  DateTime now = DateTime.now();

  if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}"; // Show time if today
  } else {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}"; // Show date if older
  }
}
