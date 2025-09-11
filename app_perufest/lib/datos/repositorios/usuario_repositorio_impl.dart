import '../../dominio/modelos/usuario.dart';
import '../../dominio/repositorios/usuario_repositorio.dart';
import '../fuentes_datos/usuario_firestore_fuente.dart'
    show UsuarioSupabaseFuente;

class UsuarioRepositorioImpl implements UsuarioRepositorio {
  final UsuarioSupabaseFuente fuente;
  Usuario? _usuarioActual;

  UsuarioRepositorioImpl(this.fuente);

  @override
  Future<Usuario?> login(String correo, String contrasena) async {
    final usuario = await fuente.login(correo, contrasena);
    _usuarioActual = usuario;
    return usuario;
  }

  @override
  Future<Usuario> registrar(
    String nombre,
    String username,
    String correo,
    String telefono,
    String rol,
    String contrasena,
  ) async {
    final usuario = await fuente.crearUsuario(
      nombre: nombre,
      username: username,
      correo: correo,
      telefono: telefono,
      rol: rol,
      contrasena: contrasena,
    );
    _usuarioActual = usuario;
    return usuario;
  }

  @override
  Future<Usuario?> obtenerUsuarioActual() async {
    return _usuarioActual;
  }

  @override
  Future<void> logout() async {
    _usuarioActual = null;
  }
}
