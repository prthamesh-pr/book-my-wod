import 'package:bloc/bloc.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_create_gym.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_facebook_signin.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_gym_creation.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_loading.dart';
import 'package:bookmywod_admin/services/database/models/gym_model.dart';
import 'package:bookmywod_admin/services/database/models/trainer_model.dart';
import 'package:flutter/material.dart';
import 'package:bookmywod_admin/bloc/events/auth_event.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_forgot_password.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_initialize.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_login.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_logout.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_register.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_should_register.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_update_password.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_verify_email.dart';
import 'package:bookmywod_admin/bloc/state_message.dart';
import 'package:bookmywod_admin/bloc/states/auth_state.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_forgot_password.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_logged_in.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_logged_out.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_needs_verification.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_registering.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_uninitialized.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_update_password.dart';
import 'package:bookmywod_admin/services/auth/auth_provider.dart';
import 'package:bookmywod_admin/services/auth/supabase_auth_provider.dart';
import 'package:bookmywod_admin/services/database/models/user_model.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/db_model.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';

import 'events/auth_event_signin_with_google.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  BuildContext context;

  AuthBloc(
    this.context,
    AuthProvider authProvider,
    DbModel dbProvider,
    SupabaseDb supabseDb,
  ) : super(AuthStateUninitialized(
          message: StateMessage(
            'State uninitialized',
            isError: true,
          ),
        )) {
    on<AuthEventInitialize>((event, emit) async {
      final authUser = (authProvider as SupabaseAuthProvider).getCurrentUser;
      if (authUser == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
          message: StateMessage(
            'Please wait till we initialize',
            isError: false,
          ),
        ));
      } else if (!authUser.isEmailVerified) {
        emit(const AuthStateNeedsVerification(
          message: StateMessage(
            'Please verify your email',
            isError: false,
          ),
        ));
      } else {
        var dbUser = await dbProvider.getUser(authUser.id);
        if (dbUser == null) {
          dbUser = UserModel.newUser(
            id: authUser.id,
            fullName: authUser.fullName,
          );
          await dbProvider.createUser(dbUser);
        }
        // emit(AuthStateLoggedIn(
        //   authUser: authUser,
        //   supabaseDb: supabseDb,
        //   message: StateMessage(
        //     'Logged in',
        //     isError: false,
        //   ),
        // ));
        emit(AuthStateLoggedIn(
          authUser: authUser,
          supabaseDb: supabseDb,
          creatorId: dbUser.creatorId ?? '',
          gymId: dbUser.gymId ?? '',
          catagoryId: dbUser.catagoryId ?? '',
          message: StateMessage(
            'Logged in',
            isError: false,
          ),
        ));

      }
    });

    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
        message: StateMessage(
          'Please register',
          isError: false,
        ),
      ));
    });

    on<AuthEventLogout>((event, emit) async {
      try {
        await authProvider.signOut();
        emit(const AuthStateLoggedOut(
          exception: null,
          message: StateMessage(
            'Logged out',
            isError: false,
          ),
        ));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          message: StateMessage(
            e.toString(),
            isError: false,
          ),
        ));
      }
    });

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      final fullName = event.fullName;
      try {
        var result = await authProvider.createUser(
          email: email,
          password: password,
          fullName: fullName,
        );

        final authUser = result;

        final dbSerivce = SupabaseDb();
        final userModel = await dbSerivce.getUser(authUser.id);
        if (userModel == null) {
          await dbSerivce.createUser(
            UserModel.newUser(
              id: authUser.id,
              fullName: fullName,
            ),
          );
        }

        final gym = GymModel.newGym(
          name: event.gymName,
          address: event.gymAddress,
        );

        final createdGym = await dbSerivce.createGym(gym);

        final trainer = TrainerModel.newUser(
          authId: authUser.id,
          fullName: userModel!.fullName,
          gymId: createdGym.gymId ?? '',
          avatarUrl: userModel.avatarUrl,
        );

        await dbSerivce.createTrainer(trainer);

        emit(AuthStateNeedsVerification(
          message: StateMessage(
            'Please verify your email',
            isError: false,
          ),
        ));
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          message: StateMessage(
            e.toString(),
            isError: false,
          ),
        ));
      }
    });

    on<AuthEventLogin>((event, emit) async {
      emit(AuthStateLoading());  // Show loading state

      emit(const AuthStateLoggedOut(
        exception: null,
        message: StateMessage(
          'Logged you out',
          isError: false,
        ),
      ));

      final email = event.email;
      final password = event.password;

      try {
        final authUser = await authProvider.signIn(
          email: email,
          password: password,
        );

        final dbService = SupabaseDb();
        final userModel = await dbService.getUser(authUser.id);
        if (userModel == null) {
          emit(const AuthStateLoggedOut(
            exception: null,
            message: StateMessage(
              'User not found',
              isError: false,
            ),
          ));
          return;
        }

        if (!authUser.isEmailVerified) {
          emit(AuthStateLoggedOut(
            exception: null,
            message: StateMessage(
              'Please verify your email',
              isError: false,
            ),
          ));
          emit(const AuthStateNeedsVerification(
            message: StateMessage(
              'Please verify your email',
              isError: false,
            ),
          ));
        } else if (authUser.isEmailVerified) {
          emit(AuthStateLoggedIn(
            supabaseDb: dbService,
            authUser: authUser,
            creatorId: userModel.creatorId ?? '',
            gymId: userModel.gymId ?? '',
            catagoryId: userModel.catagoryId ?? '',
            message: StateMessage(
              'Logged in successfully',
              isError: false,
            ),
          ));
        } else {
          emit(const AuthStateLoggedOut(
            exception: null,
            message: StateMessage(
              'Logged you out',
              isError: false,
            ),
          ));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          message: StateMessage(
            e.toString(),
            isError: false,
          ),
        ));
      }
    });

    on<AuthEventVerifyEmail>((event, emit) async {
      try {
        var authUser = authProvider.getCurrentUser;
        if (authUser == null) {
          emit(const AuthStateLoggedOut(
            exception: null,
            message: StateMessage(
              'User not found',
              isError: false,
            ),
          ));
          return;
        }

        authUser = await authProvider.refreshUser();
        if (authUser!.isEmailVerified) {
          emit(AuthStateLoggedOut(
            exception: null,
            message: StateMessage(
              'Email verified! You can now log in.',
              isError: false,
            ),
          ));
        } else {
          emit(const AuthStateNeedsVerification(
            message: StateMessage(
              'Please verify your email',
              isError: false,
            ),
          ));
        }
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          message: StateMessage(
            e.toString(),
            isError: false,
          ),
        ));
      }
    });

    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        hasSentEmail: false,
        exception: null,
        message: StateMessage(
          'Click here to reset your password',
          isError: false,
        ),
      ));

      final email = event.email;
      if (email == null) {
        return;
      }
      emit(const AuthStateForgotPassword(
        hasSentEmail: false,
        exception: null,
        message: StateMessage(
          'Please provide your registered email to receive a password reset link',
          isError: false,
        ),
      ));
      bool didSendEmail;
      Exception? exception;

      try {
        await authProvider.sendPasswordResetEmail(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
        emit(AuthStateForgotPassword(
          message: StateMessage(
            'A password reset link has been sent to $email',
            isError: false,
          ),
          hasSentEmail: didSendEmail,
          exception: exception,
        ));
      }
    });

    on<AuthEventUpdatePassword>((event, emit) async {
      try {
        final updatedPassword = event.newPassword;
        await authProvider.updatePassword(newPassword: updatedPassword);
        emit(const AuthStateLoggedOut(
          exception: null,
          message: StateMessage(
            'Password updated',
            isError: false,
          ),
        ));
      } on Exception catch (e) {
        emit(AuthStateUpdatePassword(
          exception: e,
          hasUpdatedPassword: false,
          message: StateMessage(
            e.toString(),
            isError: false,
          ),
        ));
      }
    });

    on<AuthEventCreateGym>((event, emit) async {
      final gym = GymModel.newGym(
        name: event.gymName,
        address: event.gymAddress,
      );

      final createdGym = await supabseDb.createGym(gym);

      final trainer = TrainerModel.newUser(
        authId: event.authUser.id,
        fullName: event.authUser.fullName,
        gymId: createdGym.gymId ?? '',
        avatarUrl: event.authUser.profileImageUrl,
      );

      await supabseDb.createTrainer(trainer);

      emit(AuthStateLoggedIn(
        supabaseDb: supabseDb,
        authUser: event.authUser,

        message: StateMessage(
          'Gym created',
          isError: false,
        ),
      ));
    });

    on<AuthEventSignInWithGoogle>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          message: StateMessage(
            'Logging in with Google',
            isError: false,
          ),
        ),
      );
      try {
        var user = await authProvider.signInWithGoogle();
        var dbProvider = SupabaseDb();

        var dbUser = await dbProvider.getUser(user.id);
        if (dbUser == null) {
          dbUser = UserModel.newUser(
            id: user.id,
            fullName: user.fullName,
          );
          await dbProvider.createUser(dbUser);
        }

        final trainer = await dbProvider.getTrainerByAuthId(user.id);
        if (trainer == null) {
          emit(AuthStateGymCreation(
            authUser: user,
            exception: null,
            message: StateMessage('Please create a gym', isError: false),
          ));
        } else {
          await dbProvider.updateTrainer(
            trainer.copyWith(avatarUrl: user.profileImageUrl),
          );
          emit(AuthStateLoggedIn(
            supabaseDb: supabseDb,
            authUser: user,
          ));
        }
      } on Exception catch (e) {
        AuthStateLoggedOut(
          exception: e,
          message: StateMessage(
            'Loggin failed',
            isError: false,
          ),
        );
      }
    });
    // on<AuthEventSignInWithFacebook>((event, emit) async {
    //   emit(
    //     const AuthStateLoggedOut(
    //       exception: null,
    //       message: StateMessage(
    //         'Logging in with Facebook',
    //         isError: false,
    //       ),
    //     ),
    //   );
    //
    //   try {
    //     var user = await authProvider.signInWithFacebook();  // ✅ Corrected function
    //     var dbProvider = SupabaseDb();
    //
    //     var dbUser = await dbProvider.getUser(user.id);
    //     if (dbUser == null) {
    //       dbUser = UserModel.newUser(
    //         id: user.id,
    //         fullName: user.fullName,
    //       );
    //       await dbProvider.createUser(dbUser);
    //     }
    //
    //     final trainer = await dbProvider.getTrainerByAuthId(user.id);
    //     if (trainer == null) {
    //       emit(AuthStateGymCreation(
    //         authUser: user,
    //         exception: null,
    //         message: StateMessage('Please create a gym', isError: false),
    //       ));
    //     } else {
    //       await dbProvider.updateTrainer(
    //         trainer.copyWith(avatarUrl: user.profileImageUrl),
    //       );
    //       emit(AuthStateLoggedIn(
    //         supabaseDb: supabseDb,
    //         authUser: user,
    //       ));
    //     }
    //   } on Exception catch (e) {
    //     emit(
    //       AuthStateLoggedOut(
    //         exception: e,
    //         message: StateMessage(
    //           'Login failed',
    //           isError: true,
    //         ),
    //       ),
    //     );
    //   }
    // });
    on<AuthEventSignInWithFacebook>((event, emit) async {
      emit(const AuthStateLoading());

      try {
        var user = await authProvider.signInWithFacebook();
        var dbProvider = SupabaseDb();

        var dbUser = await dbProvider.getUser(user.id);
        if (dbUser == null) {
          dbUser = UserModel.newUser(
            id: user.id,
            fullName: user.fullName,
          );
          await dbProvider.createUser(dbUser);
        }

        final trainer = await dbProvider.getTrainerByAuthId(user.id);
        if (trainer == null) {
          emit(AuthStateGymCreation(
            authUser: user,
            exception: null,
            message: StateMessage('Please create a gym', isError: false),
          ));
        } else {
          await dbProvider.updateTrainer(
            trainer.copyWith(avatarUrl: user.profileImageUrl),
          );
          emit(AuthStateLoggedIn(
            supabaseDb: supabseDb,
            authUser: user,
          ));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          message: StateMessage('Login failed', isError: true),
        ));
      }
    });

  }
}
