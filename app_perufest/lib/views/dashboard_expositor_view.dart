import 'package:flutter/material.dart';

class DashboardExpositorView extends StatelessWidget {
  const DashboardExpositorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Expositor')),
      body: const Center(child: Text('Bienvenido Expositor')),
    );
  }
}
