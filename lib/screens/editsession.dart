// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// import '../services/database/models/session_model.dart';
//
// class EditSessionScreen extends StatefulWidget {
//   final dynamic supabaseDb;
//   final String catagoryId;
//   final String creatorId;
//   final dynamic sessionModel;
//   final String gymId;
//
//   const EditSessionScreen({
//     Key? key,
//     required this.supabaseDb,
//     required this.catagoryId,
//     required this.creatorId,
//     required this.sessionModel,
//     required this.gymId,
//   }) : super(key: key);
//
//   @override
//   _EditSessionScreenState createState() => _EditSessionScreenState();
// }
//
// class _EditSessionScreenState extends State<EditSessionScreen> {
//   late TextEditingController _sessionNameController;
//   TimeOfDay? startTime;
//   TimeOfDay? endTime;
//   int seatLimit = 0;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize session details
//     _sessionNameController = TextEditingController(text: widget.sessionModel[0]['fullName']);
//     startTime = _parseTime(widget.sessionModel['startTime']);
//     endTime = _parseTime(widget.sessionModel['endTime']);
//     seatLimit = widget.sessionModel['seatLimit'] ?? 10; // Default to 10 if null
//   }
//
//   // Convert String "HH:mm" to TimeOfDay
//   TimeOfDay _parseTime(String timeString) {
//     final parts = timeString.split(':');
//     return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
//   }
//
//   // Pick Time Function
//   Future<void> _pickTime(BuildContext context, bool isStart) async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: isStart ? startTime! : endTime!,
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           startTime = picked;
//         } else {
//           endTime = picked;
//         }
//       });
//     }
//   }
//
//   // Save Changes & Update Supabase
//   Future<void> _saveChanges() async {
//     // final updatedSession = {
//     //   'name': _sessionNameController.text,
//     //   'startTime': "${startTime!.hour}:${startTime!.minute}",
//     //   'endTime': "${endTime!.hour}:${endTime!.minute}",
//     //   'seatLimit': seatLimit,
//     //   'gymId': widget.gymId,
//     // };
//     //
//     // // Call Supabase API or Update Local State
//     // await widget.supabaseDb
//     //     .from('sessions')
//     //     .update(updatedSession)
//     //     .eq('id', widget.sessionModel['id']);
//     if (widget.sessionModel == null) {
//       final session = SessionModel(
//         gymId: widget.gymId,
//         name: _c.text,
//         categoryId: widget.catagoryId,
//         timeSlots: timeSlots.map((e) => e.toJson()).toList(),
//         days: _selectedDates
//             .map((d) => DateFormat('EEEE, M/d/y').format(d))
//             // .toList(),
//         sessionRepeat: _sessionRepeat,
//         entryLimit: _entryLimitController.text,
//         sessionCreatedBy: widget.creatorId,
//         coverImage: _imageUrl,
//         description: _catagoryDescriptionController.text,
//       );
//       await widget.supabaseDb.createSession(session);
//     }
//     else {
//       final session = widget.sessionModel!.copyWith(
//         name: _catagoryNameController.text,
//         categoryId: widget.catagoryId,
//         timeSlots: timeSlots.map((e) => e.toJson()).toList(),
//         days: _selectedDates
//             .map((d) => DateFormat('EEEE, M/d/y').format(d))
//             .toList(),
//         sessionRepeat: _sessionRepeat,
//         entryLimit: _entryLimitController.text,
//         sessionCreatedBy: widget.creatorId,
//         coverImage: _imageUrl,
//         description: _catagoryDescriptionController.text,
//       );
//       await widget.supabaseDb.updateSession(session);
//     }
//     // Navigate back
//     context.pop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black87,
//       appBar: AppBar(
//         title: const Text("Edit Session"),
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => context.pop(), // GoRouter Back Navigation
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Gym Image
//             Center(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   "https://source.unsplash.com/600x300/?gym,fitness",
//                   height: 180,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Session Name
//             TextField(
//               controller: _sessionNameController,
//               style: const TextStyle(color: Colors.white, fontSize: 18),
//               decoration: const InputDecoration(
//                 labelText: "Session Name",
//                 labelStyle: TextStyle(color: Colors.white70),
//                 enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white54),
//                 ),
//                 focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//
//             // Time Pickers Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () => _pickTime(context, true),
//                   child: _timeCard("Start Time", startTime),
//                 ),
//                 GestureDetector(
//                   onTap: () => _pickTime(context, false),
//                   child: _timeCard("End Time", endTime),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//
//             // Seat Limit Section
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.blueGrey.shade900,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(Icons.groups, color: Colors.white70),
//                       const SizedBox(width: 5),
//                       IconButton(
//                         icon: const Icon(Icons.remove, color: Colors.white),
//                         onPressed: () {
//                           setState(() {
//                             if (seatLimit > 1) seatLimit--;
//                           });
//                         },
//                       ),
//                       Text(
//                         "$seatLimit",
//                         style: const TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.add, color: Colors.white),
//                         onPressed: () {
//                           setState(() {
//                             seatLimit++;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // Save Changes Button
//             Center(
//               child: Container(
//                 width: 200,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: TextButton(
//                   onPressed: _saveChanges,
//                   child: const Text(
//                     'Save Changes',
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Time Card Widget
//   Widget _timeCard(String title, TimeOfDay? time) {
//     return Container(
//       width: 150,
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.blueGrey.shade900,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 14, color: Colors.white70),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             time!.format(context),
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
// }
