import 'package:firebase_auth/firebase_auth.dart';
import 'profile_service.dart'; // Asegúrate de que la ruta sea correcta

// ignore_for_file: avoid_print

class AuthService {
  // Instancias privadas de Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // ProfileService inyectado para manejar las interacciones de perfil
  final ProfileService _profileService; 

  // Constructor que recibe ProfileService
  AuthService(this._profileService);

  /// Stream que notifica el estado de autenticación del usuario (conectado/desconectado).
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  /// Inicia sesión con email y contraseña.
  /// Soluciona error: The method 'signIn' isn't defined for the type 'AuthService'.
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Inicio de sesión exitoso para: ${userCredential.user?.email}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String message = 'Ocurrió un error de autenticación.';
      if (e.code == 'user-not-found') {
        message = 'No se encontró un usuario registrado con ese correo.';
      } else if (e.code == 'wrong-password') {
        message = 'Contraseña incorrecta. Por favor, inténtalo de nuevo.';
      } else if (e.code == 'invalid-email') {
        message = 'El formato del correo electrónico es inválido.';
      }
      print('Error en signInWithEmailAndPassword: ${e.code} - ${e.message}');
      // Relanzamos el mensaje de error para que la interfaz de usuario lo muestre
      throw message; 
    } catch (e) {
      print('Error desconocido al iniciar sesión: $e');
      throw 'Ocurrió un error inesperado al intentar iniciar sesión.';
    }
  }

  /// Registra un nuevo usuario en Firebase Auth y crea su documento inicial en Firestore.
  Future<UserCredential?> registerWithEmailAndPassword(String email, String password, String role) async {
    try {
      // 1. Crear el usuario en Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      // 2. Crear el perfil inicial en Firestore usando ProfileService
      if (user != null) {
        await _profileService.createProfile(
          uid: user.uid,
          role: role,
          email: user.email ?? email, // Usar el email de auth o el provisto
        );
      }

      print('Registro exitoso de usuario: ${user?.email} con rol: $role');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String message = 'Ocurrió un error de registro.';
      if (e.code == 'weak-password') {
        message = 'La contraseña es demasiado débil (mínimo 6 caracteres).';
      } else if (e.code == 'email-already-in-use') {
        message = 'Ya existe una cuenta con ese correo electrónico.';
      }
      print('Error en registerWithEmailAndPassword: ${e.code} - ${e.message}');
      throw message;
    } catch (e) {
      print('Error desconocido al registrar: $e');
      // Si el perfil de Firestore falló, forzamos el borrado del usuario de Auth (opcional)
      _auth.currentUser?.delete(); 
      throw 'Ocurrió un error inesperado al intentar registrar el usuario o crear el perfil.';
    }
  }

  /// Cierra la sesión del usuario actual.
  Future<void> signOut() async {
    try {
      print('Cerrando sesión...');
      await _auth.signOut();
    } catch (e) {
      print('Error al cerrar sesión: $e');
      // No relanzamos errores de cierre de sesión, ya que generalmente no bloquean la app.
    }
  }
}