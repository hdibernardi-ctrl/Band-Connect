import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:appconciertos/domain/models/venue_profile.dart'; // Se importará cuando creemos el modelo
// ignore_for_file: avoid_print

class VenueRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // La colección que maneja este repositorio (debe coincidir con AuthService)
  final String collectionName = 'locales'; 

  // **********************************************************
  // NOTA: Por ahora, usaremos DocumentSnapshot. Cuando definas el 
  // modelo VenueProfile (similar a MusicianProfile), reemplazarás
  // DocumentSnapshot por VenueProfile en los tipos de retorno.
  // **********************************************************


  /// Obtiene un Stream (flujo de datos en tiempo real) del documento de perfil del Local logueado.
  Stream<DocumentSnapshot?> getVenueProfileStream() {
    final user = _auth.currentUser;
    if (user == null) {
      // Si no hay usuario, devolvemos un Stream vacío.
      return const Stream.empty(); 
    }

    try {
      // Retorna el Stream del documento.
      return _firestore.collection(collectionName).doc(user.uid).snapshots();
      
      // *** FUTURO CÓDIGO CON MODELO VENUEPROFILE ***
      // return _firestore.collection(collectionName).doc(user.uid).snapshots().map((snapshot) {
      //   if (snapshot.exists && snapshot.data() != null) {
      //     return VenueProfile.fromMap(snapshot.data()!, user.uid);
      //   }
      //   return null; 
      // });
      
    } catch (e) {
      print('Error al obtener Stream del perfil del Local: $e');
      return const Stream.empty();
    }
  }

  /// Actualiza los datos del perfil del Local en Firestore.
  /// Los datos se reciben como un mapa para permitir actualizaciones parciales.
  Future<void> updateVenueProfile(Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado.');
    }

    try {
      await _firestore.collection(collectionName).doc(user.uid).update(data);
      print('Perfil del local ${user.uid} actualizado con éxito.');
    } catch (e) {
      print('Error al actualizar el perfil del Local: $e');
      throw Exception('No se pudo actualizar el perfil. Por favor, inténtalo de nuevo.');
    }
  }

  // Aquí se añadirían más métodos específicos del Local, como:
  // Future<void> listMusicians(List<Musician> musicians);
  // Future<List<Gig>> getUpcomingEvents();
}