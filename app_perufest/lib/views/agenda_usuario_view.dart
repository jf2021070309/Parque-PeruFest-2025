import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/agenda_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/actividad.dart';
import '../services/actividades_service.dart';

class AgendaUsuarioView extends StatelessWidget {
  const AgendaUsuarioView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final userId = authViewModel.currentUser?.id ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B1B1B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Mi Agenda',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (_) => AgendaViewModel()..cargarAgendaUsuario(userId),
          child: Consumer<AgendaViewModel>(
            builder: (context, agendaVM, _) {
              if (agendaVM.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF8B1B1B)),
                );
              }
              if (agendaVM.actividadesAgendadas.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_note, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No tienes actividades agendadas.',
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                itemCount: agendaVM.actividadesAgendadas.length,
                itemBuilder: (context, index) {
                  final agenda = agendaVM.actividadesAgendadas[index];
                  return FutureBuilder<Actividad?>(
                    future: ActividadesService().obtenerActividadPorId(agenda.actividadId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: LinearProgressIndicator(
                              color: Color(0xFF8B1B1B),
                              backgroundColor: Colors.grey.shade200,
                            ),
                          ),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            leading: Icon(Icons.error_outline, color: Colors.red.shade300),
                            title: const Text('Actividad no encontrada'),
                            subtitle: Text('ID: ${agenda.actividadId}'),
                          ),
                        );
                      }
                      final actividad = snapshot.data!;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFF8B1B1B), width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF8B1B1B),
                                radius: 28,
                                child: Icon(Icons.event, color: Colors.white, size: 28),
                              ),
                              title: Text(
                                actividad.nombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color(0xFF8B1B1B),
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 18, color: Color(0xFF8B1B1B)),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${_formatearHora(actividad.fechaInicio)} - ${_formatearHora(actividad.fechaFin)}',
                                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 18, color: Color(0xFF8B1B1B)),
                                        const SizedBox(width: 6),
                                        Text(
                                          actividad.zona,
                                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Agendado el ${agenda.fechaAgregado.day}/${agenda.fechaAgregado.month}/${agenda.fechaAgregado.year}',
                                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                                tooltip: 'Quitar de la agenda',
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      title: Row(
                                        children: const [
                                          Icon(Icons.warning_amber_rounded, color: Color(0xFF8B1B1B)),
                                          SizedBox(width: 8),
                                          Text(
                                            'Quitar de la agenda',
                                            style: TextStyle(color: Color(0xFF8B1B1B)),
                                          ),
                                        ],
                                      ),
                                      content: const Text(
                                        '¿Estás seguro de que quieres quitar esta actividad de tu agenda?',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      actionsAlignment: MainAxisAlignment.spaceBetween,
                                      actions: [
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: const Color(0xFF8B1B1B),
                                            side: const BorderSide(color: Color(0xFF8B1B1B)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () => Navigator.pop(ctx, false),
                                          child: const Text('Cancelar'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF8B1B1B),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () => Navigator.pop(ctx, true),
                                          child: const Text('Quitar'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    agendaVM.eliminarDeAgenda(agenda.actividadId);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  static String _formatearHora(DateTime fecha) {
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }
}