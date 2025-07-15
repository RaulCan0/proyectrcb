class Validators {
  static String? required(String? value, {String mensaje = 'Campo obligatorio'}) {
    if (value == null || value.trim().isEmpty) return mensaje;
    return null;
  }

  static String? minLength(String? value, int min, {String mensaje = 'Muy corto'}) {
    if (value == null || value.length < min) return mensaje;
    return null;
  }

  static String? isEmail(String? value, {String mensaje = 'Correo inválido'}) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (value == null || !emailRegex.hasMatch(value)) return mensaje;
    return null;
  }

  static String? isPositiveInt(String? value, {String mensaje = 'Debe ser número positivo'}) {
    final n = int.tryParse(value ?? '');
    if (n == null || n < 0) return mensaje;
    return null;
  }
}
