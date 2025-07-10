import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/evaluacion/screens/empresas_screen.dart';
import 'package:lensysapp/perfil.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  final ScrollController _scrollController = ScrollController();

 void _onItemTapped(int index) async {
   setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/loader');
      }
    } else if (index == 2) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PerfilScreen()),
      );
      setState(() {
        _selectedIndex = 1;
      });
    }
    }


  void _scrollLeft() {
    final newOffset = (_scrollController.offset - 200).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _scrollRight() {
    final newOffset = (_scrollController.offset + 200).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final textSizeProvider = Provider.of<TextSizeProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header usuario
            Container(
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
                    backgroundImage: NetworkImage(
                      user?.userMetadata?['avatar_url'] ??
                          'https://ui-avatars.com/api/?name=${user?.email ?? 'U'}',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.email ?? 'Sin email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: textSizeProvider.fontSize + 3,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Bienvenido',
                        style: TextStyle(color: Colors.white70, fontSize: 15, fontFamily: 'Roboto'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Carrousel con flechas
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    children: [
                      _DashboardCard(
                        title: 'Diagnóstico',
                        icon: Icons.analytics_outlined,
                        bgColor: themeProvider.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EmpresasScreen()),
                          );
                        },
                      ),
                      const SizedBox(width: 20),
                      _DashboardCard(
                        title: 'Próximamente EVSM',
                        icon: Icons.upcoming,
                        bgColor: themeProvider.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                        onTap: null,
                      ),
                      const SizedBox(width: 20),
                      _DashboardCard(
                        title: 'no disponible',
                        icon: Icons.extension,
                        bgColor: themeProvider.isDarkMode ? Colors.grey.shade600 : Colors.grey.shade100,
                        onTap: null,
                      ),
                    ],
                  ),

                  // Botón izquierda
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 30),
                        onPressed: _scrollLeft,
                      ),
                    ),
                  ),

                  // Botón derecha
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 30),
                        onPressed: _scrollRight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Navbar estilo curved
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: AppColors.primary,
        color: Colors.white70,
        activeColor: Colors.white,
        style: TabStyle.react, // Prueba TabStyle.fixedCircle si deseas más curvatura
        items: const [
          TabItem(icon: Icons.logout, title: 'Cerrar Sesión'),
          TabItem(icon: Icons.home, title: 'Inicio'),
          TabItem(icon: Icons.person, title: 'Perfil'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color bgColor;
  final VoidCallback? onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textSizeProvider = Provider.of<TextSizeProvider>(context, listen: true);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (title == 'Diagnóstico')
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/shingomodel.webp',
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              )
            else
              Icon(icon, size: 60, color: Colors.black87),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: textSizeProvider.fontSize + 5,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
