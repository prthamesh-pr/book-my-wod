import 'dart:async';

import 'package:bookmywod_admin/bloc/auth_bloc.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_initialize.dart';
import 'package:bookmywod_admin/bloc/states/auth_state.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_forgot_password.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_gym_creation.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_loading.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_logged_in.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_logged_out.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_needs_verification.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_registering.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_uninitialized.dart';
import 'package:bookmywod_admin/bloc/states/auth_state_update_password.dart';
import 'package:bookmywod_admin/screens/admin/add_admin_view.dart';
import 'package:bookmywod_admin/screens/auth_screens/password_update_screen.dart';
import 'package:bookmywod_admin/screens/auth_screens/send_password__reset__mail_screen.dart';
import 'package:bookmywod_admin/screens/auth_screens/sign_in_screen.dart';
import 'package:bookmywod_admin/screens/auth_screens/sign_up_screen.dart';
import 'package:bookmywod_admin/screens/bottom_bar/bottom_bar_template.dart';
import 'package:bookmywod_admin/screens/catagory/create_catagory_view.dart';
import 'package:bookmywod_admin/screens/chat/chatscreen.dart';
import 'package:bookmywod_admin/screens/searchUsers.dart';
import 'package:bookmywod_admin/screens/sessions/create_session_view.dart';
import 'package:bookmywod_admin/screens/sessions/session_view.dart';
import 'package:bookmywod_admin/screens/gym/create_gym_view.dart';
import 'package:bookmywod_admin/screens/notification/notification_screen.dart';
import 'package:bookmywod_admin/screens/sessions/show_session_details_view.dart';
import 'package:bookmywod_admin/services/database/models/session_model.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
import 'package:bookmywod_admin/shared/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

