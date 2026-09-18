import 'package:cloud_firestore/cloud_firestore.dart';

class Berita {
  final String id;
  final String judul;
  final String kategori;
  final String fotoUrl;
  final String ringkasan;
  final String isi;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Berita({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.fotoUrl,
    required this.ringkasan,
    required this.isi,
    this.createdAt,
    this.updatedAt,
  });

  factory Berita.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return Berita(
      id: id,
      judul: data['judul'] ?? '',
      kategori: data['kategori'] ?? '',
      fotoUrl: data['fotoUrl'] ?? '',
      ringkasan: data['ringkasan'] ?? '',
      isi: data['isi'] ?? '',
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
      'kategori': kategori,
      'fotoUrl': fotoUrl,
      'ringkasan': ringkasan,
      'isi': isi,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}