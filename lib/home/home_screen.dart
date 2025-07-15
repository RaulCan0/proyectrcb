import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:lensysapp/home/home_view_model.dart';
import 'package:lensysapp/home/modulo_card.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/evaluacion/screens/empresas_screen.dart';
import 'package:lensysapp/perfil/perfil_screen.dart';
import 'package:lensysapp/perfil/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..loadUserData(),
      child: Consumer<HomeViewModel>(
        builder: (context, vm, _) {
          final themeProvider = context.watch<ThemeProvider>();
          final user = Supabase.instance.client.auth.currentUser;

          return Scaffold(
            backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(vm, user, context),
                  const SizedBox(height: 20),
                  Expanded(child: _buildCarousel(vm, themeProvider, context)),
                ],
              ),
            ),
            bottomNavigationBar: ConvexAppBar(
              backgroundColor: AppColors.primary,
              color: Colors.white70,
              activeColor: Colors.white,
              style: TabStyle.react,
              items: const [
                TabItem(icon: Icons.logout, title: 'Cerrar Sesión'),
                TabItem(icon: Icons.home, title: 'Inicio'),
                TabItem(icon: Icons.person, title: 'Perfil'),
              ],
              initialActiveIndex: vm.selectedIndex,
              onTap: (index) async {
                if (index == 0) {
                  await vm.signOut(context);
                } else if (index == 2) {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => const PerfilScreen()));
                  vm.setSelectedIndex(1);
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(HomeViewModel vm, User? user, BuildContext context) {
    final theme = Theme.of(context);
    final fotoUrl = vm.userData['foto_url'] ?? user?.userMetadata?['avatar_url'] ?? '';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, const Color.fromARGB(255, 75, 33, 129)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            backgroundImage: fotoUrl.isNotEmpty ? NetworkImage(fotoUrl) : null,
            child: fotoUrl.isEmpty
                ? const Icon(Icons.person, size: 40, color: Color(0xFF003056))
                : null,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user?.email ?? 'Sin email',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 4),
              const Text('Bienvenido', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel(HomeViewModel vm, ThemeProvider theme, BuildContext context) {
    return Stack(
      children: [
        ListView(
          controller: vm.scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 50),
          children: [
            ModuloCard(
              title: 'Diagnóstico',
              icon: Icons.analytics_outlined,
              bgColor: theme.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const EmpresasScreen()));
              },
            ),
            const SizedBox(width: 20),
            ModuloCard(
              title: 'Próximamente EVSM',
              icon: Icons.upcoming,
              bgColor: theme.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              onTap: null,
            ),
            const SizedBox(width: 20),
            ModuloCard(
              title: 'No disponible',
              icon: Icons.extension,
              bgColor: theme.isDarkMode ? Colors.grey.shade600 : Colors.grey.shade100,
              onTap: null,
            ),
          ],
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 30),
              onPressed: vm.scrollLeft,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 30),
              onPressed: vm.scrollRight,
            ),
          ),
        ),
      ],
    );
  }
}
