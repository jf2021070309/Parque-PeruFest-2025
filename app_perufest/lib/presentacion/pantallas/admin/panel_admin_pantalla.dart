import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/admin_eventos_viewmodel.dart';
import 'crear_evento_pantalla.dart';

class PanelAdminPantalla extends StatefulWidget {
  const PanelAdminPantalla({super.key});

  @override
  State<PanelAdminPantalla> createState() => _PanelAdminPantallaState();
}

class _PanelAdminPantallaState extends State<PanelAdminPantalla> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminEventosViewModel>().cargarEventos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AdminEventosViewModel>().cargarEventos();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Implementar logout
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Consumer<AdminEventosViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.cargandoEventos) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.errorEventos != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar eventos',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.errorEventos!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.limpiarErrorEventos();
                      viewModel.cargarEventos();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Estadísticas
                _buildEstadisticas(viewModel),
                const SizedBox(height: 24),
                
                // Acciones rápidas
                _buildAccionesRapidas(context),
                const SizedBox(height: 24),
                
                // Lista de eventos
                Expanded(
                  child: _buildListaEventos(context, viewModel),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CrearEventoPantalla(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Evento'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEstadisticas(AdminEventosViewModel viewModel) {
    final totalEventos = viewModel.eventos.length;
    final eventosProximos = viewModel.eventos
        .where((evento) => evento.fechaInicio.isAfter(DateTime.now()))
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: _buildEstadistica(
                'Total Eventos',
                totalEventos.toString(),
                Icons.event,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildEstadistica(
                'Próximos',
                eventosProximos.toString(),
                Icons.upcoming,
                Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadistica(String titulo, String valor, IconData icono, Color color) {
    return Column(
      children: [
        Icon(icono, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          titulo,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAccionesRapidas(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acciones Rápidas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CrearEventoPantalla(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Crear Evento'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<AdminEventosViewModel>().cargarEventos();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Actualizar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaEventos(BuildContext context, AdminEventosViewModel viewModel) {
    if (viewModel.eventos.isEmpty) {
      return Card(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay eventos registrados',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Crea tu primer evento para comenzar',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CrearEventoPantalla(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Primer Evento'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Eventos Registrados (${viewModel.eventos.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.eventos.length,
              itemBuilder: (context, index) {
                final evento = viewModel.eventos[index];
                return _buildEventoTile(context, evento, viewModel);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventoTile(BuildContext context, evento, AdminEventosViewModel viewModel) {
    final esEventoPasado = evento.fechaFin.isBefore(DateTime.now());
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: esEventoPasado ? Colors.grey : Colors.orange,
        child: Icon(
          Icons.event,
          color: Colors.white,
        ),
      ),
      title: Text(
        evento.nombre,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: esEventoPasado ? Colors.grey : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📅 ${_formatearFecha(evento.fechaInicio)} - ${_formatearFecha(evento.fechaFin)}'),
          Text('📍 ${evento.lugar}'),
        ],
      ),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'editar',
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('Editar'),
              dense: true,
            ),
          ),
          const PopupMenuItem(
            value: 'eliminar',
            child: ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Eliminar', style: TextStyle(color: Colors.red)),
              dense: true,
            ),
          ),
        ],
        onSelected: (value) {
          if (value == 'eliminar') {
            _confirmarEliminar(context, evento, viewModel);
          }
          // TODO: Implementar edición
        },
      ),
      onTap: () {
        // TODO: Mostrar detalles del evento
      },
    );
  }

  String _formatearFecha(DateTime fecha) {
    final meses = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    
    return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
  }

  void _confirmarEliminar(BuildContext context, evento, AdminEventosViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que quieres eliminar el evento "${evento.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final exito = await viewModel.eliminarEvento(evento.id);
              if (exito && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Evento eliminado exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
