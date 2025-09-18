import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';
import 'package:bcrypt/bcrypt.dart';

class FirestoreService {
  static final _usuarios = FirebaseFirestore.instance.collection('usuarios');

  static Future<void> registrarUsuario(Usuario usuario) async {
    await _usuarios.add(usuario.toJson());
  }

  static Future<Usuario?> loginUsuario(String correo, String contrasena) async {
    final query =
        await _usuarios.where('correo', isEqualTo: correo).limit(1).get();
    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data();
      final usuario = Usuario.fromJson(data);
      // Verificar la contraseña con bcrypt
      if (BCrypt.checkpw(contrasena, usuario.contrasena)) {
        return usuario;
      }
    }
    return null;
  }

  static Future<bool> correoExiste(String correo) async {
    final query =
        await _usuarios.where('correo', isEqualTo: correo).limit(1).get();
    return query.docs.isNotEmpty;
  }
}
