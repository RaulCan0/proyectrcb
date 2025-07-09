import 'package:flutter/material.dart';
import 'package:lensysapp/auth/recovery.dart';
import 'package:lensysapp/perfil.dart';
import 'package:provider/provider.dart';
import 'package:lensysapp/auth/loader.dart';
import 'package:lensysapp/auth/login.dart';
import 'package:lensysapp/auth/register.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/custom/configurations.dart';
import 'package:lensysapp/home_app.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Configurations.mSupabaseUrl,
    anonKey: Configurations.mSupabaseKey,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TextSizeProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const LensysApp(),
    ),
  );
}

class LensysApp extends StatelessWidget {
  const LensysApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LensysApp',
      theme: ThemeData(
        brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: AppColors.primary,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
      home: LoaderScreen(),
      routes: {
        '/loader': (context) => const LoaderScreen(),
        '/login': (context) => const Login(),
        '/register': (context) => const RegisterScreen(),
        '/recovery': (context) => const Recovery(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
