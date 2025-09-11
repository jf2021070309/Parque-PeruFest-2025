import 'package:flutter/material.dart';
import '../../dominio/modelos/usuario.dart';
import '../../dominio/casos_uso/login_usuario.dart';
import '../../dominio/casos_uso/registrar_usuario.dart';

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
}
