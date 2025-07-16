import 'package:flutter/material.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/evaluacion/providers/datos_provider.dart';
import 'package:lensysapp/home/text_size_provider.dart';
import 'package:lensysapp/home/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Configuración Supabase
import 'package:lensysapp/custom/configurations.dart';

import 'package:lensysapp/custom/routes.dart';
// Providers
import 'package:lensysapp/evaluacion/providers/empresas.dart';
import 'package:lensysapp/evaluacion/providers/asociados.dart';
import 'package:lensysapp/evaluacion/providers/score_global_provider.dart';
import 'package:lensysapp/evaluacion/providers/calificaciones.dart';
import 'package:lensysapp/evaluacion/providers/evaluacion_provider.dart';
import 'package:lensysapp/evaluacion/providers/resultados.dart';
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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => EmpresasProvider()),
        ChangeNotifierProvider(create: (_) => DatosProvider()),
        ChangeNotifierProvider(create: (_) => AsociadosProvider()),
        ChangeNotifierProvider(create: (_) => ScoreGlobalProvider()),
        ChangeNotifierProvider(create: (_) => CalificacionesProvider()),
        ChangeNotifierProvider(create: (_) => EvaluacionesProvider()),
        ChangeNotifierProvider(create: (_) => ResultadosDashboardProvider()),
      ],
      child: const LensysApp(),
    ),
  );
}
class LensysApp extends StatelessWidget {
  const LensysApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LensysApp',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        textTheme: TextTheme(
          titleMedium: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: AppColors.primary,
        textTheme: ThemeData.dark().textTheme.copyWith(
          titleMedium: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/loader',
      routes: appRoutes,
      onGenerateRoute: onGenerateRoute,
    );
  }}