import 'package:flutter/material.dart';
import '../../dominio/modelos/usuario.dart';
import '../pantallas/admin/panel_admin_pantalla.dart';
import '../pantallas/dashboard/dashboard_pantalla.dart';

class VerificadorRol extends StatelessWidget {
  final Usuario usuario;

  const VerificadorRol({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    // Verificar si es administrador
    if (usuario.rol.toLowerCase() == 'administrador' || 
        usuario.rol.toLowerCase() == 'admin') {
      return const PanelAdminPantalla();
    }
    
    // Usuario normal va al dashboard regular
    return const DashboardPantalla();
  }
}
