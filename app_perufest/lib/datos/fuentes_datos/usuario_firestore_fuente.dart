import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../dominio/modelos/usuario.dart';

class UsuarioSupabaseFuente {
  // Lazy initialization para evitar problemas de inicialización
  SupabaseClient get _supabase {
    if (!Supabase.instance.isInitialized) {
      throw Exception('Supabase no está inicializado');
    }
    return Supabase.instance.client;
  }

  final String _tabla = 'usuarios';

  Future<Usuario?> obtenerUsuarioPorCorreo(String correo) async {
    try {
      final response = await _supabase
          .from(_tabla)
          .select()
          .eq('correo', correo)
          .limit(1)
          .maybeSingle()
          .timeout(const Duration(seconds: 8));

      if (response == null) return null;
      return Usuario.fromMap(response, response['id'].toString());
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error en obtenerUsuarioPorCorreo: $e');
      }
      return null;
    }
  }

  Future<Usuario> crearUsuario({
    required String nombre,
    required String username,
    required String correo,
    required String telefono,
    required String rol,
    required String contrasena,
  }) async {
    try {
      final response = await _supabase
          .from(_tabla)
          .insert({
            'nombre': nombre,
            'username': username,
            'correo': correo,
            'telefono': telefono,
            'rol': rol,
            'contrasena': contrasena,
          })
          .select()
          .single()
          .timeout(const Duration(seconds: 15));

      return Usuario.fromMap(response, response['id'].toString());
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error en crearUsuario: $e');
      }
      rethrow;
    }
  }

  Future<Usuario?> login(String correo, String contrasena) async {
    try {
      final response = await _supabase
          .from(_tabla)
          .select()
          .eq('correo', correo)
          .eq('contrasena', contrasena)
          .limit(1)
          .maybeSingle()
          .timeout(const Duration(seconds: 10));

      if (response == null) return null;
      return Usuario.fromMap(response, response['id'].toString());
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error en login: $e');
      }
      return null;
    }
  }
}
