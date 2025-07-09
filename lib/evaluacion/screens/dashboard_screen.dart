// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:lensysapp/custom/appcolors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Graficos de la evaluacion',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
            tooltip: 'Refrescar datos',
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
            tooltip: 'Menú',
          ),
        ],
      ),
      body: const Center(
        child: Text('Dashboard UI'),
      ),
    );
  }
}