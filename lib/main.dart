import 'package:flutter/material.dart';
import 'screens/role_selection_screen.dart';

void main() {
  // 1. Aquí llamamos a la aplicación principal, NO a la pantalla directamente
  runApp(const BarbeoApp());
}

class BarbeoApp extends StatelessWidget {
  const BarbeoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Aquí está el MaterialApp que Flutter te está pidiendo a gritos
    return MaterialApp(
      title: 'Barbeo',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.black,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      // 3. Y aquí es donde le decimos qué pantalla cargar primero
      home: const RoleSelectionScreen(),
    );
  }
}