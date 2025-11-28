class VenueProfile {
  // El ID del documento es el mismo que el UID de Firebase Auth
  final String uid; 
  final String venueName;
  final String contactEmail;
  final String address;
  final String description;
  final String contrasena;
  final String usuario;
  final int capacity; // Capacidad máxima del local
  final List<String> genresSupported; // Géneros musicales que el local acepta
  final String? profileImageUrl;

  // Constructor principal
  VenueProfile({
    required this.uid,
    required this.venueName,
    required this.contactEmail,
    required this.address,
    required this.description,
    required this.contrasena,
    required this.usuario,
    required this.capacity,
    required this.genresSupported,
    this.profileImageUrl,
  });

  // Constructor de fábrica para crear un modelo a partir de un mapa de Firestore
  factory VenueProfile.fromMap(Map<String, dynamic> data, String uid) {
    return VenueProfile(
      uid: uid,
      // Usamos el operador ?? para proporcionar valores por defecto si el dato es nulo
      venueName: data['venueName'] ?? 'Local Desconocido',
      contactEmail: data['contactEmail'] ?? '',
      address: data['address'] ?? 'Dirección no especificada.',
      description: data['description'] ?? 'Sin descripción.',
      contrasena: data['contrasena'] ?? 'Sin contrasena.',
      usuario: data['usuario'] ?? ' sin usuario',
      // Asegurarse de que 'capacity' sea un entero (usa 0 como default)
      capacity: (data['capacity'] as num?)?.toInt() ?? 0,
      // Asegurarse de que 'genresSupported' sea una lista de strings
      genresSupported: List<String>.from(data['genresSupported'] ?? []), 
      profileImageUrl: data['profileImageUrl'],
    );
  }
}