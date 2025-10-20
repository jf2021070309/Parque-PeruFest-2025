import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/comentarios_viewmodel.dart';
import '../../models/comentario.dart';

class OpinionesTodasPage extends StatefulWidget {
  final String standId;
  const OpinionesTodasPage({super.key, required this.standId});

  @override
  State<OpinionesTodasPage> createState() => _OpinionesTodasPageState();
}

enum OpinionesFilter {
  todas,
  positivas,
  negativas,
  estrellas5,
  estrellas4,
  estrellas3,
  estrellas2,
  estrellas1,
}

class _OpinionesTodasPageState extends State<OpinionesTodasPage> {
  OpinionesFilter _filter = OpinionesFilter.todas;

  @override
  void initState() {
    super.initState();
    final vm = context.read<ComentariosViewModel>();
    vm.cargarComentariosPorStand(widget.standId);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ComentariosViewModel>();
    List<Comentario> lista =
        vm.comentarios
            .where((c) => c.publico && c.standId == widget.standId)
            .toList();

    switch (_filter) {
      case OpinionesFilter.todas:
        break;
      case OpinionesFilter.positivas:
        lista.sort((a, b) => b.utilSi.compareTo(a.utilSi));
        break;
      case OpinionesFilter.negativas:
        lista.sort((a, b) => b.utilNo.compareTo(a.utilNo));
        break;
      case OpinionesFilter.estrellas5:
        lista = lista.where((c) => c.estrellas == 5).toList();
        break;
      case OpinionesFilter.estrellas4:
        lista = lista.where((c) => c.estrellas == 4).toList();
        break;
      case OpinionesFilter.estrellas3:
        lista = lista.where((c) => c.estrellas == 3).toList();
        break;
      case OpinionesFilter.estrellas2:
        lista = lista.where((c) => c.estrellas == 2).toList();
        break;
      case OpinionesFilter.estrellas1:
        lista = lista.where((c) => c.estrellas == 1).toList();
        break;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Opiniones')),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('Todas', OpinionesFilter.todas),
                _filterChip('Positivas', OpinionesFilter.positivas),
                _filterChip('Negativas', OpinionesFilter.negativas),
                _filterChip('5★', OpinionesFilter.estrellas5),
                _filterChip('4★', OpinionesFilter.estrellas4),
                _filterChip('3★', OpinionesFilter.estrellas3),
                _filterChip('2★', OpinionesFilter.estrellas2),
                _filterChip('1★', OpinionesFilter.estrellas1),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child:
                vm.isLoading
                    ? const Center(child: Text('Cargando...'))
                    : lista.isEmpty
                    ? const Center(
                      child: Text('No hay opiniones para este filtro'),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: lista.length,
                      itemBuilder: (context, index) {
                        final c = lista[index];
                        final fecha = c.fecha.toLocal();
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      c.userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (i) => Icon(
                                          i < c.estrellas
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(c.texto),
                                const SizedBox(height: 8),
                                Text(
                                  DateFormat(
                                    'dd/MM/yyyy - hh:mm a',
                                    'es',
                                  ).format(fecha),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Fue útil para ${c.utilSi} personas • No útil para ${c.utilNo} personas',
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        final ok = await vm.marcarUtil(
                                          c.id,
                                          'si',
                                        );
                                        if (ok)
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Gracias por los comentarios',
                                              ),
                                            ),
                                          );
                                      },
                                      child: const Text('Si'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final ok = await vm.marcarUtil(
                                          c.id,
                                          'no',
                                        );
                                        if (ok)
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Gracias por los comentarios',
                                              ),
                                            ),
                                          );
                                      },
                                      child: const Text('No'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, OpinionesFilter f) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: ChoiceChip(
        selected: _filter == f,
        label: Text(label),
        onSelected: (_) => setState(() => _filter = f),
      ),
    );
  }
}
