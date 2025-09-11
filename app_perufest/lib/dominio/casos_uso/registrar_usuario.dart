import '../modelos/usuario.dart';
import '../repositorios/usuario_repositorio.dart';

class RegistrarUsuario {
  final UsuarioRepositorio repositorio;
  RegistrarUsuario(this.repositorio);

  Future<Usuario> call(
    String nombre,
    String username,
    String correo,
    String telefono,
    String rol,
    String contrasena,
  ) {
    return repositorio.registrar(
      nombre,
      username,
      correo,
      telefono,
      rol,
      contrasena,
    );
  }
}
