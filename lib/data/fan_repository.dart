import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: avoid_print

class FanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // La colección que maneja este repositorio, consistente con AuthService
  final String collectionName = 'usuarios'; 

  // **********************************************************
  // NOTA IMPORTANTE: Por ahora, esta clase no usa modelos de dominio
  // (como un FanProfile), pero es donde irían los métodos
  // para obtener y guardar datos específicos del Fan.
  // **********************************************************


  /// Obtiene un Stream (flujo de datos en tiempo real) del documento de perfil del Fan logueado.
  /// Esto es útil para escuchar cambios en el perfil del usuario.
  Stream<DocumentSnapshot?> getFanProfileStream() {
    final user = _auth.currentUser;
    if (user == null) {
      // Si no hay usuario, devuelve un Stream que no emite datos o uno vacío.
      return const Stream.empty(); 
    }

    try {
      // Retorna el Stream del documento.
      return _firestore.collection(collectionName).doc(user.uid).snapshots();
    } catch (e) {
      print('Error al obtener Stream del perfil del Fan: $e');
      return const Stream.empty();
    }
  }

  /// Ejemplo de método futuro: Registrar un artista como "Favorito"
  Future<void> addFavoriteMusician(String musicianUid) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Usamos FieldValue.arrayUnion para agregar el ID del músico al array 'favorites'
      await _firestore.collection(collectionName).doc(user.uid).update({
        'favorites': FieldValue.arrayUnion([musicianUid]),
      });
      print('Músico $musicianUid añadido a favoritos del usuario ${user.uid}');
    } catch (e) {
      print('Error al añadir favorito: $e');
      // En un entorno de producción, manejaríamos mejor este error.
    }
  }

  // Aquí se añadirían más métodos para un Fan: getFavoriteGigs, followVenue, etc.
}