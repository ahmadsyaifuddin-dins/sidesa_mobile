class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? nik;
  final String? namaLengkapWarga;
  
  final String? nomorTelepon;
  final String? alamat;
  final String? jenisKelamin;
  final String? tanggalLahir;
  final String? avatar;
  
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.nik,
    this.namaLengkapWarga,
    this.nomorTelepon,
    this.alamat,
    this.jenisKelamin,
    this.tanggalLahir,
    this.avatar,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final dataMap = json['data'] ?? json; 
    final userData = dataMap['user'] ?? dataMap; // Fallback jika objectnya langsung user
    final wargaData = dataMap['warga'];
    final token = dataMap['access_token'];

    return UserModel(
      id: userData['id'] ?? 0,
      name: userData['name'] ?? 'Warga',
      
      // FIX UTAMA: Beri fallback string kosong agar tidak error 'Null is not subtype of String'
      email: userData['email'] ?? '', 
      role: userData['role'] ?? 'warga',
      
      avatar: userData['profile_photo_path'] ?? userData['avatar'], 
      
      // Handle null safety dari tabel warga
      nik: wargaData != null ? wargaData['nik'] : null,
      namaLengkapWarga: wargaData != null ? wargaData['nama_lengkap'] : null,
      nomorTelepon: wargaData != null ? wargaData['nomor_telepon'] : null,
      alamat: wargaData != null ? wargaData['alamat'] : null,
      jenisKelamin: wargaData != null ? wargaData['jenis_kelamin'] : null,
      tanggalLahir: wargaData != null ? wargaData['tanggal_lahir'] : null,
      
      token: token,
    );
  }
}