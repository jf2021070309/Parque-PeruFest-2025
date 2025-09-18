import 'package:flutter/material.dart';

class ActividadesPage extends StatelessWidget {
  const ActividadesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_activity, size: 64),
          SizedBox(height: 16),
          Text(
            'Gestión de Actividades',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Aquí podrás crear y administrar actividades'),
        ],
      ),
    );
  }
}