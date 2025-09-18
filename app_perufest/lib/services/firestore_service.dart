import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';
import 'package:bcrypt/bcrypt.dart';

class FirestoreService {
  static final _usuarios = FirebaseFirestore.instance.collection('usuarios');

  static Future<void> registrarUsuario(Usuario usuario) async {
    final data = usuario.toJson();
    // Asegurar que no se incluya el campo password
    data.remove('password');
    await _usuarios.add(data);
  }

  static Future<Usuario?> loginUsuario(String correo, String contrasena) async {
    print('🔄 Intentando login para correo: $correo');
    final query =
        await _usuarios.where('correo', isEqualTo: correo).limit(1).get();
    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data();
      print('📄 Datos del usuario encontrados: $data');
      final usuario = Usuario.fromJson(data);
      print('🔐 Contraseña almacenada: ${usuario.contrasena}');
      print('🔑 Verificando contraseña con bcrypt...');
      final coincide = BCrypt.checkpw(contrasena, usuario.contrasena);
      print(coincide ? '✅ Contraseña correcta' : '❌ Contraseña incorrecta');
      if (coincide) {
        return usuario;
      }
    } else {
      print('❌ No se encontró usuario con el correo: $correo');
    }
    return null;
  }

  static Future<bool> correoExiste(String correo) async {
    final query =
        await _usuarios.where('correo', isEqualTo: correo).limit(1).get();
    return query.docs.isNotEmpty;
  }

  // Método para limpiar el campo password de un usuario
  static Future<void> limpiarCampoPassword(String correo) async {
    print('🧹 Limpiando campo password para: $correo');
    final query = await _usuarios.where('correo', isEqualTo: correo).limit(1).get();
    if (query.docs.isNotEmpty) {
      final docRef = query.docs.first.reference;
      await docRef.update({
        'password': FieldValue.delete()
      });
      print('✅ Campo password eliminado exitosamente');
    }
  }
}
