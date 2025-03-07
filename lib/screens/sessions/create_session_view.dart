// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:bookmywod_admin/screens/sessions/session_sucess.dart' show SuccessScreen;
import 'package:bookmywod_admin/services/database/models/session_model.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:bookmywod_admin/shared/custom_text_field.dart';
import 'package:bookmywod_admin/shared/show_snackbar.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class CreateSessionView extends StatefulWidget {
  final SupabaseDb supabaseDb;
  final String gymId;
  final String catagoryId;
  final String creatorId;
  final SessionModel? sessionModel;
  const CreateSessionView({
    super.key,
    required this.supabaseDb,
    required this.catagoryId,
    required this.creatorId,
    required this.sessionModel,
    required this.gymId,
  });

  @override
  State<CreateSessionView> createState() => _CreateSessionViewState();
}

class _CreateSessionViewState extends State<CreateSessionView> {
  final List<String> _daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  List<String> _selectedDays = [];
  late final TextEditingController _catagoryNameController;
  late final TextEditingController _entryLimitController;
  late final TextEditingController _dateController;
  late final TextEditingController _catagoryDescriptionController;
  final List<DateTime> _selectedDates = [];
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  String? _imageUrl;
  bool _sessionRepeat = false;

  List<TimeSlot> timeSlots = [TimeSlot()];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      if (mounted) {
        showSnackbar(context, 'No image selected', type: SnackbarType.error);
      }
      return;
    }

    try {
      final imageBytes = await pickedFile.readAsBytes();
      final fileExt = pickedFile.path.split('.').last;
      final fileName =
          'category/${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      // Check file size
      final fileSize = imageBytes.length / (1024 * 1024);
      if (fileSize > 20) {
        if (mounted) {
          showSnackbar(context, 'Image size should be less than 20MB',
              type: SnackbarType.error);
        }
        return;
      }

      await Supabase.instance.client.storage.from('category').uploadBinary(
            fileName,
            imageBytes,
            fileOptions: FileOptions(
              contentType: 'image/$fileExt',
              upsert: true,
            ),
          );

      final imageUrl = Supabase.instance.client.storage
          .from('category')
          .getPublicUrl(fileName);

      setState(() {
        _pickedImage = File(pickedFile.path);
        _imageUrl = imageUrl;
      });

      if (mounted) {
        showSnackbar(
          context,
          'Image uploaded successfully!',
          type: SnackbarType.success,
        );
      }
    } on StorageException catch (e) {
      if (mounted) {
        showSnackbar(context, 'Failed to upload image: ${e.message}',
            type: SnackbarType.error);
      }
    } catch (e) {
      if (mounted) {
        showSnackbar(context, 'Unexpected error occurred: $e',
            type: SnackbarType.error);
      }
    }
  }

  Future<void> _selectDate() async {
    BottomPicker.date(
      height: 400,
      backgroundColor: customDarkBlue,
      pickerTitle: Text(
        'Select Session Date',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 26,
          color: Colors.blue,
        ),
      ),
      dateOrder: DatePickerDateOrder.dmy,
      initialDateTime: DateTime.now(),
      pickerTextStyle: GoogleFonts.barlow(
        textStyle: const TextStyle(
          color: Colors.blue,
          fontSize: 18,
        ),
      ),
      onSubmit: (value) {
        if (value is DateTime && !_selectedDates.contains(value)) {
          setState(() {
            _selectedDates.add(value);
            _dateController.text = _selectedDates
                .map((date) => DateFormat('yyyy-MM-dd').format(date))
                .join(', ');
          });
        }
      },
      // bottomPickerTheme: BottomPickerTheme.heavyRain,
    ).show(context);
  }
  Future<void> _selectTime(BuildContext context, int index) async {
  // Current values or defaults
  final timeSlot = timeSlots[index];
  int startHour = timeSlot.startHour ?? 8;
  int startMinute = timeSlot.startMinute ?? 0;
  int endHour = timeSlot.endHour ?? 9;
  int endMinute = timeSlot.endMinute ?? 0;
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: customDarkBlue,
            title: const Text(
              'Select Time Slot',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Start Time Section
                const Text(
                  'Start Time',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Hour selector
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Hour', style: TextStyle(color: customBlue)),
                        Container(
                          width: 70,
                          decoration: BoxDecoration(
                            color: customGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<int>(
                            value: startHour,
                            dropdownColor: customGrey,
                            underline: Container(),
                            items: List.generate(24, (i) => i).map((hour) {
                              return DropdownMenuItem<int>(
                                value: hour,
                                child: Text(
                                  hour.toString().padLeft(2, '0'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setStateDialog(() {
                                  startHour = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    // Minute selector
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Minute', style: TextStyle(color: customBlue)),
                        Container(
                          width: 70,
                          decoration: BoxDecoration(
                            color: customGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<int>(
                            value: startMinute,
                            dropdownColor: customGrey,
                            underline: Container(),
                            items: List.generate(12, (i) => i*5).map((minute) {
                              return DropdownMenuItem<int>(
                                value: minute,
                                child: Text(
                                  minute.toString().padLeft(2, '0'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setStateDialog(() {
                                  startMinute = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // End Time Section
                const Text(
                  'End Time',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Hour selector
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Hour', style: TextStyle(color: customBlue)),
                        Container(
                          width: 70,
                          decoration: BoxDecoration(
                            color: customGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<int>(
                            value: endHour,
                            dropdownColor: customGrey,
                            underline: Container(),
                            items: List.generate(24, (i) => i).map((hour) {
                              return DropdownMenuItem<int>(
                                value: hour,
                                child: Text(
                                  hour.toString().padLeft(2, '0'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setStateDialog(() {
                                  endHour = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    // Minute selector
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Minute', style: TextStyle(color: customBlue)),
                        Container(
                          width: 70,
                          decoration: BoxDecoration(
                            color: customGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<int>(
                            value: endMinute,
                            dropdownColor: customGrey,
                            underline: Container(),
                            items: List.generate(12, (i) => i*5).map((minute) {
                              return DropdownMenuItem<int>(
                                value: minute,
                                child: Text(
                                  minute.toString().padLeft(2, '0'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setStateDialog(() {
                                  endMinute = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('Save', style: TextStyle(color: customBlue)),
                onPressed: () {
                  setState(() {
                    timeSlots[index] = TimeSlot(
                      startHour: startHour, 
                      startMinute: startMinute,
                      endHour: endHour,
                      endMinute: endMinute,
                    );
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      );
    },
  );
}
  @override
  void initState() {
    super.initState();
    print("bull shit check ${widget.catagoryId}");
    print("bull shit check ${widget.gymId}");
    print("bull shit check creator ${widget.creatorId}");

    _catagoryNameController = TextEditingController(
      text: widget.sessionModel?.name ?? '',
    );
    _entryLimitController = TextEditingController(
      text: widget.sessionModel?.entryLimit.toString() ?? '',
    );
    _catagoryDescriptionController = TextEditingController(
      text: widget.sessionModel?.description ?? '',
    );

    _imageUrl = widget.sessionModel?.coverImage;
    _sessionRepeat = widget.sessionModel?.sessionRepeat ?? false;

    // Convert string dates back to DateTime and update _selectedDates
    if (widget.sessionModel?.days != null) {
      _selectedDates.clear();
      for (String day in widget.sessionModel!.days) {
        try {
          DateTime parsedDate = DateFormat('EEEE, M/d/y').parse(day);
          _selectedDates.add(parsedDate);
        } catch (e) {
          debugPrint('Error parsing date: $day');
        }
      }
      _dateController = TextEditingController(
        text: _selectedDates
            .map((d) => DateFormat('yyyy-MM-dd').format(d))
            .join(', '),
      );
    } else {
      _dateController = TextEditingController();
    }

    if (widget.sessionModel?.timeSlots != null) {
      timeSlots = widget.sessionModel!.timeSlots.map((slot) {
        return TimeSlot.fromTimeOfDay(
          startTime: _parseTime(slot['start_time']),
          endTime: _parseTime(slot['end_time']),
        );
      }).toList();
    }
  }
  
  TimeOfDay? _parseTime(String? time) {
    if (time == null || !time.contains(':')) return null;
    try {
      final parts = time.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      debugPrint('Invalid time format: $time');
      return null;
    }
  }

  @override
  void dispose() {
    _catagoryNameController.dispose();
    _entryLimitController.dispose();
    _dateController.dispose();
    _catagoryDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff05121E),
      appBar: AppBar(
        title: const Text('Create Session'),
        backgroundColor: Color(0xff05121E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Center(
          child: Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            color: customGrey,

            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Ensures all content aligns to the left
                  children: [
                    const Text(
                      "Session Name",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: 'Enter Session Name',
                      controller: _catagoryNameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter category name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Description",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _catagoryDescriptionController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter category name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Select Dates",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: _dateController,
                                readOnly: true,
                                onTap: _selectDate,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (_selectedDates.isEmpty) {
                                    return 'Please select at least one date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: _selectedDates.map((date) {
                            return Chip(
                              side: BorderSide(color: customBlue),
                              label: Text(
                                DateFormat('MMM dd, yyyy').format(date),
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: customDarkBlue,
                              deleteIcon: const Icon(
                                Icons.close,
                                size: 18,
                                color: customBlue,
                              ),
                              onDeleted: () {
                                setState(() {
                                  _selectedDates.remove(date);
                                  _dateController.text = _selectedDates
                                      .map((d) => DateFormat('yyyy-MM-dd').format(d))
                                      .join(', ');
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildSectionTitle('Select Available Day'),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        filled: true,
                        fillColor: Color(0xff21374D),
                      ),
                      hint: const Text("Select a day"),
                      items: _daysOfWeek.map((day) {
                        return DropdownMenuItem<String>(
                          value: day,
                          child: Text(day,style: TextStyle(color: Color(0xffBAC0C6)),),
                        );
                      }).toList(),
                      onChanged: (day) {
                        if (day != null && !_selectedDays.contains(day)) {
                          setState(() {
                            _selectedDays.add(day);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      "Add Time Slots",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: List.generate(
                          timeSlots.length, (index) => _buildTimeSlotWidget(index)),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          timeSlots.add(TimeSlot());
                        });
                      },
                      child: const Text(
                        "Add Time Slot",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Text('Repeat in Every Week'),
                        const SizedBox(width: 16),
                        Switch(
                          value: _sessionRepeat,
                          onChanged: (value) {
                            setState(() {
                              _sessionRepeat = value;
                            });
                          },
                          thumbColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                            return _sessionRepeat ? customBlue : customDarkBlue;
                          }),
                          activeColor: customGrey,
                          inactiveThumbColor: customGrey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Entry Limit",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _entryLimitController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 10),
                    _buildSectionTitle('Session Cover'),
                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: customDarkBlue,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: customBlue),
                        ),
                        child: _pickedImage == null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(CupertinoIcons.share, size: 30, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Upload Image', style: TextStyle(color: Colors.white)),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  _pickedImage!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildActionButtons()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildTimeSlotWidget(int index) {
    final timeSlot = timeSlots[index];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Time Slot ${index + 1}',
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  timeSlots.removeAt(index);
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Start: ${timeSlot.startHour?.toString().padLeft(2, '0')}:${timeSlot.startMinute?.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'End: ${timeSlot.endHour?.toString().padLeft(2, '0')}:${timeSlot.endMinute?.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _selectTime(context, index),
            ),
          ],
        ),
        const Divider(color: Colors.white),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: customBlue,
            // Text color
            side: const BorderSide(color: customBlue, width: 2),
            // Border color and width
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {

                if (widget.gymId == null || widget.gymId.isEmpty) {
                  showSnackbar(context, "Invalid gym ID", type: SnackbarType.error);
                  return;
                }
                if (widget.catagoryId == null || widget.catagoryId.isEmpty) {
                  showSnackbar(context, "Invalid category ID", type: SnackbarType.error);
                  return;
                }
                if (widget.creatorId == null || widget.creatorId.isEmpty) {
                  showSnackbar(context, "Invalid creator ID", type: SnackbarType.error);
                  return;
                }
                print("widgets session model check ${widget.sessionModel}");

                if (widget.sessionModel == null) {
                  final session = SessionModel(
                    gymId: widget.gymId,
                    name: _catagoryNameController.text,
                    categoryId: widget.catagoryId,
                    timeSlots: timeSlots.map((e) => e.toJson()).toList(),
                    days: _selectedDates
                        .map((d) => DateFormat('EEEE, M/d/y').format(d))
                        .toList(),
                    sessionRepeat: _sessionRepeat,
                    entryLimit: _entryLimitController.text,
                    sessionCreatedBy: widget.creatorId,
                    coverImage: _imageUrl,
                    description: _catagoryDescriptionController.text,
                  );
                  await widget.supabaseDb.createSession(session);
                }
                else {
                  final session = widget.sessionModel!.copyWith(
                    name: _catagoryNameController.text,
                    categoryId: widget.catagoryId,
                    timeSlots: timeSlots.map((e) => e.toJson()).toList(),
                    days: _selectedDates
                        .map((d) => DateFormat('EEEE, M/d/y').format(d))
                        .toList(),
                    sessionRepeat: _sessionRepeat,
                    entryLimit: _entryLimitController.text,
                    sessionCreatedBy: widget.creatorId,
                    coverImage: _imageUrl,
                    description: _catagoryDescriptionController.text,
                  );
                  await widget.supabaseDb.updateSession(session);
                }

                Navigator.push(context, MaterialPageRoute(builder: (context)=> SuccessScreen()));
              } catch (e) {
                showSnackbar(context, e.toString(),
                    type: SnackbarType.error);
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Set your desired color here
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

}

class TimeSlot {
  int? startHour;
  int? startMinute;
  int? endHour;
  int? endMinute;
  
  TimeOfDay? get startTime => startHour != null && startMinute != null 
      ? TimeOfDay(hour: startHour!, minute: startMinute!)
      : null;
      
  TimeOfDay? get endTime => endHour != null && endMinute != null 
      ? TimeOfDay(hour: endHour!, minute: endMinute!)
      : null;

  TimeSlot({this.startHour, this.startMinute, this.endHour, this.endMinute});
  
  // Constructor that accepts TimeOfDay objects
  TimeSlot.fromTimeOfDay({TimeOfDay? startTime, TimeOfDay? endTime}) {
    if (startTime != null) {
      startHour = startTime.hour;
      startMinute = startTime.minute;
    }
    if (endTime != null) {
      endHour = endTime.hour;
      endMinute = endTime.minute;
    }
  }

  Map<String, String> toJson() {
    return {
      "start_hour": startHour?.toString() ?? "",
      "start_minute": startMinute?.toString() ?? "",
      "end_hour": endHour?.toString() ?? "",
      "end_minute": endMinute?.toString() ?? "",
      "start_time": startHour != null && startMinute != null
          ? "$startHour:$startMinute"
          : "",
      "end_time": endHour != null && endMinute != null 
          ? "$endHour:$endMinute"
          : "",
    };
  }
}
