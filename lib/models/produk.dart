class Produk {
  final String id;
  final String nama;
  final String pemilik;
  final String alamat;
  final String telepon;
  final String fotoUrl;
  final String deskripsi;
  final int urutan;

  Produk({
    required this.id,
    required this.nama,
    required this.pemilik,
    required this.alamat,
    required this.telepon,
    required this.fotoUrl,
    required this.deskripsi,
    required this.urutan,
  });

  factory Produk.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return Produk(
      id: id,
      nama: data['nama'] ?? '',
      pemilik: data['pemilik'] ?? '',
      alamat: data['alamat'] ?? '',
      telepon: data['telepon'] ?? '',
      fotoUrl: data['fotoUrl'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      urutan: data['urutan'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'pemilik': pemilik,
      'alamat': alamat,
      'telepon': telepon,
      'fotoUrl': fotoUrl,
      'deskripsi': deskripsi,
      'urutan': urutan,
    };
  }
}