import 'package:flutter/material.dart';

class DashboardUserView extends StatelessWidget {
  const DashboardUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Usuario')),
      body: const Center(child: Text('Bienvenido Usuario')),
    );
  }
}
