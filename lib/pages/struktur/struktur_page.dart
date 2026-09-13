import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class StrukturPage extends StatelessWidget {
  const StrukturPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _headerSection(),
          _structureSection(context),
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
            Icons.account_tree,
            color: Colors.white,
            size: 60,
          ),
          SizedBox(height: 20),
          Text(
            'Struktur Pemerintahan Desa',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Pemerintah Desa Tembarak',
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
  // STRUCTURE
  // ============================================================

  Widget _structureSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

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
            maxWidth: 1100,
          ),
          child: Column(
            children: [
              _positionCard(
                icon: Icons.person,
                position: 'Kepala Desa',
                name: 'Nama Kepala Desa',
                large: true,
              ),

              const SizedBox(height: 30),

              _connector(),

              const SizedBox(height: 30),

              _positionCard(
                icon: Icons.badge,
                position: 'Sekretaris Desa',
                name: 'Nama Sekretaris Desa',
                large: true,
              ),

              const SizedBox(height: 40),

              _connector(),

              const SizedBox(height: 40),

              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _positionCard(
                    icon: Icons.account_balance_wallet,
                    position: 'Kaur Keuangan',
                    name: 'Nama Kaur Keuangan',
                  ),
                  _positionCard(
                    icon: Icons.assignment,
                    position: 'Kaur Perencanaan',
                    name: 'Nama Kaur Perencanaan',
                  ),
                  _positionCard(
                    icon: Icons.gavel,
                    position: 'Kasi Pemerintahan',
                    name: 'Nama Kasi Pemerintahan',
                  ),
                  _positionCard(
                    icon: Icons.handshake,
                    position: 'Kasi Kesejahteraan',
                    name: 'Nama Kasi Kesejahteraan',
                  ),
                  _positionCard(
                    icon: Icons.support_agent,
                    position: 'Kasi Pelayanan',
                    name: 'Nama Kasi Pelayanan',
                  ),
                ],
              ),

              const SizedBox(height: 50),

              _informationBox(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // POSITION CARD
  // ============================================================

  Widget _positionCard({
    required IconData icon,
    required String position,
    required String name,
    bool large = false,
  }) {
    return Container(
      width: large ? 360 : 250,
      padding: EdgeInsets.all(large ? 28 : 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: large ? 80 : 65,
            height: large ? 80 : 65,
            decoration: const BoxDecoration(
              color: AppTheme.lightGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.primary,
              size: large ? 40 : 32,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            position,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: large ? 21 : 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONNECTOR
  // ============================================================

  Widget _connector() {
    return Container(
      width: 2,
      height: 30,
      color: AppTheme.primary.withOpacity(0.25),
    );
  }

  // ============================================================
  // INFORMATION
  // ============================================================

  Widget _informationBox(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppTheme.lightGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppTheme.primary,
            size: 28,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Struktur',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Data nama dan jabatan perangkat Desa Tembarak '
                  'di atas masih berupa data sementara. '
                  'Nantinya data ini dapat dikelola melalui halaman '
                  'Admin sehingga perubahan perangkat desa tidak '
                  'perlu dilakukan langsung melalui kode program.',
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
}