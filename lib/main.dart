import 'package:flutter/material.dart';
import 'package:lensysapp/evaluacion/providers/asociados.dart';
import 'package:lensysapp/evaluacion/providers/calificaciones.dart';
import 'package:lensysapp/evaluacion/providers/empresas.dart';
import 'package:lensysapp/evaluacion/providers/evaluacion_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/custom/configurations.dart';
import 'package:lensysapp/custom/routes.dart';
import 'package:lensysapp/perfil/text_size_provider.dart';
import 'package:lensysapp/perfil/theme_provider.dart'; // IMPORTANTE

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Supabase
  await Supabase.initialize(
    url: Configurations.mSupabaseUrl,
    anonKey: Configurations.mSupabaseKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TextSizeProvider()),
        ChangeNotifierProvider(create: (_) => EvaluacionesProvider()),
        ChangeNotifierProvider(create: (_) => AsociadosProvider()),
        ChangeNotifierProvider(create: (_) => EmpresasProvider()),
        ChangeNotifierProvider(create: (_) => CalificacionesProvider()),
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
    final themeProvider = Provider.of<ThemeProvider>(context); // CORRECTO USO

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LensysApp',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        textTheme: const TextTheme(
          titleMedium: TextStyle(fontWeight: FontWeight.bold),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: AppColors.primary,
        textTheme: ThemeData.dark().textTheme.copyWith(
          titleMedium: const TextStyle(fontWeight: FontWeight.bold),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      themeMode: themeProvider.themeMode, 
      initialRoute: '/loader',
      routes: appRoutes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
