import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Presentacion/providers/role_provider.dart'; // Necesario para cerrar sesión

class MusicianHomeScreen extends StatelessWidget {
  const MusicianHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail = context.read<RoleProvider>().currentUser?.email ?? 'Usuario';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Músico / Banda'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.music_note, size: 80, color: Colors.teal),
            const SizedBox(height: 20),
            Text(
              '¡Bienvenido $userEmail!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Rol: Músico',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => context.read<RoleProvider>().signOut(),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar Sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}