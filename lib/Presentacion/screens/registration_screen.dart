import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/auth_service.dart'; // Importa el servicio de autenticación

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Opciones de rol basadas en la lógica de Firestore
  final List<String> _roles = ['musician', 'venue', 'fan'];
  String? _selectedRole = 'musician'; // Rol por defecto

  bool _isLoading = false;
  String? _errorMessage;

  // Función auxiliar para mostrar el nombre del rol de forma amigable
  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'musician':
        return 'Músico / Banda';
      case 'venue':
        return 'Local / Sala de Eventos';
      case 'fan':
        return 'Fan de la música';
      default:
        return 'Seleccionar Rol';
    }
  }

  // Función que maneja el proceso de registro
  Future<void> _register() async {
    // Validar campos del formulario
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRole == null) {
      setState(() => _errorMessage = 'Debes seleccionar un rol.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = context.read<AuthService>();
      
      // 1. Ejecutar el registro real
      await authService.registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _selectedRole!, // El rol no es nulo gracias a la validación
      );
      
      // ❌ LÍNEA ELIMINADA: await someAsyncFunction(); // ESTO CAUSABA EL ERROR DE MÉTODO NO DEFINIDO
      
      // 🔑 CORRECCIÓN ASINCRONÍA: Verificar el estado del widget antes de usar el context
      if (!mounted) return; 

      // 2. Si el registro es exitoso, volver a la pantalla anterior (Login)
      Navigator.of(context).pop();

    } catch (e) {
      setState(() {
        // Manejo de errores para mostrar mensajes más limpios al usuario
        // Busca el mensaje después del corchete ']' si existe.
        _errorMessage = e.toString().contains(']') ? e.toString().split(']').last.trim() : e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Crea tu Cuenta',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Selector de Rol
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Soy...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.group),
                  ),
                  initialValue: _selectedRole, // ✅ Advertencia 'value' corregida (es 'initialValue')
                  items: _roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(_getRoleDisplayName(role)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue;
                      _errorMessage = null; // Limpiar error al cambiar de rol
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecciona tu rol.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Campo de Correo
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Introduce un correo válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de Contraseña
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña (mínimo 6 caracteres)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres.';
                    }
                    return null;
                  },
                ),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Error: $_errorMessage',
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 30),

                // Botón de Registro
                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
                    : ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'REGISTRARSE',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                const SizedBox(height: 20),
                
                // Botón para volver al Login
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('¿Ya tienes cuenta? Inicia Sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}