// // ignore_for_file: use_build_context_synchronously

// import 'package:bookmywod_admin/services/database/models/trainer_model.dart';
// import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
// import 'package:bookmywod_admin/shared/show_snackbar.dart';
// import 'package:flutter/material.dart';

// class AllUsersList extends StatefulWidget {
//   final List<TrainerModel> userModelList;
//   final SupabaseDb supabaseDb;
//   final String uid;

//   const AllUsersList({
//     super.key,
//     required this.userModelList,
//     required this.supabaseDb,
//     required this.uid,
//   });

//   @override
//   State<AllUsersList> createState() => _AllUsersListState();
// }

// class _AllUsersListState extends State<AllUsersList> {
//   Map<String, bool> userStatus = {};
//   Future<void> _handleActions(BuildContext context, String action, String uid,
//       String toBeModifiedUid) async {
//     switch (action) {
//       case 'Access':
//         final admin = await widget.supabaseDb.getAdminbyUid(uid);
//         if (admin == null) {
//           showSnackbar(
//             context,
//             'Could not find admin',
//             type: SnackbarType.error,
//           );
//           break;
//         }

//         await widget.supabaseDb.updateAdminStatus(toBeModifiedUid, uid, true);

//         var name = await widget.supabaseDb.getUser(toBeModifiedUid);
//         showSnackbar(context, '${name?.fullName}is removed from admin',
//             type: SnackbarType.success);

//         _fetchUserStatus();

//         break;
//       case 'Disable':
//         final admin = await widget.supabaseDb.getAdminbyUid(uid);
//         if (admin == null) {
//           showSnackbar(
//             context,
//             'Could not find admin',
//             type: SnackbarType.error,
//           );
//           break;
//         }

//         await widget.supabaseDb.updateAdminStatus(toBeModifiedUid, uid, false);

//         var name = await widget.supabaseDb.getUser(toBeModifiedUid);
//         showSnackbar(context, '${name?.fullName}is removed from admin',
//             type: SnackbarType.success);
//         _fetchUserStatus();

//         break;
//       case 'Remove':
//         final admin = await widget.supabaseDb.getAdminbyUid(uid);

//         if (admin == null) {
//           showSnackbar(
//             context,
//             'Could not find admin',
//             type: SnackbarType.error,
//           );
//           break;
//         }

//         await widget.supabaseDb.removeUserFromAdmin(uid, toBeModifiedUid);
//         var name = await widget.supabaseDb.getUser(toBeModifiedUid);
//         showSnackbar(context, '${name?.fullName}is removed from admin',
//             type: SnackbarType.success);
//         break;
//       default:
//         break;
//     }
//   }

//   // Future<void> _fetchUserStatus() async {
//   //   if (!mounted) return;

//   //   for (var user in widget.userModelList) {
//   //     final admin = await widget.supabaseDb.getAdminbyUid(widget.uid);
//   //     if (admin != null) {
//   //       final foundUser = admin.uidList.firstWhere(
//   //         (e) => e['uid'] == user.authId,
//   //         orElse: () => {},
//   //       );
//   //       if (foundUser.isNotEmpty) {
//   //         userStatus[user.authId] = foundUser['isEnabled'] ?? false;
//   //       }
//   //     }
//   //   }

//   //   if (mounted) {
//   //     setState(() {});
//   //   }
//   // }

//   // @override
//   // void initState() {
//   //   _fetchUserStatus();
//   //   super.initState();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       shrinkWrap: true,
//       // physics: NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.zero,
//       separatorBuilder: (context, index) => const Divider(
//         color: Colors.white10,
//         thickness: 1,
//       ),
//       itemCount: widget.userModelList.length,
//       itemBuilder: (context, index) {
//         final user = widget.userModelList[index];
//         final isEnabled = userStatus[user.authId] ?? false;
//         return ListTile(
//           contentPadding: EdgeInsets.zero,
//           leading: CircleAvatar(
//             backgroundImage: user.avatarUrl != null
//                 ? NetworkImage(user.avatarUrl!)
//                 : const AssetImage('assets/home/default_profile.png')
//                     as ImageProvider,
//           ),
//           title: Text(user.fullName),
//           subtitle: Text(user.username ?? ''),
//           trailing: SizedBox(
//             width: 110,
//             child: PopupMenuButton<String>(
//               onSelected: (value) =>
//                   _handleActions(context, value, widget.uid, user.authId),
//               child: OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: Colors.grey, width: 1),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 onPressed: null,
//                 child: Row(
//                   children: [
//                     Text(
//                       isEnabled ? 'Access' : 'Disable',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     Icon(
//                       Icons.arrow_drop_down,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//               itemBuilder: (context) => [
//                 PopupMenuItem(value: 'Access', child: Text('Access')),
//                 PopupMenuItem(value: 'Disable', child: Text('Disable')),
//                 PopupMenuItem(value: 'Remove', child: Text('Remove')),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
