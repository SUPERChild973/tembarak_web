import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class KontakPage extends StatelessWidget {
  const KontakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _headerSection(),
          _contactSection(),
          _serviceSection(),
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
            Icons.contact_phone,
            color: Colors.white,
            size: 60,
          ),
          SizedBox(height: 20),
          Text(
            'Kontak Desa',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Hubungi Pemerintah Desa Tembarak',
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
  // CONTACT
  // ============================================================

  Widget _contactSection() {
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
            maxWidth: 1050,
          ),
          child: Wrap(
            spacing: 25,
            runSpacing: 25,
            alignment: WrapAlignment.center,
            children: [
              _contactCard(
                icon: Icons.location_on,
                title: 'Alamat Kantor Desa',
                content: 'Alamat Kantor Desa Tembarak',
              ),
              _contactCard(
                icon: Icons.phone,
                title: 'Telepon',
                content: 'Nomor Telepon Desa',
              ),
              _contactCard(
                icon: Icons.email,
                title: 'Email',
                content: 'Email Resmi Desa',
              ),
              _contactCard(
                icon: Icons.access_time,
                title: 'Jam Pelayanan',
                content: 'Senin - Jumat\n08.00 - 15.00 WIB',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CONTACT CARD
  // ============================================================

  Widget _contactCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: 480,
      constraints: const BoxConstraints(
        minHeight: 150,
      ),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(
              color: AppTheme.lightGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.primary,
              size: 27,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 9),

                Text(
                  content,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SERVICE
  // ============================================================

  Widget _serviceSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 55,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 900,
          ),
          child: Container(
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.support_agent,
                  color: AppTheme.primary,
                  size: 50,
                ),

                SizedBox(height: 18),

                Text(
                  'Pelayanan Masyarakat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 12),

                Text(
                  'Pemerintah Desa Tembarak berkomitmen memberikan '
                  'pelayanan terbaik kepada seluruh masyarakat desa.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    height: 1.7,
                  ),
                ),

                SizedBox(height: 22),

                Text(
                  'Informasi alamat, nomor telepon, email, dan jam pelayanan '
                  'dapat diperbarui melalui halaman admin.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}