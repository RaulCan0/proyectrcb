class DimensionService {
  static const Map<String, String> idToNombre = {
    '1': 'IMPULSORES CULTURALES',
    '2': 'MEJORA CONTINUA',
    '3': 'ALINEAMIENTO EMPRESARIAL',
  };

  static const Map<String, String> nombreToId = {
    'IMPULSORES CULTURALES': '1',
    'MEJORA CONTINUA': '2',
    'ALINEAMIENTO EMPRESARIAL': '3',
  };

  static String nombrePorId(String id) => idToNombre[id] ?? '';
  static String idPorNombre(String nombre) => nombreToId[nombre] ?? '';
  static List<String> nombres() => idToNombre.values.toList();
  static List<String> ids() => idToNombre.keys.toList();
}