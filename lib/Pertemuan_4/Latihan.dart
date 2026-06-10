import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ==========================================
// MODEL DATA (DITAMBAHKAN FIELD EMAIL)
// ==========================================
class Catatan {
  final String judul;
  final String isi;
  final String kategori;
  final String email; // Tambahan field email
  final DateTime dibuatPada;

  Catatan({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.email, // Tambahan parameter email
    required this.dibuatPada,
  });
}

// ==========================================
// APPLICATION ROOT
// ==========================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/tambah':
            final catatanLama = settings.arguments as Catatan?;
            return MaterialPageRoute(
              builder: (_) => TambahCatatanPage(catatanLama: catatanLama),
            );
          case '/detail':
            final catatan = settings.arguments as Catatan;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(catatan: catatan),
            );
        }
        return null;
      },
    );
  }
}

// ==========================================
// 1. HOME PAGE (DILENGKAPI SEARCH & FILTER DI BAWAH JUDUL)
// ==========================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // === STATE: Daftar Catatan Asli ===
  final List<Catatan> _catatan = [
    Catatan(
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation pada pertemuan 3.',
      kategori: 'Kuliah',
      email: 'budi.mahasiswa@uii.ac.id',
      dibuatPada: DateTime.now(),
    ),
    Catatan(
      judul: 'Beli Buku Logika',
      isi: 'Membeli buku pendukung untuk kuliah struktur data semester ini.',
      kategori: 'Pribadi',
      email: 'budi.pribadi@gmail.com',
      dibuatPada: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // === STATE BARU: Fitur Pencarian & Filter ===
  String _kataKunciPencarian = '';
  String _kategoriTerpilih = 'Semua';
  final List<String> _kategoriFilterOpsi = ['Semua', 'Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  final _searchCtrl = TextEditingController();

  List<Catatan> get _catatanTerfilter {
    return _catatan.where((catatan) {
      final cocokKategori = _kategoriTerpilih == 'Semua' || catatan.kategori == _kategoriTerpilih;

      final cocokPencarian = catatan.judul.toLowerCase().contains(_kataKunciPencarian.toLowerCase()) ||
          catatan.isi.toLowerCase().contains(_kataKunciPencarian.toLowerCase()) ||
          catatan.email.toLowerCase().contains(_kataKunciPencarian.toLowerCase());
      return cocokKategori && cocokPencarian;
    }).toList();
  }

  Future<void> _navigasiKeForm({Catatan? catatanLama, int? indexAsli}) async {
    final hasil = await Navigator.pushNamed(
      context,
      '/tambah',
      arguments: catatanLama,
    );

    if (hasil is Catatan) {
      setState(() {
        if (indexAsli != null) {
          _catatan[indexAsli] = hasil;
        } else {
          _catatan.add(hasil);
        }
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              indexAsli != null
                  ? 'Catatan "${hasil.judul}" berhasil diperbarui'
                  : 'Catatan "${hasil.judul}" ditambahkan'
          ),
        ),
      );
    }
  }

  void _hapusCatatan(int indexAsli) {
    final judulDihapus = _catatan[indexAsli].judul;
    setState(() {
      _catatan.removeAt(indexAsli);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Catatan "$judulDihapus" telah dihapus')),
    );
  }

  String _formatTanggal(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} - ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Catatan Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // 1. Search Bar Modern
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Cari judul, isi, atau email...',
                      prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                      suffixIcon: _kataKunciPencarian.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchCtrl.clear();
                            _kataKunciPencarian = '';
                          });
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _kataKunciPencarian = value;
                      });
                    },
                  ),
                ),
              ),
              // 2. Filter Kategori Horisontal (Chip style)
              SizedBox(
                height: 55,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _kategoriFilterOpsi.length,
                  itemBuilder: (context, index) {
                    final kat = _kategoriFilterOpsi[index];
                    final isSelected = _kategoriTerpilih == kat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(kat),
                        selected: isSelected,
                        selectedColor: Colors.indigo,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.indigo.shade700,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        backgroundColor: Colors.indigo.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.indigo.shade100),
                        ),
                        onSelected: (bool value) {
                          setState(() {
                            _kategoriTerpilih = kat;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: _catatanTerfilter.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _catatan.isEmpty ? Icons.note_alt_outlined : Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _catatan.isEmpty ? 'Belum ada catatan' : 'Catatan tidak ditemukan',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: _catatanTerfilter.length,
        itemBuilder: (context, i) {
          final c = _catatanTerfilter[i];
          final indexAsli = _catatan.indexOf(c);

          return Card(
            color: Colors.white,
            elevation: 2,
            shadowColor: Colors.black12,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                // Properti style dipindahkan ke bawah, ke dalam Text()
                child: Text(
                  c.judul,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), //  BENAR
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.isi,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          c.kategori,
                          style: TextStyle(color: Colors.indigo.shade700, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          c.email,
                          style: TextStyle(color: Colors.teal.shade700, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatTanggal(c.dibuatPada),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _hapusCatatan(indexAsli),
              ),
              onTap: () async {
                final dataTerupdate = await Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: c
                );

                if (dataTerupdate is Catatan) {
                  setState(() {
                    _catatan[indexAsli] = dataTerupdate;
                  });
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigasiKeForm(),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ==========================================
// 2. TAMBAH / EDIT CATATAN PAGE (DENGAN INPUT EMAIL & REGEX)
// ==========================================
class TambahCatatanPage extends StatefulWidget {
  final Catatan? catatanLama;
  const TambahCatatanPage({super.key, this.catatanLama});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _isiCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String _kategori = 'Kuliah';
  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    if (widget.catatanLama != null) {
      _judulCtrl.text = widget.catatanLama!.judul;
      _isiCtrl.text = widget.catatanLama!.isi;
      _kategori = widget.catatanLama!.kategori;
      _emailCtrl.text = widget.catatanLama!.email;
    }
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final catatanResult = Catatan(
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      email: _emailCtrl.text.trim().toLowerCase(),
      dibuatPada: widget.catatanLama?.dibuatPada ?? DateTime.now(),
    );

    Navigator.pop(context, catatanResult);
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.catatanLama != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Catatan' : 'Tambah Catatan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
                hintText: 'contoh@domain.com',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Email wajib diisi';
                }
                final polaRegexEmail = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                );
                if (!polaRegexEmail.hasMatch(v.trim())) {
                  return 'Format penulisan email salah!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _simpan,
              icon: Icon(isEditMode ? Icons.edit : Icons.save),
              label: Text(isEditMode ? 'Perbarui Catatan' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. DETAIL CATATAN PAGE (DILENGKAPI TAMPILAN EMAIL)
// ==========================================
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;

  const DetailCatatanPage({super.key, required this.catatan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Catatan',
            onPressed: () async {
              final hasilEdit = await Navigator.pushNamed(
                context,
                '/tambah',
                arguments: catatan,
              );

              if (hasilEdit is Catatan && context.mounted) {
                Navigator.pop(context, hasilEdit);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              catatan.judul,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Chip(
                  label: Text(catatan.kategori),
                  backgroundColor: Colors.indigo.shade50,
                  avatar: const Icon(Icons.category, size: 16),
                ),
                Chip(
                  label: Text(catatan.email),
                  backgroundColor: Colors.teal.shade50,
                  avatar: const Icon(Icons.email_outlined, size: 16),
                ),
              ],
            ),
            const Divider(height: 32),
            Text(
              catatan.isi,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 40),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}