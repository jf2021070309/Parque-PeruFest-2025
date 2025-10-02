import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/stands_viewmodel.dart';
import '../../models/evento.dart';
import '../../models/zona.dart';
import 'crear_stand_page.dart';

class StandsPage extends StatefulWidget {
  const StandsPage({super.key});

  @override
  State<StandsPage> createState() => _StandsPageState();
}

class _StandsPageState extends State<StandsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StandsViewModel>(
      builder: (context, standsViewModel, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gestión de Stands',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B1B1B),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Selector de evento
                _buildSelectorEvento(standsViewModel),
                const SizedBox(height: 16),
                
                // Selector de zona (solo si hay evento seleccionado)
                if (standsViewModel.eventoSeleccionado != null) ...[
                  _buildSelectorZona(standsViewModel),
                  const SizedBox(height: 16),
                ],
                
                // Botón agregar stand (solo si hay evento y zona seleccionados)
                if (standsViewModel.eventoSeleccionado != null && 
                    standsViewModel.zonaSeleccionada != null) ...[
                  _buildBotonAgregarStand(context),
                  const SizedBox(height: 16),
                ],
                
                // Lista de stands
                Expanded(
                  child: _buildListaStands(standsViewModel),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectorEvento(StandsViewModel standsViewModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seleccionar Evento',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Evento>(
              value: standsViewModel.eventoSeleccionado,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Seleccione un evento',
              ),
              items: standsViewModel.eventos.map((evento) {
                return DropdownMenuItem<Evento>(
                  value: evento,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        evento.nombre,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        evento.lugar,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (evento) {
                standsViewModel.setEventoSeleccionado(evento);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorZona(StandsViewModel standsViewModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seleccionar Zona',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Zona>(
              value: standsViewModel.zonaSeleccionada,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Seleccione una zona',
              ),
              items: ZonasParque.todasLasZonas.map((zona) {
                return DropdownMenuItem<Zona>(
                  value: zona,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        zona.nombre,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        zona.descripcion,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (zona) {
                standsViewModel.setZonaSeleccionada(zona);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonAgregarStand(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CrearStandPage(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar Nuevo Stand'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B1B1B),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildListaStands(StandsViewModel standsViewModel) {
    if (standsViewModel.eventoSeleccionado == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Seleccione un evento para ver los stands',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    final stands = standsViewModel.zonaSeleccionada != null
        ? standsViewModel.getStandsPorZona(
            standsViewModel.eventoSeleccionado!.id,
            standsViewModel.zonaSeleccionada!.numero,
          )
        : standsViewModel.getStandsPorEvento(
            standsViewModel.eventoSeleccionado!.id,
          );

    if (stands.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.store_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              standsViewModel.zonaSeleccionada != null
                  ? 'No hay stands en esta zona'
                  : 'No hay stands registrados para este evento',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: stands.length,
      itemBuilder: (context, index) {
        final stand = stands[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF8B1B1B),
              child: Text(
                stand.nombreEmpresa[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              stand.nombreEmpresa,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Zona: ${stand.zonaNombre}'),
                if (stand.productos.isNotEmpty)
                  Text(
                    'Productos: ${stand.productos.take(3).join(', ')}${stand.productos.length > 3 ? '...' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'editar',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'eliminar',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Eliminar', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'eliminar') {
                  _confirmarEliminarStand(context, stand.id, stand.nombreEmpresa);
                }
                // TODO: Implementar editar stand
              },
            ),
          ),
        );
      },
    );
  }

  void _confirmarEliminarStand(BuildContext context, String standId, String nombreEmpresa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Está seguro de que desea eliminar el stand "$nombreEmpresa"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<StandsViewModel>().eliminarStand(standId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}