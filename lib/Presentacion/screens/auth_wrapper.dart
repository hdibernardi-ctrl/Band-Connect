import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// RUTA CORREGIDA: Usando la capitalización consistente
import 'package:band_connect/Presentacion/Providers/role_provider.dart'; 

// Importa las pantallas (asumiendo que están en este archivo por simplicidad,
// pero se recomienda moverlas a archivos separados)
// Puedes reemplazar estas clases con imports a tus archivos reales.

class MusicianHomeScreen extends StatelessWidget {
  const MusicianHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Musician Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Musician Home', style: TextStyle(fontSize: 30, color: Colors.blue)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Provider.of<RoleProvider>(context, listen: false).signOut(),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

class VenueHomeScreen extends StatelessWidget {
  const VenueHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venue Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Venue Home', style: TextStyle(fontSize: 30, color: Colors.green)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Provider.of<RoleProvider>(context, listen: false).signOut(),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

class FanHomeScreen extends StatelessWidget {
  const FanHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fan Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Fan Home', style: TextStyle(fontSize: 30, color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Provider.of<RoleProvider>(context, listen: false).signOut(),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Verificando autenticación y cargando perfil...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    
    // Controlador para simular login
    final emailController = TextEditingController(text: "musician@test.com");
    final passwordController = TextEditingController(text: "password");

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Inicia Sesión', 
                textAlign: TextAlign.center, 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email de Prueba (musician@test.com)'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña de Prueba (password)'),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              // Botón de ejemplo para simular un login de músico
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () async {
                  try {
                    // Llamamos al signIn que ahora existe en RoleProvider
                    await roleProvider.signIn(
                      emailController.text, 
                      passwordController.text
                    ); 
                  } catch (e) {
                    if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error de Login: ${e.toString()}')),
                        );
                    }
                  }
                },
                child: const Text('LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// Widget principal que decide la navegación basado en el estado de AuthStatus.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Escuchar el estado del RoleProvider
    // Usamos 'authState' porque así lo definimos en RoleProvider.
    final roleProvider = Provider.of<RoleProvider>(context);

    // 2. Determinar qué Widget mostrar basado en el estado (usando AuthStatus)
    switch (roleProvider.authState) { 
      
      case AuthStatus.loading: // Usamos AuthStatus.loading
        // Muestra un indicador de carga mientras Firebase y Firestore están verificando el estado.
        return const LoadingScreen(); 

      case AuthStatus.unauthenticated: // Usamos AuthStatus.unauthenticated
        // No hay usuario, muestra la pantalla de Login.
        return const LoginScreen();

      case AuthStatus.authenticated: // Usuario logueado, esperando rol (debería ser rápido)
        // Muestra carga mientras se espera que ProfileService devuelva el rol.
        return const LoadingScreen();
        
      case AuthStatus.roleDetermined: // Usamos AuthStatus.roleDetermined
        // Usuario logueado y rol conocido. Redirige a la pantalla adecuada.
        final role = roleProvider.userRole;
        
        log('Navigating to home for role: $role');
        
        if (role == 'musician') {
          return const MusicianHomeScreen();
        } else if (role == 'venue') {
          return const VenueHomeScreen();
        } else if (role == 'fan') {
          return const FanHomeScreen();
        }
        
        // Rol desconocido (caso de error)
        return const Scaffold(
          body: Center(child: Text('Error: Rol de usuario no reconocido')),
        );
    }
  }
}