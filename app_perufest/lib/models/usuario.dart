class Usuario {
  final String id;
  final String nombre;
  final String username;
  final String correo;
  final String telefono;
  final String rol;
  final String contrasena;

  Usuario({
    required this.id,
    required this.nombre,
    required this.username,
    required this.correo,
    required this.telefono,
    required this.rol,
    required this.contrasena,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre'] ?? '',
      username: json['username'] ?? '',
      correo: json['correo'] ?? '',
      telefono: json['telefono'] ?? '',
      rol: json['rol'] ?? 'usuario',
      contrasena: json['contrasena'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'username': username,
      'correo': correo,
      'telefono': telefono,
      'rol': rol,
      'contrasena': contrasena,
    };
  }

  @override
  String toString() {
    return 'Usuario(id: $id, nombre: $nombre, correo: $correo)';
  }
}
