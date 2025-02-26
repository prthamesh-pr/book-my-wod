import 'package:bookmywod_admin/services/database/models/catagory_model.dart';
import 'package:bookmywod_admin/services/database/models/gym_model.dart';
import 'package:bookmywod_admin/services/database/models/session_model.dart';
import 'package:bookmywod_admin/services/database/models/trainer_model.dart';
import 'package:bookmywod_admin/services/database/models/user_model.dart';

abstract class DbModel {
  // for user model
  Future<UserModel> createUser(UserModel user);

  Future<UserModel?> getUser(String uid);

  Future<void> deleteUser(String uid);

  Future<UserModel> updateUser(UserModel user);

  // for trainer
  Future<TrainerModel> createTrainer(TrainerModel trainer);

  Future<TrainerModel?> getTrainerByAuthId(String trainerId);

  Future<void> deleteTrainer(String uid);

  Future<TrainerModel> updateTrainer(TrainerModel trainer);

  Stream<List<TrainerModel>> getAllTrainerStream();

  Future<List<TrainerModel>> getUsersByIdLists(List<String> uidList);

  // for catagory
  Future<CatagoryModel> createCatagory(CatagoryModel catagory);

  Future<CatagoryModel?> getCatagory(String catagoryId);

  Future<void> deleteCatagory(String catagoryId);

  Future<CatagoryModel> updateCatagory(CatagoryModel catagory);

  Stream<List<CatagoryModel>> getAllCatagoriesByCreator(String creatorId);

  // for gym
  Future<GymModel> createGym(GymModel gym);

  Future<GymModel?> getGym(String gymId);

  Future<void> deleteGym(String gymId);

  Future<GymModel> updateGym(GymModel gym);

  Stream<List<GymModel>> getAllGyms();

  // for sessions
  Future<SessionModel> createSession(SessionModel session);

  Future<SessionModel?> getSession(String sessionId);

  Future<void> deleteSession(String sessionId);

  Future<SessionModel> updateSession(SessionModel session);

  Stream<List<SessionModel>> getAllSessionsByCatagory(String catagoryId);
}
