// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:bookmywod_admin/services/database/models/catagory_model.dart';
import 'package:bookmywod_admin/services/database/models/trainer_model.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:bookmywod_admin/shared/custom_text_field.dart';
import 'package:bookmywod_admin/shared/show_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateCatagoryView extends StatefulWidget {
  final SupabaseDb? supabaseDb;
  final TrainerModel? trainerModel;
  final String? creatorId;
  final String? catagoryId;
  final String? gymId;

  const CreateCatagoryView({
    super.key,
    this.supabaseDb,
    this.trainerModel,
    required this.gymId,
    required this.creatorId,
    required this.catagoryId,
  });

  @override
  State<CreateCatagoryView> createState() => _CreateCatagoryViewState();
}

class _CreateCatagoryViewState extends State<CreateCatagoryView> {
  late final TextEditingController _catagoryNameController;
  late final TextEditingController _catagoryFeaturesController;
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  String? _imageUrl;

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
    } finally {}
  }

  @override
  void initState() {
    print("check category Id ${widget.catagoryId}");
    print("Gym Idcheck ${widget.gymId}");
    print("creator Id Check ${widget.creatorId}");
    _catagoryNameController = TextEditingController();
    _catagoryFeaturesController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _catagoryNameController.dispose();
    _catagoryFeaturesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff05121E),
      appBar: AppBar(
        title: const Text('Add Catagory'),
        backgroundColor: Color(0xff05121E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                    _buildSectionTitle('Categories Name'),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: 'Catagory Name',
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
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Features',
                      controller: _catagoryFeaturesController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 10),
                    _buildSectionTitle('Session Cover'),
                    const SizedBox(height: 10),
                    _buildImagePicker(),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    _buildActionButtons(),
                    const Divider(),
                    const SizedBox(height: 10),
                    _buildCreateSessionButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
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
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                var createdCatagory = CatagoryModel.newCatagory(
                  gymId: widget.trainerModel!.gymId,
                  uuidOfCreator: widget.trainerModel!.trainerId!,
                  image: _imageUrl,
                  name: _catagoryNameController.text,
                  features: _catagoryFeaturesController.text.split(','),
                );

                await widget.supabaseDb?.createCatagory(createdCatagory);

                showSnackbar(
                  context,
                  'Catagory created successfully',
                  type: SnackbarType.success,
                );

                Navigator.pop(context);
              } catch (e) {
                showSnackbar(
                  context,
                  'Error creating category: ${e.toString()}',
                  type: SnackbarType.error,
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Set your desired color here
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
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

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: customGrey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(0xffBAC0C6), // Border color
            width: 2, // Border width
          ),
        ),
        child: _pickedImage == null
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.share, size: 30, color: Colors.white),
                    SizedBox(height: 8),
                    Text('Upload Image', style: TextStyle(color: Colors.white)),
                  ],
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(14),
                // Prevents image from overflowing
                child: Image.file(
                  _pickedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
      ),
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

  Widget _buildCreateSessionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Create Session',
            style: TextStyle(fontSize: 18, color: Colors.white)),
        ElevatedButton(
          onPressed: () {
            print('Navigating with:');
            print('supabaseDb: ${widget.supabaseDb}');
            print('catagoryId: ${widget.catagoryId}');
            print('creatorId: ${widget.creatorId}');
            print('gymId: ${widget.gymId}');
            print('trainerModel: ${widget.trainerModel}');
            GoRouter.of(context).push('/create-session', extra: {
              'supabaseDb': widget.supabaseDb,
              'trainerModel': widget.trainerModel,
              'catagoryId': widget.catagoryId ?? "",
              'creatorId': widget.creatorId ?? "",
              'gymId': widget.gymId?? "",
            });

            // GoRouter.of(context).push('/create-catagory', extra: {
            //   'supabaseDb': widget.supabaseDb,
            //   'trainerModel': widget.trainerModel,
            //   'catagoryId': widget.catagoryId,
            //   'creatorId': widget.creatorId,
            //   'gymId': widget.gymId,
            // });
          },
          style: ElevatedButton.styleFrom(backgroundColor: customGrey),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }
}
