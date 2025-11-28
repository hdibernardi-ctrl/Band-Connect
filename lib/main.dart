import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Importa los archivos necesarios
import 'Presentacion/Providers/role_provider.dart'; 
import 'Presentacion/screens/auth_wrapper.dart';

// **Importar los servicios de datos**
import 'data/auth_service.dart';
import 'data/profile_service.dart'; 

import 'firebase_options.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inicialización de Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
  log('Error al inicializar Firebase: $e');
  }

  // **INICIALIZACIÓN DE SERVICIOS (Corregido)**
  // 1. Inicializa ProfileService (no tiene dependencias)
  final profileService = ProfileService(); 
  // 2. Inicializa AuthService, pasándole la instancia de ProfileService
  final authService = AuthService(profileService); 

  // 2. Ejecución de la aplicación, envolviendo con ChangeNotifierProvider
  runApp(
    ChangeNotifierProvider(
      // **Pasamos las instancias de los servicios al Provider**
      create: (context) => RoleProvider(authService, profileService), 
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Band Connect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // 3. El AuthWrapper es el punto de entrada principal después del inicio.
      home: const AuthWrapper(),
    );
  }
}