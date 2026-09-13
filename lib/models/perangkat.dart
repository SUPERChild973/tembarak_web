class Perangkat {
  final String id;
  final String nama;
  final String jabatan;
  final String fotoUrl;
  final String keterangan;

  Perangkat({
    required this.id,
    required this.nama,
    required this.jabatan,
    required this.fotoUrl,
    required this.keterangan,
  });

  factory Perangkat.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return Perangkat(
      id: id,
      nama: data['nama'] ?? '',
      jabatan: data['jabatan'] ?? '',
      fotoUrl: data['fotoUrl'] ?? '',
      keterangan: data['keterangan'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'jabatan': jabatan,
      'fotoUrl': fotoUrl,
      'keterangan': keterangan,
    };
  }
}