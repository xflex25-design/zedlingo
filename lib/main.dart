import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'dart:io';

import '../core/app_export.dart';
import '../widgets/custom_error_widget.dart';
import '../services/supabase_service.dart';
import '../services/tts_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool hasShownError = false;

  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (!hasShownError) {
      hasShownError = true;
      Future.delayed(const Duration(seconds: 5), () {
        hasShownError = false;
      });
      return CustomErrorWidget(errorDetails: details);
    }
    return SizedBox.shrink();
  };

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Supabase
  try {
    final envFile = File('env.json');
    if (await envFile.exists()) {
      final jsonString = await envFile.readAsString();
      final env = jsonDecode(jsonString) as Map<String, dynamic>;
      final supabaseUrl = env['SUPABASE_URL'] as String?;
      final supabaseAnonKey = env['SUPABASE_ANON_KEY'] as String?;

      if (supabaseUrl != null && supabaseUrl.isNotEmpty && supabaseAnonKey != null && supabaseAnonKey.isNotEmpty) {
        await Supabase.initialize(
          url: supabaseUrl,
          anonKey: supabaseAnonKey,
        );
        await SupabaseService().initialize();
      }
    }
  } catch (e) {
    debugPrint('Supabase initialization error: $e');
  }

  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          title: 'zedlingo',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1.0)),
              child: child!,
            );
          },
          // 🚨 END CRITICAL SECTION
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
        );
      },
    );
  }
}
