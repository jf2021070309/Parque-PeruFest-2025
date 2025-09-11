class Usuario {
  final String id;
  final String nombre;
  final String correo;
  final String telefono;
  final String rol;
  final String username;
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

  factory Usuario.fromMap(Map<String, dynamic> map, String id) {
    return Usuario(
      id: id,
      nombre: map['nombre'] ?? '',
      username: map['username'] ?? '',
      correo: map['correo'] ?? '',
      telefono: map['telefono'] ?? '',
      rol: map['rol'] ?? 'usuario',
      contrasena: map['contrasena'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'username': username,
      'correo': correo,
      'telefono': telefono,
      'rol': rol,
      'contrasena': contrasena,
    };
  }
}
