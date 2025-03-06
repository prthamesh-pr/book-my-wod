import 'package:bookmywod_admin/screens/home_screen.dart';
import 'package:bookmywod_admin/services/database/models/trainer_model.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateCatagoryComponent extends StatelessWidget {
  const CreateCatagoryComponent({
    super.key,
    required this.widget,
    required this.trainerModel,
    required this.gymId,
    required this.creatorId,
    required this.catId,

  });

  final HomeScreen widget;
  final TrainerModel? trainerModel;

  final dynamic gymId;

  final dynamic creatorId;

  final dynamic catId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: customDarkBlue,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Add New Categories',
            style: TextStyle(
              color: customWhite,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
              style: ButtonStyle(
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: customBlue,
                    width: 2,
                  ),
                ),
              ),
            onPressed: () {
              GoRouter.of(context).push('/create-catagory', extra: {
                'supabaseDb': widget.supabaseDb,
                'trainerModel': trainerModel,
                'catagoryId': catId,
                'creatorId': creatorId,
                'gymId': gymId,

              });
            },

            child: Text(
                'Add New Categories Home',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              )),
        ],
      ),
    );
  }
}
