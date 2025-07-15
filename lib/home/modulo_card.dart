import 'package:flutter/material.dart';

class ModuloCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color bgColor;
  final VoidCallback? onTap;

  const ModuloCard({
    required this.title,
    required this.icon,
    required this.bgColor,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
