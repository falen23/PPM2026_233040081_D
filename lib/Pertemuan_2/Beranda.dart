import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Beranda')),
            ListTile(leading: Icon(Icons.person), title: Text('Profil')),
            ListTile(leading: Icon(Icons.info), title: Text('Tentang')),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      // PERBAIKAN: Gunakan withValues untuk menghindari deprecation warning
                      color: Colors.grey.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'FALLEN',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.blue,
                        letterSpacing: 2,
                      ),
                    ),
                    const Text('Mobile Developer', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildStatCard('120', 'Projects')),
                  const SizedBox(width: 10),
                  Expanded(child: _buildStatCard('1000K', 'Followers')),
                ],
              ),
              const SizedBox(height: 25),
              const Text(
                  "Riwayat Aktivitas",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 10),

              // PERBAIKAN: Huruf depan Ikon harus kecil (camelCase)
              _buildActivityItem(Icons.code, "Update Repository", "3 jam yang lalu"),
              _buildActivityItem(Icons.brush, "Desain UI Baru", "Keren banget!"), // brush (b kecil)
              _buildActivityItem(Icons.bug_report, "Fixing Bug", "Selesai tepat waktu"), // bug_report (b kecil)
              _buildActivityItem(Icons.cloud_upload, "Deploy Apps", "Versi 1.0.2"), // cloud_upload (c kecil)
              _buildActivityItem(Icons.school, "Selesai Kursus Flutter", "Sertifikat didapat"), // school (s kecil)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Edit Profil'),
        icon: const Icon(Icons.edit),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Pesan'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundColor: Colors.grey[200], child: Icon(icon, size: 20)),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}