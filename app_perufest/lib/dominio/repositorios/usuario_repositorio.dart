import '../../dominio/modelos/usuario.dart';

abstract class UsuarioRepositorio {
  Future<Usuario?> login(String correo, String contrasena);
  Future<Usuario> registrar(
    String nombre,
    String username,
    String correo,
    String telefono,
    String rol,
    String contrasena,
  );
  Future<Usuario?> obtenerUsuarioActual();
  Future<void> logout();
}
