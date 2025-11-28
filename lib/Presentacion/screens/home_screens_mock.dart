import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// RUTA CORREGIDA: Usando 'Presentacion' (con P mayúscula)
import 'package:band_connect/Presentacion/Providers/role_provider.dart'; 

// Plantilla base para las pantallas de Home (Contiene la función _buildDetailRow)
class RoleBaseScreen extends StatelessWidget {
  final String role;
  const RoleBaseScreen({required this.role, super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos context.read para evitar redibujar todo el widget si solo cambia el estado. 
    final provider = context.read<RoleProvider>(); 
    // Obtenemos los datos del usuario logueado
    final userEmail = provider.currentUser?.email ?? 'N/A';
    final userId = provider.currentUser?.uid ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text('Home de ${role[0].toUpperCase() + role.substring(1)}'),
        // Colores distintivos según el rol
        backgroundColor: (role == 'musician') 
            ? Colors.blue.shade800 
            : (role == 'venue') 
                ? Colors.green.shade800 
                : Colors.red.shade800,
        foregroundColor: Colors.white, // Color del icono y texto
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => provider.signOut(), // Llamada al cierre de sesión
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¡Bienvenido a tu Home de $role!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Detalles de Sesión:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(height: 16, thickness: 1),
                      _buildDetailRow(
                          'Email:', userEmail, Icons.email, Colors.indigo),
                      _buildDetailRow(
                          'UID:', userId, Icons.fingerprint, Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'Rol Asignado: ${provider.userRole?.toUpperCase()}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: (role == 'musician') ? Colors.blue.shade800 : (role == 'venue') ? Colors.green.shade800 : Colors.red.shade800),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Esta es tu base. Aquí verás el contenido y las herramientas específicas para tu rol (músico, local o fan).',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MÉTODO CORREGIDO: Se eliminó el 'const' duplicado en TextStyle.
  Widget _buildDetailRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              // *** CORRECCIÓN APLICADA AQUÍ: const const -> const ***
              style: const TextStyle(color: Colors.black87), 
            ),
          ),
        ],
      ),
    );
  }
}

// Pantallas específicas que usan la plantilla base
class MusicianHomeScreen extends StatelessWidget {
  const MusicianHomeScreen({super.key});
  @override
  Widget build(BuildContext context) => const RoleBaseScreen(role: 'musician');
}

class VenueHomeScreen extends StatelessWidget {
  const VenueHomeScreen({super.key});
  @override
  Widget build(BuildContext context) => const RoleBaseScreen(role: 'venue');
}

class FanHomeScreen extends StatelessWidget {
  const FanHomeScreen({super.key});
  @override
  Widget build(BuildContext context) => const RoleBaseScreen(role: 'fan');
}