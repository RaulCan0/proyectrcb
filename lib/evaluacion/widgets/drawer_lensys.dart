// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lensysapp/evaluacion/models/empresa.dart';
import 'package:lensysapp/evaluacion/screens/dashboard_screen.dart';
import 'package:lensysapp/evaluacion/screens/empresas_screen.dart';
import 'package:lensysapp/evaluacion/screens/tablas_screen.dart';
import 'package:lensysapp/home/text_size_provider.dart';
import 'package:lensysapp/perfil.dart';
import 'package:lensysapp/auth/loader.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/detalles_evaluacion.dart';
import '../screens/historial_screen.dart';

class DrawerLensys extends StatelessWidget {
  const DrawerLensys({super.key});

  Future<Map<String, dynamic>> _getUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return {'nombre': 'Usuario', 'foto_url': null};
    final data = await Supabase.instance.client
        .from('usuarios')
        .select('nombre, foto_url')
        .eq('id', user.id)
        .single();
    return {
      'nombre': data['nombre'] ?? 'Usuario',
      'foto_url': data['foto_url'],
    };
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final userEmail = user?.email ?? 'usuario@ejemplo.com';
    final textSizeProvider = Provider.of<TextSizeProvider>(context);
    final double scaleFactor = textSizeProvider.fontSize / 14.0;

    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: _getUserData(),
              builder: (context, snapshot) {
                final nombre = snapshot.data?['nombre'] ?? 'Usuario';
                final fotoUrl = snapshot.data?['foto_url'];
                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFF003056),
                  ),
                  accountName: Text(
                    nombre,
                    style: TextStyle(
                      fontSize: 18 * scaleFactor,
                      color: Colors.white,
                    ),
                  ),
                  accountEmail: Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 14 * scaleFactor,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  currentAccountPicture: (fotoUrl != null && fotoUrl.isNotEmpty)
                      ? CircleAvatar(backgroundImage: NetworkImage(fotoUrl), radius: 30 * scaleFactor)
                      : CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30 * scaleFactor,
                          child: Icon(
                            Icons.person,
                            size: 40 * scaleFactor,
                            color: const Color(0xFF003056),
                          ),
                        ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.home, color: Theme.of(context).iconTheme.color, size: 24 * scaleFactor),
              title: Text("Inicio", style: TextStyle(fontSize: 14 * scaleFactor, color: Theme.of(context).textTheme.bodyLarge?.color)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const EmpresasScreen()),
                  (route) => false,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.table_chart, color: Theme.of(context).iconTheme.color, size: 24 * scaleFactor),
              title: Text("Resultados", style: TextStyle(fontSize: 14 * scaleFactor, color: Theme.of(context).textTheme.bodyLarge?.color)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TablasDimensionScreen(
                    empresa: Empresa(
                      id: 'defaultId',
                      nombre: 'Default Empresa',
                      tamano: 'Default Tamano',
                      empleadosTotal: 0,
                      empleadosAsociados: [],
                      unidades: 'Default Unidades',
                      areas: 0,
                      sector: 'Default Sector',
                      createdAt: DateTime.now(),
                    ),
                    evaluacionId: '',
                    asociadoId: '',
                    empresaId: '',
                    dimension: '',
                  )),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_chart, color: Theme.of(context).iconTheme.color, size: 24 * scaleFactor),
              title: Text("Detalle Evaluación", style: TextStyle(fontSize: 14 * scaleFactor, color: Theme.of(context).textTheme.bodyLarge?.color)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetallesEvaluacionScreen(
                    dimensionesPromedios: {},
                    empresaId: '',
                    evaluacionId: '',
                  )),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: Theme.of(context).iconTheme.color, size: 24 * scaleFactor),
              title: Text("Historial", style: TextStyle(fontSize: 14 * scaleFactor, color: Theme.of(context).textTheme.bodyLarge?.color)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistorialScreen(empresas: [], empresasHistorial: [],)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.manage_accounts, color: Theme.of(context).iconTheme.color, size: 24 * scaleFactor),
              title: Text("Ajustes y Perfil", style: TextStyle(fontSize: 14 * scaleFactor, color: Theme.of(context).textTheme.bodyLarge?.color)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PerfilScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard, color: Theme.of(context).iconTheme.color, size: 24 * scaleFactor),
              title: Text("Dashboard", style: TextStyle(fontSize: 14 * scaleFactor, color: Theme.of(context).textTheme.bodyLarge?.color)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DashboardScreen(
                    empresaId: '',
                    evaluacionId: '',
                  )),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.chat, color: Theme.of(context).iconTheme.color, size: 24 * scaleFactor),
              title: Text("Chat", style: TextStyle(fontSize: 14 * scaleFactor, color: Theme.of(context).textTheme.bodyLarge?.color)),
              onTap: () {
                Navigator.of(context).pop();
                // Si tienes un drawer principal, puedes abrirlo aquí si es necesario
              },
            ),
            const Divider(),
            // Selector de tamaño de letra
            
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red, size: 24 * scaleFactor),
              title: Text("Cerrar sesión", style: TextStyle(fontSize: 14 * scaleFactor, color: Theme.of(context).textTheme.bodyLarge?.color)),
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
                Navigator.pushAndRemoveUntil(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (_) => const LoaderScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}