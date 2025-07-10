import 'package:flutter/material.dart';
import 'package:lensysapp/evaluacion/widgets/drawer_lensys.dart';
import 'package:lensysapp/services-home/text_size_provider.dart';
import 'package:provider/provider.dart';

class TablaScoreGlobal extends StatelessWidget {
  const TablaScoreGlobal({super.key});

  @override
  Widget build(BuildContext context) {
    final textSizeProvider = Provider.of<TextSizeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resumen Global',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: textSizeProvider.fontSize + 2,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ],
      ),
      endDrawer: const DrawerLensys(),
      body: Center(
        child: Text(
          'Implementa la obtención real de datos para mostrar el score global.',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: textSizeProvider.fontSize,
            color: Colors.grey.shade700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
