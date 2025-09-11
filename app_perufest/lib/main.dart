import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase de forma no bloqueante
  unawaited(_initializeSupabase());

  runApp(const MyApp());
}

Future<void> _initializeSupabase() async {
  try {
    await Supabase.initialize(
      url: 'https://miiavhizwsbjhqmwfsac.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1paWF2aGl6d3NiamhxbXdmc2FjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc1NzQ4ODgsImV4cCI6MjA3MzE1MDg4OH0.qpvupYcgB37twSDvlExCKXklf-X1lm2rfx6UJhWx-b8',
      debug: false,
    );
    if (kDebugMode) {
      debugPrint('Supabase inicializado correctamente');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Error al inicializar Supabase: $e');
    }
  }
}

// Función helper para no esperar futures
void unawaited(Future<void> future) {
  // Simplemente dispara el future sin esperar
}
