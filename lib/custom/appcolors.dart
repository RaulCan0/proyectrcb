import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF003056);     // Azul AppBar (0,48,86)
  static const Color c1 = Color(0xFFFF9800);           // Ejecutivo: Naranja
  static const Color c2 = Color(0xFF4CAF50);           // Gerente: Verde
  static const Color c3 = Color(0xFF1976D2);           // Miembro: Azul
  static const Color background = Color(0xFFF5F6FA);   // Gris claro
  static const Color d1 = Color(0xFF63A4FF);           // Azul cielo (claro)
  static const Color d2 = Color(0xFF1976D2);           // Azul medio
  static const Color d3 = Color(0xFF002f5c);           // Azul oscuro
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color darkBackground = Color(0xFF121212);           // Gris
}




// Estilos de texto base y personalizados
const TextStyle appTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.black,
  fontFamily: 'Roboto',
);

// Tamaños personalizados CH, M, G
const TextStyle ch = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.normal,
  color: Colors.black,
  fontFamily: 'Roboto',
);

const TextStyle m = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.normal,
  color: Colors.black,
  fontFamily: 'Roboto',
);

const TextStyle g = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.normal,
  color: Colors.black,
  fontFamily: 'Roboto',
);
