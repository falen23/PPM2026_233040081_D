import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'main.dart'; // Import untuk mengakses class Catatan

class ApiClient {
  ApiClient._privateConstructor();
  static final ApiClient instance = ApiClient._privateConstructor();

  static const String _baseUrl = 'https://besab-production.up.railway.app/api';
  static const String _apiKey = '8f38b5fbf0bc437285f2c62ed6e447eab56f78c8f95239a7';

  // Header wajib untuk setiap request sesuai Kontrak API
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'X-API-Key': _apiKey,
  };

  // Helper untuk membungkus pengiriman & penanganan 3 kelas error jaringan
  Future<http.Response> _aman(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(const Duration(seconds: 10));
    } on SocketException {
      throw 'Tidak ada koneksi internet. Periksa jaringan Anda.';
    } on TimeoutException {
      throw 'Koneksi ke server terputus (Timeout). Silakan coba lagi.';
    } catch (e) {
      throw 'Terjadi kesalahan jaringan: $e';
    }
  }

  // 1. READ ALL (GET /catatan)
  Future<List<Catatan>> getAll() async {
    final response = await _aman(() => http.get(Uri.parse('$_baseUrl/catatan'), headers: _headers));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((json) => Catatan.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw 'Akses ditolak: API Key tidak valid.';
    } else {
      throw 'Gagal memuat data (Status: ${response.statusCode})';
    }
  }

  // 2. CREATE (POST /catatan)
  Future<Catatan> insert(Catatan catatan) async {
    final response = await _aman(() => http.post(
      Uri.parse('$_baseUrl/catatan'),
      headers: _headers,
      body: jsonEncode(catatan.toJson()),
    ));

    if (response.statusCode == 201) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return Catatan.fromJson(body['data']);
    } else if (response.statusCode == 422) {
      throw 'Validasi gagal: Pastikan semua data terisi dengan benar.';
    } else {
      throw 'Gagal menambahkan catatan (Status: ${response.statusCode})';
    }
  }

  // 3. UPDATE (PUT /catatan/{id})
  Future<Catatan> update(Catatan catatan) async {
    final response = await _aman(() => http.put(
      Uri.parse('$_baseUrl/catatan/${catatan.id}'),
      headers: _headers,
      body: jsonEncode(catatan.toJson()),
    ));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return Catatan.fromJson(body['data']);
    } else if (response.statusCode == 404) {
      throw 'Catatan tidak ditemukan di server.';
    } else if (response.statusCode == 422) {
      throw 'Validasi gagal saat memperbarui data.';
    } {
      throw 'Gagal memperbarui catatan (Status: ${response.statusCode})';
    }
  }

  // 4. DELETE (DELETE /catatan/{id})
  Future<void> delete(int id) async {
    final response = await _aman(() => http.delete(
      Uri.parse('$_baseUrl/catatan/$id'),
      headers: _headers,
    ));

    if (response.statusCode != 200) {
      if (response.statusCode == 404) {
        throw 'Data sudah dihapus atau tidak ditemukan.';
      }
      throw 'Gagal menghapus data (Status: ${response.statusCode})';
    }
  }
}