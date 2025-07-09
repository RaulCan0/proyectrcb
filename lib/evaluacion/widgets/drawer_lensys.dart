// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


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
    return Drawer(
      child: Container(
        color: Colors.white,
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
                    color: Color.fromARGB(255, 35, 47, 112),
                  ),
                  accountName: Text(nombre, style: const TextStyle(fontSize: 18)),
                  accountEmail: Text(userEmail),
                  currentAccountPicture: (fotoUrl != null && fotoUrl != '')
                      ? CircleAvatar(backgroundImage: NetworkImage(fotoUrl))
                      : const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 40, color: Color.fromARGB(255, 35, 47, 112)),
                        ),
                );
              },
            ),
            // Ejemplo de ListTile, descomenta y ajusta según tus imports y lógica
            /*
            ListTile(
              leading: const Icon(Icons.home, color: Colors.black),
              title: const Text("Inicio"),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const EmpresasScreen()),
                  (route) => false,
                );
              },
            ),
            */
            // ... Agrega aquí el resto de tus ListTile, ajustando los imports y lógica ...
          ],
        ),
      ),
    );
  }
}