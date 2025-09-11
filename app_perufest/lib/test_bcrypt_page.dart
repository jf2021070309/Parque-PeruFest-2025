import 'package:flutter/material.dart';
import '../core/utilidades/encriptacion_util.dart';
import '../core/servicios/autenticacion_service.dart';

class TestBcryptPage extends StatefulWidget {
  @override
  _TestBcryptPageState createState() => _TestBcryptPageState();
}

class _TestBcryptPageState extends State<TestBcryptPage> {
  final _autenticacionService = AutenticacionService();
  String _resultado = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Bcrypt')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _testHashContrasena,
              child: Text('Test Hash Contraseña'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testRegistroUsuario,
              child: Text('Test Registro Usuario'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testLoginUsuario,
              child: Text('Test Login Usuario'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _actualizarContrasenaExistente,
              child: Text('Actualizar Contraseña Existente'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _resultado,
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _testHashContrasena() {
    setState(() {
      _resultado = 'Testing bcrypt hash...\n';
    });

    try {
      final contrasena = '123456';
      final hash = EncriptacionUtil.hashContrasena(contrasena);

      setState(() {
        _resultado += 'Contraseña original: $contrasena\n';
        _resultado += 'Hash generado: $hash\n';
        _resultado += 'Longitud del hash: ${hash.length}\n\n';

        // Verificar que el hash funciona
        final esValida = EncriptacionUtil.verificarContrasena(contrasena, hash);
        _resultado +=
            'Verificación: ${esValida ? "✅ VÁLIDA" : "❌ INVÁLIDA"}\n\n';
      });
    } catch (e) {
      setState(() {
        _resultado += 'ERROR: $e\n\n';
      });
    }
  }

  void _testRegistroUsuario() async {
    setState(() {
      _resultado += 'Testing registro usuario...\n';
    });

    try {
      final exito = await _autenticacionService.registrarUsuario(
        nombre: 'Test Usuario',
        username: 'test_bcrypt_${DateTime.now().millisecondsSinceEpoch}',
        correo: 'test_bcrypt_${DateTime.now().millisecondsSinceEpoch}@test.com',
        telefono: '123456789',
        contrasena: '123456',
      );

      setState(() {
        _resultado += 'Registro: ${exito ? "✅ EXITOSO" : "❌ FALLIDO"}\n\n';
      });
    } catch (e) {
      setState(() {
        _resultado += 'ERROR en registro: $e\n\n';
      });
    }
  }

  void _testLoginUsuario() async {
    setState(() {
      _resultado += 'Testing login usuario...\n';
    });

    try {
      // Primero registrar un usuario de prueba
      final correoTest =
          'login_test_${DateTime.now().millisecondsSinceEpoch}@test.com';
      final registro = await _autenticacionService.registrarUsuario(
        nombre: 'Login Test',
        username: 'login_test_${DateTime.now().millisecondsSinceEpoch}',
        correo: correoTest,
        telefono: '123456789',
        contrasena: '123456',
      );

      if (registro) {
        // Ahora intentar hacer login
        final usuario = await _autenticacionService.iniciarSesion(
          correoTest,
          '123456',
        );

        setState(() {
          _resultado +=
              'Login: ${usuario != null ? "✅ EXITOSO" : "❌ FALLIDO"}\n';
          if (usuario != null) {
            _resultado += 'Usuario logueado: ${usuario['nombre']}\n\n';
          }
        });
      }
    } catch (e) {
      setState(() {
        _resultado += 'ERROR en login: $e\n\n';
      });
    }
  }

  void _actualizarContrasenaExistente() async {
    setState(() {
      _resultado += 'Actualizando contraseña de usuarios existentes...\n';
    });

    try {
      // Obtener usuarios con contraseñas en texto plano
      final usuarios =
          await _autenticacionService._supabase
              .from('usuarios')
              .select('id, correo, contrasena')
              .execute();

      for (final usuario in usuarios.data) {
        final contrasenaActual = usuario['contrasena'] as String;

        // Si la contraseña no parece un hash bcrypt (no empieza con $2)
        if (!contrasenaActual.startsWith('\$2')) {
          setState(() {
            _resultado += 'Actualizando: ${usuario['correo']}\n';
          });

          final hashNuevo = EncriptacionUtil.hashContrasena(contrasenaActual);

          await _autenticacionService._supabase
              .from('usuarios')
              .update({'contrasena': hashNuevo})
              .eq('id', usuario['id']);

          setState(() {
            _resultado += '✅ Hash actualizado para: ${usuario['correo']}\n';
          });
        }
      }

      setState(() {
        _resultado += '\n✅ Actualización completada\n\n';
      });
    } catch (e) {
      setState(() {
        _resultado += 'ERROR actualizando: $e\n\n';
      });
    }
  }
}
