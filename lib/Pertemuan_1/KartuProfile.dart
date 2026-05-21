import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Mobile Developer & UI Enthusiast',
                style: TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 1),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text('120', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Posts', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('15K', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Followers', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('350', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Following', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Follow Profile', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),

      // --- IMPLEMENTASI LATIHAN 4: BOTTOM BAR MOCK-UP ---
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              // Eksperimen: Ubah Icons, Size (24, 48, 64), dan Color (Red, Green, Purple)
              Icon(Icons.home, size: 32, color: Colors.red),
              Icon(Icons.search, size: 32, color: Colors.green),
              Icon(Icons.notifications, size: 32, color: Colors.purple),
              Icon(Icons.settings, size: 32, color: Colors.grey),
            ],
          ),
        ),
      ),
      // --------------------------------------------------
    );
  }
}