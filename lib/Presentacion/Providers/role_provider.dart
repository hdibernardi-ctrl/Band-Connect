import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Asegúrate de que las rutas relativas sean correctas
import '../../data/auth_service.dart';
import '../../data/profile_service.dart'; 
// ignore_for_file: avoid_print

/// Define el estado que tendrá el RoleProvider.
enum AuthStatus {
loading, // Estado inicial, cargando autenticación
unauthenticated, // No hay usuario logueado
authenticated, // Usuario logueado, pero el rol aún no se determina
roleDetermined, // Usuario logueado y el rol ya fue encontrado
}

// Clase que maneja el estado de autenticación y el rol del usuario.
class RoleProvider extends ChangeNotifier {
final AuthService _authService;
final ProfileService _profileService; 

// CAMBIO 1: Renombrar el estado interno a _authState y el getter
AuthStatus _authState = AuthStatus.loading;
String? _userRole; // El rol determinado: 'musician', 'venue', o 'fan'
User? _currentUser; // Usuario de Firebase Auth

// CAMBIO 2: Renombrar el getter a authState (resuelve el error en AuthWrapper)
AuthStatus get authState => _authState;
String? get userRole => _userRole;
User? get currentUser => _currentUser;
bool get isAuthenticated => _authState == AuthStatus.authenticated || _authState == AuthStatus.roleDetermined;

// Constructor: Recibe los servicios (corregido en main.dart)
RoleProvider(this._authService, this._profileService) {
// Escuchar los cambios de autenticación de Firebase
_authService.user.listen((User? user) {
_currentUser = user;
_onAuthStateChanged(user);
});
}

/// Maneja los cambios de estado de autenticación (logueado, deslogueado).
Future<void> _onAuthStateChanged(User? user) async {
    // ... (código que maneja user == null)

    if (user != null) {
        // Usuario logueado, pero el rol aún no se determina
        _authState = AuthStatus.authenticated;
        print('AUTH: User signed in: ${user.uid}');
        
        // CORRECCIÓN 1: Llama a fetchUserRole() sin pasar el UID
        try {
            _userRole = await _profileService.fetchUserRole(); // 🔑 ¡CORREGIDO!
            _authState = AuthStatus.roleDetermined;
            print('AUTH: User role determined: $_userRole');
        } catch (e) {
            print('AUTH ERROR: Could not fetch user role for ${user.uid}: $e');
        }
    }
    // ... (código notifyListeners())
}
  
 // CAMBIO 3: Agregar método signIn (para LoginScreen)
Future<void> signIn(String email, String password) async {
    _authState = AuthStatus.loading;
    notifyListeners();
    try {
        // CORRECCIÓN 2: Llama al método con el nombre correcto
        await _authService.signInWithEmailAndPassword(email, password); // 🔑 ¡CORREGIDO!
        // _onAuthStateChanged se encargará del resto
    } catch (e) {
        _authState = AuthStatus.unauthenticated;
        notifyListeners();
        rethrow;
    }
}

// CAMBIO 4: Método signOut (para Logout)
Future<void> signOut() async {
_authState = AuthStatus.loading; 
notifyListeners();

try {
await _authService.signOut();
// _onAuthStateChanged se encargará de establecer AuthStatus.unauthenticated
print('LOGOUT: Sign out initiated successfully.');
} catch (e) {
print('LOGOUT ERROR: Failed to sign out: $e');
notifyListeners();
}
}
}