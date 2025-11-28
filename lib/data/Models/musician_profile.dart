class MusicianProfile {
  // El ID del documento es el mismo que el UID de Firebase Auth
  final String uid; 
  final String bandName;
  final String contactEmail;
  final String genre;
  final String bio;
  final String contrasena;
  final List<String> instruments;
  final String? profileImageUrl;

  // Constructor principal
  MusicianProfile({
    required this.uid,
    required this.bandName,
    required this.contactEmail,
    required this.genre,
    required this.bio,
    required this.contrasena,
    required this.instruments,
    this.profileImageUrl,
  });

  /// Constructor de fábrica para crear un modelo a partir de un mapa de Firestore
  factory MusicianProfile.fromMap(Map<String, dynamic> data, String uid) {
    return MusicianProfile(
      uid: uid,
      // Usamos el operador ?? para proporcionar valores por defecto si el dato es nulo
      bandName: data['bandName'] ?? 'Banda Desconocida',
      contactEmail: data['contactEmail'] ?? '',
      genre: data['genre'] ?? 'Rock',
      bio: data['bio'] ?? 'Sin biografía.',
      contrasena: data['contrasena'] ?? 'Sin Contrasena.',
      // Asegurarse de que 'instruments' sea una lista de strings
      instruments: List<String>.from(data['instruments'] ?? []), 
      profileImageUrl: data['profileImageUrl'],
    );
  }

  /// Convierte el modelo a un mapa para guardarlo en Firestore
  Map<String, dynamic> toMap() {
    return {
      'bandName': bandName,
      'contactEmail': contactEmail,
      'genre': genre,
      'bio': bio,
      'Contrasena': contrasena,
      'instruments': instruments,
      'profileImageUrl': profileImageUrl,
    };
  }
}