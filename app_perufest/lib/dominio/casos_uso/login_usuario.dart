import '../modelos/usuario.dart';
import '../repositorios/usuario_repositorio.dart';

class LoginUsuario {
  final UsuarioRepositorio repositorio;
  LoginUsuario(this.repositorio);

  Future<Usuario?> call(String correo, String contrasena) {
    return repositorio.login(correo, contrasena);
  }
}
