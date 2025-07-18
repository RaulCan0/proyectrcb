import 'package:flutter/material.dart';
// Importa todas tus pantallas aquí
import 'package:lensysapp/auth/loader.dart';
import 'package:lensysapp/auth/login.dart';
import 'package:lensysapp/auth/register.dart';
import 'package:lensysapp/auth/recovery.dart';
import 'package:lensysapp/evaluacion/screens/detalles_evaluacion.dart';
import 'package:lensysapp/home/home_app.dart';
import 'package:lensysapp/perfil.dart';
import 'package:lensysapp/evaluacion/screens/empresas_screen.dart';
import 'package:lensysapp/evaluacion/screens/dimensiones_screen.dart';
import 'package:lensysapp/evaluacion/screens/asociado_screen.dart';
import 'package:lensysapp/evaluacion/screens/principios_screen.dart';
import 'package:lensysapp/evaluacion/screens/comportamiento_evaluacion_screen.dart';
import 'package:lensysapp/evaluacion/screens/tabla_score_global.dart';
// import eliminado porque no existe ese archivo
import 'package:lensysapp/evaluacion/screens/dashboard_screen.dart';
import 'package:lensysapp/evaluacion/screens/shingo_result.dart';

// Modelos para argumentos
import 'package:lensysapp/evaluacion/models/empresa.dart';

/// Mapa de rutas simples (sin argumentos)
final Map<String, WidgetBuilder> appRoutes = {
  '/loader': (ctx) => const LoaderScreen(),
  '/login': (ctx) => const Login(),
  '/register': (ctx) => const RegisterScreen(),
  '/recovery': (ctx) => const Recovery(),
  '/home': (ctx) => const HomeScreen(),
  '/empresas': (ctx) => const EmpresasScreen(),
  '/perfil': (ctx) => const PerfilScreen(),
  '/shingoresult': (ctx) => const ShingoResultsScreen(),
  '/tablascoreglobal': (ctx) => const TablaScoreGlobal(),
};

/// onGenerateRoute para rutas con argumentos
Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/dimensiones': {
      final empresa = settings.arguments as Empresa;
      return MaterialPageRoute(
        builder: (_) => DimensionesScreen(
          empresa: empresa,
          evaluacionId: empresa.id,
        ),
      );
    }
    case '/asociados': {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => AsociadoScreen(
          empresa: args['empresaId'],
          dimensionId: args['dimensionId'],
          evaluacionId: args['evaluacionId'],
        ),
      );
    }
    case '/principios': {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => PrincipiosScreen(
          empresa: args['empresa'],
          asociado: args['asociado'],
          dimensionId: args['dimensionId'],
          evaluacionId: args['evaluacionId'],
        ),
      );
    }
    case '/comportamientoevaluacion': {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => ComportamientoEvaluacionScreen(
          principio: args['principio'],
          cargo: args['cargo'],
          evaluacionId: args['evaluacionId'],
          dimensionId: args['dimensionId'],
          empresaId: args['empresaId'],
          asociadoId: args['asociadoId'],
        ),
      );
    }
    case '/detalleevaluacion': {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => DetallesEvaluacionScreen(
          empresaId: args['empresaId'],
          evaluacionId: args['evaluacionId'],
          dimensionesPromedios: args['dimensionesPromedios'] ?? {},
        ),
      );
    }
    case '/dashboard': {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => DashboardScreen(
          empresaId: args['empresaId'],
          evaluacionId: args['evaluacionId'],
        ),
      );
    }
    default:
      return null;
  }
}

/// Uso recomendado en tu MaterialApp:
/// MaterialApp(
///   routes: appRoutes,
///   onGenerateRoute: onGenerateRoute,
/// )
