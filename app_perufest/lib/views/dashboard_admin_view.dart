import 'package:flutter/material.dart';

class DashboardAdminView extends StatelessWidget {
  const DashboardAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Administrador')),
      body: const Center(child: Text('Bienvenido Administrador')),
    );
  }
}
