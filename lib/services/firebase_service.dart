import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/// Obtener todas las bandas
Future<List> getBandas() async {
  List bandas = [];
  CollectionReference collectionReferenceBandas = db.collection('bandas');
  QuerySnapshot queryBandas = await collectionReferenceBandas.get();

  for (var doc in queryBandas.docs) {
    bandas.add(doc.data());
  }
  return bandas;
}

/// Obtener todos los locales
Future<List> getLocales() async {
  List locales = [];
  CollectionReference collectionReferenceLocales = db.collection('locales');
  QuerySnapshot queryLocales = await collectionReferenceLocales.get();

  for (var doc in queryLocales.docs) {
    locales.add(doc.data());
  }
  return locales;
}

/// Obtener todos los usuarios
Future<List> getUsuarios() async {
  List usuarios = [];
  CollectionReference collectionReferenceUsuarios = db.collection('usuarios');
  QuerySnapshot queryUsuarios = await collectionReferenceUsuarios.get();

  for (var doc in queryUsuarios.docs) {
    usuarios.add(doc.data());
  }
  return usuarios;
}
