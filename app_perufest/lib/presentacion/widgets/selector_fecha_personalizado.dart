import 'package:flutter/material.dart';

class SelectorFechaPersonalizado extends StatelessWidget {
  final String labelText;
  final DateTime? fechaSeleccionada;
  final Function(DateTime?) onFechaSeleccionada;
  final String? Function(DateTime?)? validator;
  final DateTime? fechaMinima;
  final DateTime? fechaMaxima;

  const SelectorFechaPersonalizado({
    super.key,
    required this.labelText,
    required this.fechaSeleccionada,
    required this.onFechaSeleccionada,
    this.validator,
    this.fechaMinima,
    this.fechaMaxima,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: fechaSeleccionada,
      validator: validator,
      builder: (FormFieldState<DateTime> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _seleccionarFecha(context, field),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: labelText,
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.orange, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  errorText: field.errorText,
                ),
                child: Text(
                  fechaSeleccionada != null
                      ? _formatearFecha(fechaSeleccionada!)
                      : 'Seleccionar fecha',
                  style: TextStyle(
                    color: fechaSeleccionada != null ? Colors.black : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _seleccionarFecha(BuildContext context, FormFieldState<DateTime> field) async {
    // Determinar la fecha inicial para el picker
    DateTime fechaInicial;
    
    if (fechaSeleccionada != null) {
      fechaInicial = fechaSeleccionada!;
    } else if (fechaMinima != null && fechaMinima!.isAfter(DateTime.now())) {
      fechaInicial = fechaMinima!;
    } else {
      fechaInicial = DateTime.now();
    }

    // Asegurar que la fecha inicial esté dentro del rango permitido
    final fechaMin = fechaMinima ?? DateTime.now().subtract(const Duration(days: 365));
    final fechaMax = fechaMaxima ?? DateTime.now().add(const Duration(days: 365 * 2));
    
    if (fechaInicial.isBefore(fechaMin)) {
      fechaInicial = fechaMin;
    } else if (fechaInicial.isAfter(fechaMax)) {
      fechaInicial = fechaMax;
    }

    final fecha = await showDatePicker(
      context: context,
      initialDate: fechaInicial,
      firstDate: fechaMin,
      lastDate: fechaMax,
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (fecha != null) {
      onFechaSeleccionada(fecha);
      field.didChange(fecha);
    }
  }

  String _formatearFecha(DateTime fecha) {
    final diasSemana = [
      'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'
    ];
    
    final meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];

    final diaSemana = diasSemana[fecha.weekday - 1];
    final mes = meses[fecha.month - 1];
    
    return '$diaSemana, ${fecha.day} de $mes ${fecha.year}';
  }
}
