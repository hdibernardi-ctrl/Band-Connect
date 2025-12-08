import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Presentacion/Providers/role_provider.dart'; // Necesario para cerrar sesión

class VenueHomeScreen extends StatelessWidget {
  const VenueHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail = context.read<RoleProvider>().currentUser?.email ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Local / Sala'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.storefront, size: 80, color: Colors.deepOrange),
            const SizedBox(height: 20),
            Text(
              '¡Bienvenido $userEmail!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Rol: Local/Sala',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => context.read<RoleProvider>().signOut(),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar Sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
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