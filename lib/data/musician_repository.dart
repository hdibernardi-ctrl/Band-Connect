import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: avoid_print

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Colecciones donde buscamos el perfil, deben coincidir con las usadas en AuthService
  final List<String> roleCollections = ['bandas', 'locales', 'usuarios'];

  /// Busca el UID del usuario logueado en las tres colecciones de perfiles
  /// para determinar su rol registrado.
  /// 
  /// Retorna el rol ('musician', 'venue', 'fan') como String, o null si
  /// el perfil no se encuentra en ninguna colección.
  Future<String?> fetchUserRole() async {
    final user = _auth.currentUser;

    if (user == null) {
      print('Usuario no logueado. No se puede determinar el rol.');
      return null;
    }

    final String uid = user.uid;

    // Iteramos sobre las posibles colecciones de roles
    for (String collectionName in roleCollections) {
      try {
        // Intentamos obtener el documento usando el UID como ID del documento
        final docSnapshot = await _firestore.collection(collectionName).doc(uid).get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          
          // Verificamos que el documento exista y contenga el campo 'role'
          if (data != null && data.containsKey('role')) {
            final role = data['role'] as String;
            print('Rol encontrado para UID $uid en colección "$collectionName": $role');
            return role; // Rol encontrado, terminamos la búsqueda
          }
        }
      } catch (e) {
        // En caso de error de conexión o permiso, registramos el error y continuamos
        print('Error al buscar rol en $collectionName para UID $uid: $e');
        // Continuamos buscando en las otras colecciones
      }
    }

    // Si el bucle termina sin encontrar un rol válido
    print('Perfil no encontrado para el UID $uid en ninguna de las colecciones.');
    return null; 
  }

  // Aquí se podrían agregar métodos futuros como: 
  // Future<void> updateRoleProfile(String role, Map<String, dynamic> data)
}