GoRouter appRouter(BuildContext context) {
  final authBloc = BlocProvider.of<AuthBloc>(context);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: BlocGoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final isAuthenticated = authBloc.state is AuthStateLoggedIn;
      final isUnauthenticated = authBloc.state is AuthStateLoggedOut;
      final isRegistering = authBloc.state is AuthStateRegistering;
      final isUpdatingPassword = authBloc.state is AuthStateUpdatePassword;
      final isForgotPassword = authBloc.state is AuthStateForgotPassword;
      final isGymCreation = authBloc.state is AuthStateGymCreation;

      final deepLinkRoute = state.uri.host.isNotEmpty
          ? '/${state.uri.host}${state.uri.path}'
          : state.uri.path;

      debugPrint('deepLinkRoute: $deepLinkRoute');
      final cleanedDeepLinkRoute = deepLinkRoute.replaceAll('"', '');

      debugPrint('cleanedDeepLinkRoute: $cleanedDeepLinkRoute');

      if (cleanedDeepLinkRoute == '/login-callback') {
        return '/home';
      }

      if (cleanedDeepLinkRoute == '/passwordreset-callback') {
        return '/update-password';
      }

      if (isUnauthenticated && state.matchedLocation != '/login') {
        return '/login';
      }

      if (isAuthenticated &&
          (state.matchedLocation == '/login' ||
              state.matchedLocation == '/add-gym')) {
        return '/home';
      }

      if (isRegistering) {
        return '/register';
      }

      if (isGymCreation) {
        return '/add-gym';
      }

      if (isForgotPassword) {
        return '/forgot-password';
      }

      if (isUpdatingPassword) {
        return '/update-password';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthStateUninitialized) {
                context.read<AuthBloc>().add(AuthEventInitialize());
                return LoadingScreen();
              }

              if (state is AuthStateForgotPassword) {
                return SendPasswordResetMailScreen();
              } else if (state is AuthStateRegistering) {
                return SignUpScreen();
              } else if (state is AuthStateUpdatePassword) {
                return PasswordUpdateScreen();
              } else if (state is AuthStateGymCreation) {
                return CreateGymView(
                  authUser: state.authUser,
                );
              } else if (state is AuthStateLoading) {
                return const LoadingScreen();
              } else if (state is AuthStateLoggedIn) {
                return BottomBarTemplate(
                  authUser: state.authUser,
                  supabaseDb: state.supabaseDb,
                );
              } else if (state is AuthStateNeedsVerification) {
                return SignUpScreen();
              } else if (state is AuthStateLoggedOut) {
                return SignInScreen();
              }
              return const Scaffold(
                body: Center(
                  child: SpinKitSpinningLines(color: Colors.blue),
                ),
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          final authBloc = BlocProvider.of<AuthBloc>(context);
          if (authBloc.state is AuthStateLoggedIn) {
            final authUser = (authBloc.state as AuthStateLoggedIn).authUser;
            final supabaseDb = (authBloc.state as AuthStateLoggedIn).supabaseDb;
            return BottomBarTemplate(
              authUser: authUser,
              supabaseDb: supabaseDb,
            );
          } else {
            return const SignInScreen();
          }
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/chat/:userId/:receiverId',  // Define dynamic parameters
        builder: (context, state) {
          final userId = state.pathParameters['userId'];
          final receiverId = state.pathParameters['receiverId'];

          if (userId == null || receiverId == null) {
            throw Exception('Missing required parameters: userId or receiverId');
          }

          return ChatScreen(userId: userId, receiverId: receiverId);
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) {
          final authBloc = BlocProvider.of<AuthBloc>(context);

          if (authBloc.state is AuthStateLoggedIn) {
            final authUser = (authBloc.state as AuthStateLoggedIn).authUser;
            final supabaseDb = (authBloc.state as AuthStateLoggedIn).supabaseDb;
            return SearchUserScreen(supabaseDb:
              supabaseDb,
              authUser: authUser);
          }

          // Ensure a Widget is always returned
          return const Scaffold(
            body: Center(child: Text("Not authenticated")),
          );
        },
      ),



      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const SendPasswordResetMailScreen(),
      ),
      GoRoute(
        path: '/add-gym',
        builder: (context, state) {
          final authBloc = BlocProvider.of<AuthBloc>(context);
          if (authBloc.state is AuthStateGymCreation) {
            final authUser = (authBloc.state as AuthStateGymCreation).authUser;
            return CreateGymView(
              authUser: authUser,
            );
          }
          return const SignInScreen(); // Fallback if state is not correct
        },
      ),
      GoRoute(
        path: '/update-password',
        builder: (context, state) => const PasswordUpdateScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => NotificationScreen(),
      ),
      GoRoute(
        path: '/session-view',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final supabaseDb = extra['supbaseDb'] as SupabaseDb;
          final catagoryName = extra['catagoryName'] as String;
          final catagoryId = extra['catagoryId'] as String;
          final creatorId = extra['creatorId'] as String;
          final gymId = extra['gymId'] as String;
          return SessionView(
            supabaseDb: supabaseDb,
            catagoryName: catagoryName,
            catagoryId: catagoryId,
            creatorId: creatorId,
            gymId: gymId,
          );
        },
      ),
      GoRoute(
        path: '/add-admin',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          final authUser = data['authUser'];
          final userModel = data['userModel'];
          final supabaseDb = data['supabaseDb'];
          return AddAdminView(
            authUser: authUser,
            userModel: userModel,
            supabaseDb: supabaseDb,
          );
        },
      ),
      GoRoute(
        path: '/create-catagory',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {}; // Ensure it's not null

          final supabaseDb = data['supabaseDb'] ?? ''; // Default to an empty string
          final catagoryId = data['catagoryId'] ?? '';
          final creatorId = data['creatorId'] ?? '';
          final gymId = data['gymId'] ?? '';
          final trainerModel = data['trainerModel']; // If this is an object, ensure it's properly handled.

          return CreateCatagoryView(
            supabaseDb: supabaseDb,
            trainerModel: trainerModel,
            catagoryId: catagoryId,
            gymId: gymId,
            creatorId: creatorId,
          );
        },
      ),
      GoRoute(
        path: '/create-session',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          final supabaseDb = data['supabaseDb'];
          final catagoryId = data['catagoryId'];
          final creatorId = data['creatorId'];
          final sessionModel = data['sessionModel'] as SessionModel?;
          final gymId = data['gymId'];

          return CreateSessionView(
            supabaseDb: supabaseDb,
            catagoryId: catagoryId,
            creatorId: creatorId,
            sessionModel: sessionModel,
            gymId: gymId,
          );
        },
      ),
      GoRoute(
          path: '/session-details',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final sessionModel = extra['sessionModel'];
            final creatorId = extra['creatorId'];
            final supabaseDb = extra['supabaseDb'];
            final catagoryId = extra['catagoryId'];
            return ShowSessionDetailsView(
              sessionModel: sessionModel,
              supabaseDb: supabaseDb,
              catagoryId: catagoryId,
              creatorId: creatorId,
            );
          }),
    ],
  );
}

class BlocGoRouterRefreshStream extends ChangeNotifier {
  BlocGoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
