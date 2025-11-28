import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// Este servicio se encarga de las interacciones con la colección 'profiles' en Firestore.

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Colección única para almacenar el rol principal del usuario
  final String _collectionName = 'profiles'; 

  /// Obtiene el rol del usuario logueado actualmente.
  /// Retorna el rol como String ('musician', 'fan', 'venue') o null si no se encuentra.
  // Implementa el método fetchUserRole(), requerido por RoleProvider.
  Future<String?> fetchUserRole() async {
    final user = _auth.currentUser;
    if (user == null) {
      if (kDebugMode) {
        print('ProfileService: No hay usuario autenticado para buscar rol.');
      }
      return null;
    }

    try {
      if (kDebugMode) {
        print('ProfileService: Buscando perfil para UID: ${user.uid} en colección $_collectionName');
      }
      
      // Asume que el ID del documento es el UID del usuario.
      final docSnapshot = await _firestore.collection(_collectionName).doc(user.uid).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        // Asume que el campo del rol se llama 'role' y es un String
        final role = docSnapshot.data()!['role'] as String?;
        if (kDebugMode) {
          print('ProfileService: Rol encontrado: $role');
        }
        return role;
      } else {
        if (kDebugMode) {
          print('ProfileService: Documento de perfil no existe para UID: ${user.uid}');
        }
        return null; 
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener el rol del usuario ${user.uid}: $e');
      }
      // En caso de error de conexión o FireStore
      return null; 
    }
  }

  /// Método para crear el perfil inicial (usado por AuthService durante el registro).
  // Implementa el método createProfile, requerido por AuthService.
  Future<void> createProfile({required String uid, required String role, required String email}) async {
    try {
      // El UID de Auth se usa como ID del documento en la colección 'profiles'
      await _firestore.collection(_collectionName).doc(uid).set({
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (kDebugMode) {
        print('ProfileService: Perfil creado en $_collectionName para UID $uid con rol $role');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al crear el perfil de Firestore: $e');
      }
      throw 'No se pudo crear el perfil de datos en Firestore.';
    }
  }
}