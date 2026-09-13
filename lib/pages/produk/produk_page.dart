import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class ProdukPage extends StatelessWidget {
  const ProdukPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _headerSection(),
          _productsSection(),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _headerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 60,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D3B13),
            AppTheme.primary,
            AppTheme.primaryLight,
          ],
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.storefront,
            color: Colors.white,
            size: 60,
          ),
          SizedBox(height: 20),
          Text(
            'Produk Unggulan Desa',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Potensi dan produk lokal masyarakat Desa Tembarak',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCTS
  // ============================================================

  Widget _productsSection() {
    final products = [
      {
        'name': 'Keripik Singkong',
        'owner': 'Nama Pemilik',
        'address': 'Alamat Pemilik',
        'phone': 'Nomor HP',
        'description':
            'Keripik singkong merupakan salah satu contoh produk olahan lokal yang dapat dikembangkan sebagai produk unggulan desa.',
        'icon': Icons.local_dining,
      },
      {
        'name': 'Kopi Desa',
        'owner': 'Nama Pemilik',
        'address': 'Alamat Pemilik',
        'phone': 'Nomor HP',
        'description':
            'Produk kopi lokal dengan potensi untuk dikembangkan dan dipasarkan sebagai produk khas Desa Tembarak.',
        'icon': Icons.coffee,
      },
      {
        'name': 'Madu Desa',
        'owner': 'Nama Pemilik',
        'address': 'Alamat Pemilik',
        'phone': 'Nomor HP',
        'description':
            'Madu hasil budidaya masyarakat yang dapat menjadi salah satu potensi ekonomi masyarakat desa.',
        'icon': Icons.hive,
      },
      {
        'name': 'Kerajinan Bambu',
        'owner': 'Nama Pemilik',
        'address': 'Alamat Pemilik',
        'phone': 'Nomor HP',
        'description':
            'Kerajinan berbahan bambu yang dibuat oleh masyarakat dan memiliki nilai ekonomi serta nilai budaya.',
        'icon': Icons.handyman,
      },
      {
        'name': 'Olahan Pisang',
        'owner': 'Nama Pemilik',
        'address': 'Alamat Pemilik',
        'phone': 'Nomor HP',
        'description':
            'Berbagai olahan pisang hasil kreativitas masyarakat yang dapat dikembangkan menjadi produk UMKM.',
        'icon': Icons.restaurant,
      },
      {
        'name': 'Batik Desa',
        'owner': 'Nama Pemilik',
        'address': 'Alamat Pemilik',
        'phone': 'Nomor HP',
        'description':
            'Produk kerajinan batik yang dapat menjadi identitas serta produk kreatif masyarakat Desa Tembarak.',
        'icon': Icons.brush,
      },
    ];

    return Container(
      width: double.infinity,
      color: AppTheme.background,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 60,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1150,
          ),
          child: Column(
            children: [
              const Text(
                'Daftar Produk',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Kenali produk dan potensi usaha masyarakat Desa Tembarak',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 40),

              Wrap(
                spacing: 22,
                runSpacing: 22,
                alignment: WrapAlignment.center,
                children: products.map((product) {
                  return _productCard(
                    name: product['name'] as String,
                    owner: product['owner'] as String,
                    address: product['address'] as String,
                    phone: product['phone'] as String,
                    description:
                        product['description'] as String,
                    icon: product['icon'] as IconData,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT CARD
  // ============================================================

  Widget _productCard({
    required String name,
    required String owner,
    required String address,
    required String phone,
    required String description,
    required IconData icon,
  }) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FOTO PRODUK
          Container(
            width: double.infinity,
            height: 210,
            decoration: const BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 80,
                color: AppTheme.primary,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAMA PRODUK
                Text(
                  name,
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // DESKRIPSI
                Text(
                  description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 20),

                const Divider(),

                const SizedBox(height: 15),

                // PEMILIK
                _infoRow(
                  Icons.person_outline,
                  'Pemilik',
                  owner,
                ),

                const SizedBox(height: 12),

                // ALAMAT
                _infoRow(
                  Icons.location_on_outlined,
                  'Alamat',
                  address,
                ),

                const SizedBox(height: 12),

                // TELEPON
                _infoRow(
                  Icons.phone_outlined,
                  'Telepon',
                  phone,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _infoRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppTheme.primary,
          size: 20,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: value,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}