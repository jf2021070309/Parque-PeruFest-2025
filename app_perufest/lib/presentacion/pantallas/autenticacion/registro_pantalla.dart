import 'package:flutter/material.dart';
import '../../../core/utilidades/validador.dart';
import '../../viewmodels/autenticacion_viewmodel.dart';
import '../dashboard/dashboard_pantalla.dart';
import 'package:provider/provider.dart';

class RegistroPantalla extends StatefulWidget {
  const RegistroPantalla({super.key});

  @override
  State<RegistroPantalla> createState() => _RegistroPantallaState();
}

class _RegistroPantallaState extends State<RegistroPantalla> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String correo = '';
  String telefono = '';
  String contrasena = '';
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 48),
                const SizedBox(height: 100), // Espacio donde estaba el logo
                const SizedBox(height: 8),
                const Text(
                  'Registrate',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 180, // Mismo tamaño que en login
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 40), // Mismo padding que en login
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 120,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (v) =>
                          v == null || v.isEmpty ? 'Ingrese su usuario' : null,
                  onSaved: (v) => username = v ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: Validador.validarCorreo,
                  onSaved: (v) => correo = v ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Celular',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator:
                      (v) =>
                          v == null || v.isEmpty ? 'Ingrese su celular' : null,
                  onSaved: (v) => telefono = v ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  obscureText: _obscure,
                  validator: Validador.validarContrasena,
                  onSaved: (v) => contrasena = v ?? '',
                ),
                const SizedBox(height: 16),
                Consumer<AutenticacionViewModel>(
                  builder: (context, viewModel, child) {
                    return Column(
                      children: [
                        if (viewModel.estado == EstadoAutenticacion.cargando)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        if (viewModel.estado == EstadoAutenticacion.error)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              viewModel.mensajeError ?? '',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B1B1B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed:
                                viewModel.estado == EstadoAutenticacion.cargando
                                    ? null
                                    : () async {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        _formKey.currentState?.save();

                                        // Mostrar feedback inmediato
                                        FocusScope.of(context).unfocus();

                                        await viewModel.registrar(
                                          '', // nombre completo no se pide en UI
                                          username,
                                          correo,
                                          telefono,
                                          'usuario',
                                          contrasena,
                                        );

                                        if (!mounted) return;

                                        if (viewModel.estado ==
                                            EstadoAutenticacion.autenticado) {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) =>
                                                      const DashboardPantalla(),
                                            ),
                                            (route) => false,
                                          );
                                        }
                                      }
                                    },
                            child:
                                viewModel.estado == EstadoAutenticacion.cargando
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text(
                                      'Registrate',
                                      style: TextStyle(fontSize: 16),
                                    ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Ya tienes cuenta?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Ingresa AQUI',
                        style: TextStyle(color: Color(0xFF1976D2)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
