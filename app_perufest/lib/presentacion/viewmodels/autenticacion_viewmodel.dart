import 'package:flutter/material.dart';
import '../../dominio/modelos/usuario.dart';
import '../../dominio/casos_uso/login_usuario.dart';
import '../../dominio/casos_uso/registrar_usuario.dart';
import '../../core/servicios/autenticacion_service.dart';

enum EstadoAutenticacion { inicial, cargando, autenticado, error }

class AutenticacionViewModel extends ChangeNotifier {
  final LoginUsuario loginUsuario;
  final RegistrarUsuario registrarUsuario;

  EstadoAutenticacion estado = EstadoAutenticacion.inicial;
  String? mensajeError;
  Usuario? usuario;

  AutenticacionViewModel({
    required this.loginUsuario,
    required this.registrarUsuario,
  });

  Future<void> login(String correo, String contrasena) async {
    if (estado == EstadoAutenticacion.cargando) {
      return; // Prevenir múltiples llamadas
    }

    estado = EstadoAutenticacion.cargando;
    mensajeError = null;
    notifyListeners();

    try {
      // Simular un pequeño delay para mejorar UX
      await Future.delayed(const Duration(milliseconds: 100));

      final user = await loginUsuario(correo, contrasena);
      if (user != null) {
        usuario = user;
        estado = EstadoAutenticacion.autenticado;
        mensajeError = null;
      } else {
        estado = EstadoAutenticacion.error;
        mensajeError = 'Credenciales incorrectas';
      }
    } catch (e) {
      print('Error en login: $e');
      estado = EstadoAutenticacion.error;
      mensajeError = 'Error de conexión. Intenta de nuevo.';
    }
    notifyListeners();
  }

  Future<void> registrar(
    String nombre,
    String username,
    String correo,
    String telefono,
    String rol,
    String contrasena,
  ) async {
    if (estado == EstadoAutenticacion.cargando) {
      return; // Prevenir múltiples llamadas
    }

    estado = EstadoAutenticacion.cargando;
    mensajeError = null;
    notifyListeners();

    try {
      // Simular un pequeño delay para mejorar UX
      await Future.delayed(const Duration(milliseconds: 100));

      final user = await registrarUsuario(
        nombre,
        username,
        correo,
        telefono,
        rol,
        contrasena,
      );
      usuario = user;
      estado = EstadoAutenticacion.autenticado;
      mensajeError = null;
    } catch (e) {
      print('Error real al registrar usuario: $e');
      estado = EstadoAutenticacion.error;
      mensajeError =
          'Error al registrar. Verifica tu conexión e intenta de nuevo.';
    }
    notifyListeners();
  }

  void reset() {
    estado = EstadoAutenticacion.inicial;
    mensajeError = null;
    notifyListeners();
  }

  // ========================================
  // 🔐 MÉTODOS CON ENCRIPTACIÓN BCRYPT
  // ========================================

  final AutenticacionService _autenticacionService = AutenticacionService();

  /// LOGIN con bcrypt - Método alternativo más seguro
  Future<void> loginSeguro(String correo, String contrasena) async {
    if (estado == EstadoAutenticacion.cargando) {
      return; // Prevenir múltiples llamadas
    }

    estado = EstadoAutenticacion.cargando;
    mensajeError = null;
    notifyListeners();

    try {
      print('🔐 Iniciando login seguro con bcrypt...');

      final usuarioData = await _autenticacionService.iniciarSesion(
        correo,
        contrasena,
      );

      if (usuarioData != null) {
        // Convertir Map a objeto Usuario si es necesario
        usuario = Usuario(
          id: usuarioData['id'],
          nombre: usuarioData['nombre'],
          username: usuarioData['username'],
          correo: usuarioData['correo'],
          telefono: usuarioData['telefono'],
          rol: usuarioData['rol'],
          contrasena: '', // No almacenar contraseña
        );
        estado = EstadoAutenticacion.autenticado;
        mensajeError = null;
        print('✅ Login seguro exitoso');
      } else {
        estado = EstadoAutenticacion.error;
        mensajeError = 'Correo o contraseña incorrectos';
        print('❌ Login seguro fallido');
      }
    } catch (e) {
      print('❌ Error en login seguro: $e');
      estado = EstadoAutenticacion.error;
      mensajeError = 'Error de conexión. Intenta de nuevo.';
    }
    notifyListeners();
  }

  /// REGISTRO con bcrypt - Método alternativo más seguro
  Future<void> registrarSeguro({
    required String nombre,
    required String username,
    required String correo,
    required String telefono,
    required String contrasena,
    String rol = 'usuario',
  }) async {
    if (estado == EstadoAutenticacion.cargando) {
      return; // Prevenir múltiples llamadas
    }

    estado = EstadoAutenticacion.cargando;
    mensajeError = null;
    notifyListeners();

    try {
      print('🔐 Iniciando registro seguro con bcrypt...');

      final exito = await _autenticacionService.registrarUsuario(
        nombre: nombre,
        username: username,
        correo: correo,
        telefono: telefono,
        contrasena: contrasena, // Se encripta automáticamente
        rol: rol,
      );

      if (exito) {
        // Después del registro exitoso, hacer login automático
        print('🔐 Haciendo login automático después del registro...');

        final usuarioData = await _autenticacionService.iniciarSesion(
          correo,
          contrasena,
        );

        if (usuarioData != null) {
          // Convertir Map a objeto Usuario si es necesario
          usuario = Usuario(
            id: usuarioData['id'],
            nombre: usuarioData['nombre'],
            username: usuarioData['username'],
            correo: usuarioData['correo'],
            telefono: usuarioData['telefono'],
            rol: usuarioData['rol'],
            contrasena: '', // No almacenar contraseña
          );
          estado = EstadoAutenticacion.autenticado;
          mensajeError = null;
          print('✅ Registro y login automático exitosos');
        } else {
          estado = EstadoAutenticacion.error;
          mensajeError = 'Usuario registrado pero error en login automático';
          print('❌ Error en login automático después del registro');
        }
      } else {
        estado = EstadoAutenticacion.error;
        mensajeError = 'Error al registrar. El correo o username ya existen.';
        print('❌ Registro seguro fallido');
      }
    } catch (e) {
      print('❌ Error en registro seguro: $e');
      estado = EstadoAutenticacion.error;
      mensajeError =
          'Error al registrar. Verifica tu conexión e intenta de nuevo.';
    }

    print('🔄 Estado final del registro: $estado');
    notifyListeners();
  }
}
