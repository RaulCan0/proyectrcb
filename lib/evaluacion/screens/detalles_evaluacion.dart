import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../widgets/endrawer_lensys.dart';

class DetallesEvaluacionScreen extends StatefulWidget {
  final Map<String, Map<String, double>> dimensionesPromedios;
  final String empresaId; // UUID de la empresa
  final String evaluacionId; // UUID de la evaluación
  final String? dimension;
  final int? initialTabIndex;

  const DetallesEvaluacionScreen({
    super.key,
    required this.dimensionesPromedios,
    required this.empresaId,
    required this.evaluacionId,
    this.dimension,
    this.initialTabIndex,
  });

  @override
  State<DetallesEvaluacionScreen> createState() => _DetallesEvaluacionScreenState();
}

class _DetallesEvaluacionScreenState extends State<DetallesEvaluacionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.dimensionesPromedios.keys.length,
      vsync: this,
      initialIndex: widget.initialTabIndex ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(width: screenSize.width * 0.8, child: const EndrawerLensys()),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Graficos por Dimensión',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF003056),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.white,
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(screenSize.height * 0.05),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.grey.shade300,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey.shade300,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: widget.dimensionesPromedios.keys
                .map((key) => Tab(text: key))
                .toList(),
          ),
        ),
      ),
      endDrawer: SizedBox(width: screenSize.width * 0.8, child: const EndrawerLensys()),
      body: TabBarView(
        controller: _tabController,
        children: widget.dimensionesPromedios.keys.map((dimension) {
          final promedios = widget.dimensionesPromedios[dimension]!;
          return _buildDimensionDetails(context, dimension, promedios);
        }).toList(),
      ),
    );
  }

  Widget _buildDimensionDetails(
    BuildContext context,
    String dimension,
    Map<String, double> promedios,
  ) {
    final screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: screenSize.height * 0.05,
        horizontal: screenSize.width * 0.1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Aquí iría tu widget de promedio general, por ejemplo:
          // _buildPromedioGeneralCard(context, promedios, ...)
          SizedBox(height: screenSize.height * 0.02),
          // Aquí iría tu dropdown de asociados, por ejemplo:
          // _buildDropdownAssociates(dimension),
          SizedBox(height: screenSize.height * 0.02),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003056),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.leaderboard),
            label: const Text('Ver Dashboard'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DashboardScreen(
                    empresaId: widget.empresaId,
                    evaluacionId: widget.evaluacionId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}