class Perangkat {
  final String id;
  final String nama;
  final String jabatan;
  final String fotoUrl;
  final String keterangan;
  final int urutan;

  Perangkat({
    required this.id,
    required this.nama,
    required this.jabatan,
    required this.fotoUrl,
    required this.keterangan,
    required this.urutan,
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
      urutan: data['urutan'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'jabatan': jabatan,
      'fotoUrl': fotoUrl,
      'keterangan': keterangan,
      'urutan': urutan,
    };
  }
}