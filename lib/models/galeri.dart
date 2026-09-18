import 'package:cloud_firestore/cloud_firestore.dart';

class Galeri {
  final String id;
  final String judul;
  final String deskripsi;
  final String fotoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Galeri({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.fotoUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Galeri.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return Galeri(
      id: id,
      judul: data['judul'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      fotoUrl: data['fotoUrl'] ?? '',
      createdAt: _parseDate(data['createdAt']),
      updatedAt: _parseDate(data['updatedAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'deskripsi': deskripsi,
      'fotoUrl': fotoUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}