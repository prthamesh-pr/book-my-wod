// ignore_for_file: deprecated_member_use

import 'package:bookmywod_admin/services/database/models/admin_model.dart';
import 'package:bookmywod_admin/services/database/models/catagory_model.dart';
import 'package:bookmywod_admin/services/database/models/gym_model.dart';
import 'package:bookmywod_admin/services/database/models/session_model.dart';
import 'package:bookmywod_admin/services/database/models/trainer_model.dart';
import 'package:bookmywod_admin/services/database/models/user_model.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/db_constants.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/db_model.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDb implements DbModel {
  late final SupabaseClient _client;

  SupabaseDb() {
    _client = Supabase.instance.client;
  }

// auth users
  @override
  Future<UserModel> createUser(UserModel user) async {
    final response = await _client
        .from(DbConstants.userModel)
        .insert(user.toMap())
        .select()
        .single();

    if (response.isEmpty) {
      throw CouldNotCreateUserException();
    }

    return UserModel.fromMap(response);
  }

  Future<AdminModel?> getAdminByUid(String uid) async {
    final response =
        await _client.from('admins').select().eq('id', uid).maybeSingle();

    if (response == null) return null;
    return AdminModel.fromMap(response);
  }

  Future<Map<String, dynamic>?> createAdmin({
    required String adminId,
    required String uid,
    required String fullName,
    required String email,
    required List<Map<String, dynamic>> uidList,
  }) async {
    final supabase = Supabase.instance.client;

    print(
        "🟢 Inserting Admin: ID=$adminId, UID=$uid, Name=$fullName, Email=$email");

    final response = await supabase
        .from('admins')
        .insert({
          'id': adminId,
          'uid': uid,
          'full_name': fullName,
          'email': email,
          'uid_list': uidList,
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single(); // Return the inserted row

    print("🟡 Insert Response: $response");

    return response;
  }

  Future<void> updateAdmin(
      String adminId, List<Map<String, dynamic>> uidList) async {
    if (adminId.isEmpty) {
      throw Exception("Admin ID cannot be empty");
    }

    print("Updating Admin: $adminId with new UID list: $uidList");

    await _client.from('admins').update({'uid_list': uidList}).match(
        {'id': adminId}); // Ensure this matches your table column name
  }
  Future<bool> doesUserExist(String userId) async {
    print("Checking if user exists with ID: $userId");
    final response = await Supabase.instance.client
        .from(DbConstants.userModel)
        .select('*')
        .eq('id', userId)
        .maybeSingle(); // Fetch a single user

    if (response == null) {
      print("User not found in database!");
    } else {
      print("User exists: ${response.toString()}");
    }


    return response != null;
  }



  // Delete an admin by ID
  Future<bool> deleteAdmin(String id) async {
    try {
      await _client.from('admins').delete().eq('id', id);
      return true;
    } catch (e) {
      print("Error deleting admin: $e");
      return false;
    }
  }

  Future<List<AdminModel>> getAdmins() async {
    final response = await _client
        .from('admins')
        .select('*') // Make sure it selects ALL
        .order('created_at', ascending: false) // Order by latest first
        .limit(100); // Ensure limit is large enough

    return response.map((e) => AdminModel.fromMap(e)).toList();
  }

  @override
  Future<void> deleteUser(String uid) async {
    final response =
        await _client.from(DbConstants.userModel).delete().eq('id', uid);

    if (response.error != null) {
      throw CouldNotDeleteUserException();
    }
  }

  @override
  Future<UserModel?> getUser(String uid) async {
    final response = await _client
        .from(DbConstants.userModel)
        .select()
        .eq('id', uid)
        .maybeSingle();
    if (response == null) {
      return null;
    }

    return UserModel.fromMap(response);
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    final response = await _client
        .from(DbConstants.userModel)
        .update(user.toMap())
        .eq('id', user.id)
        .select()
        .single();
    if (response.isEmpty) {
      throw CouldNotUpdateUserException();
    }

    return UserModel.fromMap(response);
  }

  Stream<TrainerModel> listenToUserChanges(String userId) {
    return _client
        .from(DbConstants.trainers)
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((data) {
          if (data.isNotEmpty) {
            return TrainerModel.fromMap(data.first);
          } else {
            throw CouldNotUpdateUserException();
          }
        });
  }

  @override
  Future<List<TrainerModel>> getUsersByIdLists(List<String> uids) async {
    if (uids.isEmpty) return [];

    final response =
        await _client.from(DbConstants.trainers).select().inFilter('id', uids);

    if (response.isEmpty) {
      return [];
    }

    return response
        .map<TrainerModel>((data) => TrainerModel.fromMap(data))
        .toList();
  }

  @override
  Stream<List<TrainerModel>> getAllTrainerStream() {
    return _client
        .from(DbConstants.trainers)
        .stream(primaryKey: ['id']).map((data) {
      if (data.isNotEmpty) {
        return data
            .map<TrainerModel>((map) => TrainerModel.fromMap(map))
            .toList();
      } else {
        throw CouldNotGetAllUsersException();
      }
    });
  }

  Future<void> fetchReceiverIds(List<String> userIds) async {
    final SupabaseDb db = SupabaseDb();

    try {
      List<String> receiverIds = await db.getReceiverIds(userIds);

      if (receiverIds.isNotEmpty) {
        print("Receiver IDs: $receiverIds");
      } else {
        print("No matching receiver IDs found.");
      }
    } catch (e) {
      print("Error fetching receiver IDs: $e");
    }
  }

  Future<String?> getReceiverIdByName(String receiverName) async {
    final response = await _client
        .from('users')
        .select('id')
        .eq('full_name', receiverName)
        .single();

    if (response != null) {
      return response['id'];
    }
    return null;
  }

  Future<List<String>> getReceiverIds(List<String> userIds) async {
    final users = await getUsersByIdLists(userIds);
    return users.map((user) => user.authId).toList();
  }

  Future<List<TrainerModel>> searchUsersByName(
      String query, String currentUserId) async {
    if (query.isEmpty) return [];

    final response = await _client
        .from(DbConstants.trainers)
        .select()
        .ilike('name', '%$query%')
        .neq('auth_id', currentUserId)
        .limit(10);
    print("api res check $response");

    return response
        .map<TrainerModel>((map) => TrainerModel.fromMap(map))
        .toList();
  }

  Future<List<UserModel>> getAllUsers() async {
    final response = await _client.from(DbConstants.userModel).select();

    if (response.isEmpty) {
      throw CouldNotGetAllUsersException();
    }

    return response.map<UserModel>((map) => UserModel.fromMap(map)).toList();
  }

  @override
  Future<CatagoryModel> createCatagory(CatagoryModel catagory) async {
    final response = await _client
        .from(DbConstants.categories)
        .insert(catagory.toMap())
        .select()
        .single();

    if (response.isEmpty) {
      throw CouldNotCreateCatagoryException();
    }

    return CatagoryModel.fromMap(response);
  }

  @override
  Future<void> deleteCatagory(String catagoryId) async {
    final response = await _client
        .from(DbConstants.categories)
        .delete()
        .eq('id', catagoryId);

    if (response.error != null) {
      throw CouldNotDeleteCatagoryException();
    }
  }

  @override
  Stream<List<CatagoryModel>> getAllCatagoriesByCreator(String creatorId) {
    return _client
        .from(DbConstants.categories)
        .stream(primaryKey: ['id'])
        .eq('created_by', creatorId)
        .map((data) {
          if (data.isNotEmpty) {
            return data
                .map<CatagoryModel>((map) => CatagoryModel.fromMap(map))
                .toList();
          } else {
            throw CouldNotGetAllCatagoryException();
          }
        });
  }

  @override
  Future<CatagoryModel?> getCatagory(String catagoryId) async {
    final response = await _client
        .from(DbConstants.categories)
        .select()
        .eq('id', catagoryId)
        .single();

    if (response.isEmpty) {
      throw CouldNotGetCatagoryException();
    }

    return CatagoryModel.fromMap(response);
  }

  @override
  Future<CatagoryModel> updateCatagory(CatagoryModel catagory) async {
    if (catagory.catagoryId == null) {
      throw CouldNotUpdateCatagoryException();
    }
    final response = await _client
        .from(DbConstants.categories)
        .update(catagory.toMap())
        .eq('id', catagory.catagoryId!)
        .select()
        .single();

    if (response.isEmpty) {
      throw CouldNotUpdateCatagoryException();
    }

    return CatagoryModel.fromMap(response);
  }

  @override
  Future<GymModel> createGym(GymModel gym) async {
    final response = await _client
        .from(DbConstants.gyms)
        .insert(gym.toMap())
        .select()
        .single();

    if (response.isEmpty) {
      throw CouldNotCreateGymException();
    }

    return GymModel.fromMap(response);
  }

  @override
  Future<void> deleteGym(String gymId) async {
    final response =
        await _client.from(DbConstants.gyms).delete().eq('id', gymId);

    if (response.error != null) {
      throw CouldNotDeleteGymException();
    }
  }

  @override
  Stream<List<GymModel>> getAllGyms() {
    return _client
        .from(DbConstants.gyms)
        .stream(primaryKey: ['id']).map((data) {
      if (data.isNotEmpty) {
        return data.map<GymModel>((map) => GymModel.fromMap(map)).toList();
      } else {
        throw CouldNotGetAllGymException();
      }
    });
  }

  @override
  Future<GymModel?> getGym(String gymId) async {
    final response =
        await _client.from(DbConstants.gyms).select().eq('id', gymId).single();

    if (response.isEmpty) {
      return null;
    }

    return GymModel.fromMap(response);
  }

  @override
  Future<GymModel> updateGym(GymModel gym) async {
    if (gym.gymId == null) {
      throw CouldNotUpdateGymException();
    }
    final response = await _client
        .from(DbConstants.gyms)
        .update(gym.toMap())
        .eq('id', gym.gymId!)
        .select()
        .single();

    if (response.isEmpty) {
      throw CouldNotUpdateGymException();
    }

    return GymModel.fromMap(response);
  }

  @override
  Future<SessionModel> createSession(SessionModel session) async {
    final response = await _client
        .from(DbConstants.sessions)
        .insert(session.toMap())
        .select()
        .single();

    if (response.isEmpty) {
      throw CouldNotCreateSessionException();
    }

    return SessionModel.fromMap(response);
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    final response =
        await _client.from(DbConstants.sessions).delete().eq('id', sessionId);

    if (response.error != null) {
      throw CouldNotDeleteSessionException();
    }
  }

  @override
  Stream<List<SessionModel>> getAllSessionsByCatagory(String catagoryId) {
    return _client
        .from(DbConstants.sessions)
        .stream(primaryKey: ['id'])
        .eq('category_id', catagoryId)
        .map((data) {
          if (data.isNotEmpty) {
            return data
                .map<SessionModel>((map) => SessionModel.fromMap(map))
                .toList();
          } else {
            throw CouldNotGetAllSessionsException();
          }
        });
  }

  @override
  Future<SessionModel?> getSession(String sessionId) async {
    final response = await _client
        .from(DbConstants.sessions)
        .select()
        .eq('id', sessionId)
        .single();

    if (response.isEmpty) {
      throw CouldNotGetSessionException();
    }

    return SessionModel.fromMap(response);
  }

  @override
  Future<SessionModel> updateSession(SessionModel session) async {
    if (session.sessionId == null) {
      throw CouldNotUpdateSessionException();
    }
    final response = await _client
        .from(DbConstants.sessions)
        .update(session.toMap())
        .eq('id', session.sessionId!)
        .select()
        .single();

    if (response.isEmpty) {
      throw CouldNotUpdateSessionException();
    }

    return SessionModel.fromMap(response);
  }

  @override
  Future<TrainerModel> createTrainer(TrainerModel trainer) async {
    final response = await _client
        .from(DbConstants.trainers)
        .insert(trainer.toMap())
        .select()
        .single();

    if (response.isEmpty) {
      throw CouldNotCreateTrainerException();
    }

    return TrainerModel.fromMap(response);
  }

  @override
  Future<void> deleteTrainer(String trainerId) async {
    final response =
        await _client.from(DbConstants.trainers).delete().eq('id', trainerId);

    if (response.error != null) {
      throw CouldNotDeleteTrainerException();
    }
  }

  @override
  Future<TrainerModel?> getTrainerByAuthId(String authId) async {
    try {
      final response = await _client
          .from(DbConstants.trainers)
          .select()
          .eq('auth_id', authId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return TrainerModel.fromMap(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<TrainerModel> updateTrainer(TrainerModel trainer) async {
    final response = await _client
        .from(DbConstants.trainers)
        .update(trainer.toMap())
        .eq('auth_id', trainer.authId)
        .select()
        .single();

    if (response.isEmpty) {
      throw CouldNotUpdateTrainerException();
    }

    return TrainerModel.fromMap(response);
  }

  Future<List<TrainerModel>> searchTrainersByName(String query) async {
    if (query.isEmpty) return [];
    final response = await _client
        .from(DbConstants.trainers)
        .select()
        .ilike('name', '%$query%')
        .limit(10);
    return response
        .map<TrainerModel>((map) => TrainerModel.fromMap(map))
        .toList();
  }
}
