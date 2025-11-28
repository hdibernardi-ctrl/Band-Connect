class FanProfile {
  // El ID del documento es el mismo que el UID de Firebase Auth
  final String uid; 
  final String displayName;
  final String contactEmail;
  final String bio;
  
  // Listas de UIDs para seguir bandas y locales
  final List<String> favoriteMusicians; 
  final List<String> favoriteVenues; 
  final String? profileImageUrl;

  // Constructor principal
  FanProfile({
    required this.uid,
    required this.displayName,
    required this.contactEmail,
    required this.bio,
    required this.favoriteMusicians,
    required this.favoriteVenues,
    this.profileImageUrl,
  });

  /// Constructor de fábrica para crear un modelo a partir de un mapa de Firestore
  factory FanProfile.fromMap(Map<String, dynamic> data, String uid) {
    return FanProfile(
      uid: uid,
      // Usamos el operador ?? para proporcionar valores por defecto
      displayName: data['displayName'] ?? 'Usuario Fan',
      contactEmail: data['contactEmail'] ?? '',
      bio: data['bio'] ?? 'Fan de la buena música.',
      
      // Asegurarse de que las listas sean listas de strings
      favoriteMusicians: List<String>.from(data['favoriteMusicians'] ?? []), 
      favoriteVenues: List<String>.from(data['favoriteVenues'] ?? []), 
      profileImageUrl: data['profileImageUrl'],
    );
  }

  /// Convierte el modelo a un mapa para guardarlo o actualizarlo en Firestore
  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'contactEmail': contactEmail,
      'bio': bio,
      'favoriteMusicians': favoriteMusicians,
      'favoriteVenues': favoriteVenues,
      'profileImageUrl': profileImageUrl,
    };
  }
}