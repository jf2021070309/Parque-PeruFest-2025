class Evento {
  final String? id;
  final String nombre;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String lugar;
  final String descripcion;
  final String? imagenUrl;
  final DateTime fechaCreacion;
  final String creadoPor;

  Evento({
    this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
    required this.lugar,
    required this.descripcion,
    this.imagenUrl,
    required this.fechaCreacion,
    required this.creadoPor,
  });

  factory Evento.fromMap(Map<String, dynamic> map, String id) {
    return Evento(
      id: id,
      nombre: map['nombre'] ?? '',
      fechaInicio: DateTime.parse(map['fecha_inicio']),
      fechaFin: DateTime.parse(map['fecha_fin']),
      lugar: map['lugar'] ?? '',
      descripcion: map['descripcion'] ?? '',
      imagenUrl: map['imagen_url'],
      fechaCreacion: DateTime.parse(map['fecha_creacion']),
      creadoPor: map['creado_por'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'fecha_fin': fechaFin.toIso8601String(),
      'lugar': lugar,
      'descripcion': descripcion,
      'imagen_url': imagenUrl,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'creado_por': creadoPor,
    };
  }

  Evento copyWith({
    String? id,
    String? nombre,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? lugar,
    String? descripcion,
    String? imagenUrl,
    DateTime? fechaCreacion,
    String? creadoPor,
  }) {
    return Evento(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      lugar: lugar ?? this.lugar,
      descripcion: descripcion ?? this.descripcion,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      creadoPor: creadoPor ?? this.creadoPor,
    );
  }
}
