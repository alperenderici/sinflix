import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection_container.dart' as di;
import 'core/services/analytics_service.dart';
import 'core/services/crashlytics_service.dart';
import 'core/utils/app_logger.dart';
import 'firebase_options.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/auth/bloc/auth_bloc.dart';
import 'presentation/auth/bloc/auth_event.dart';
import 'presentation/core/navigation/app_router.dart';
import 'presentation/core/navigation/navigation_service.dart';
import 'presentation/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (check if already initialized)
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.info('Firebase initialized successfully');
  } else {
    AppLogger.info('Firebase already initialized');
  }

  // Initialize Firebase Crashlytics
  if (!kDebugMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Initialize Crashlytics service
  await CrashlyticsService.initialize();
  await CrashlyticsService.setCrashlyticsCollectionEnabled(!kDebugMode);

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependency injection
  await di.init();

  // Log app open event
  await AnalyticsService.logAppOpen();

  AppLogger.info('App initialization completed');

  runApp(const SinflixApp());
}

class SinflixApp extends StatelessWidget {
  const SinflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize router
    NavigationService.router = AppRouter.createRouter();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              di.sl<AuthBloc>()..add(const AuthCheckRequested()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Sinflix',
        debugShowCheckedModeBanner: false,

        // Theme
        theme: AppTheme.darkTheme,

        // Localization
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', ''), Locale('tr', '')],

        // Routing
        routerConfig: NavigationService.router,

        // Builder for global configurations
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling, // Disable text scaling
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
