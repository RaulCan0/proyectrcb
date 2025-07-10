// principios_screen.dart

import 'package:flutter/material.dart';
import 'package:lensysapp/custom/appcolors.dart';
import '../services/json_service.dart';

class PrincipiosScreen extends StatefulWidget {
  final dynamic empresa;
  final dynamic asociado;
  final String? dimensionId;

  const PrincipiosScreen({
    super.key,
    this.empresa,
    this.asociado,
    this.dimensionId, required String empresaId, required String evaluacionId,
  });

  @override
  State<PrincipiosScreen> createState() => _PrincipiosScreenState();
}

class _PrincipiosScreenState extends State<PrincipiosScreen> {
  List<String> principios = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarPrincipios();
  }

  Future<void> cargarPrincipios() async {
    final data = await JsonService.cargarJson('principios.json');
    setState(() {
      principios = List<String>.from(data);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Principios'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: principios.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        principios[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}