import 'package:app_links/app_links.dart';
import 'package:bookmywod_admin/bloc/auth_bloc.dart';
import 'package:bookmywod_admin/bloc/chat_bloc.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_logout.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_update_password.dart';
import 'package:bookmywod_admin/bloc/states/auth_state.dart' as state;
import 'package:bookmywod_admin/services/auth/supabase_auth_provider.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:bookmywod_admin/shared/loading_dialog.dart';
import 'package:bookmywod_admin/utils/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ChatBloc()
            ),
  ],
  child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(
        context,
        SupabaseAuthProvider(),
        SupabaseDb(),
        SupabaseDb(),
      ),
      child: Builder(
        builder: (context) {
          final goRouter = appRouter(context);

          return MaterialApp.router(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: customWhite),
              useMaterial3: true,
              textTheme: GoogleFonts.barlowTextTheme(
                ThemeData(brightness: Brightness.light).textTheme,
              ),
            ),
            themeMode: ThemeMode.dark,
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: scaffoldBackgroundColor,
              textTheme: GoogleFonts.barlowTextTheme(
                ThemeData(brightness: Brightness.light).textTheme.apply(
                      bodyColor: Color(0xFFf7f7f7),
                      displayColor: Color(0xFFf7f7f7),
                    ),
              ),
            ),
            routerConfig: goRouter,
          );
        },
      ),
    );
  }
}

class AuthBlocHandler extends StatefulWidget {
  const AuthBlocHandler({super.key});

  @override
  State<AuthBlocHandler> createState() => _AuthBlocHandlerState();
}

class _AuthBlocHandlerState extends State<AuthBlocHandler> {
  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() async {
    final appLinks = AppLinks();

    // Handle initial deep link
    try {
      final initialUri = await appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('Initial deep link received: $initialUri');
        _handleDeepLink(initialUri.toString());
      }
    } catch (e) {
      debugPrint('Error fetching initial deep link: $e');
    }

    // Listen for subsequent deep links
    try {
      appLinks.uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          debugPrint('Deep link received: $uri');
          _handleDeepLink(uri.toString());
        }
      }, onError: (err) {
        debugPrint('Error listening to deep links: $err');
      });
    } catch (e) {
      debugPrint('Exception during deep link initialization: $e');
    }
  }

  void _handleDeepLink(String link) {
    final goRouter = GoRouter.of(context);

    if (link.contains('login-callback')) {
      context.read<AuthBloc>().add(AuthEventLogout());
      goRouter.go('/login');
    } else if (link.contains('passwordreset-callback')) {
      context.read<AuthBloc>().add(AuthEventUpdatePassword(newPassword: ''));
      goRouter.go(
        '/update-password',
      );
    } else {
      debugPrint('Unhandled deep link: $link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, state.AuthState>(
      listener: (context, state) {
        if (state.message != null && state.message!.isError) {
          LoadingDialog().show(
            context: context,
            text: state.message?.message ?? 'Please wait a moment',
          );
        } else {
          LoadingDialog().hide();
        }
      },
      builder: (context, state) {
        // Delegate routing to the router based on AuthBloc state
        return Router(
          routerDelegate: appRouter(context).routerDelegate,
          routeInformationParser: appRouter(context).routeInformationParser,
          routeInformationProvider: appRouter(context).routeInformationProvider,
        );
      },
    );
  }
}
