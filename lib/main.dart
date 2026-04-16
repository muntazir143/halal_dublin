import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halal_dublin/app/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {}

  final supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  final supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');

  await Supabase.initialize(
    url: supabaseUrl.isNotEmpty ? supabaseUrl : dotenv.env['SUPABASE_URL']!,
    anonKey: supabaseAnonKey.isNotEmpty
        ? supabaseAnonKey
        : dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
