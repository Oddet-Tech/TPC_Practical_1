// Student Numbers: 223021599
// Student Names  : Brandon Lombaard
// Question: Main Entry Point

import 'package:final_tpg_project_p1/viewmodel/routes/routes.dart';
import 'package:final_tpg_project_p1/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseUrl = 'https://fqybntwwqwjnkuldcolg.supabase.co';
const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxeWJudHd3cXdqbmt1bGRjb2xnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc2NDg2MzQsImV4cCI6MjA5MzIyNDYzNH0.1JdJgV9Gu4bmFG_UxUzpYPQuv7Rwhdkdx67SD-JqxSQ';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApplicationViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TPG Project',
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
