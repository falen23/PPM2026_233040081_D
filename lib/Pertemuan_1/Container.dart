import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: Container(
          // Eksperimen 1: Coba ubah nilai width & height di sini
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue,

            // Eksperimen 2: Ganti circular(20) ke (100) untuk melihat efek membulat
            borderRadius: BorderRadius.circular(20),

            // Eksperimen 4: Menambahkan border hitam setebal 4 unit
            border: Border.all(color: Colors.black, width: 4),

            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3),
                // Eksperimen 3: Ubah blurRadius ke 50 untuk bayangan yang lebih halus
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Box',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ),
    ),
  ));
}