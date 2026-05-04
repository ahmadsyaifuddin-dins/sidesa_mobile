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
    // Tangkap wrapper 'data' utama dari respon API Laravel
    final dataMap = json['data'];
    final userData = dataMap['user'];
    final wargaData = dataMap['warga'];
    final token = dataMap['access_token'];

    return UserModel(
      id: userData['id'],
      name: userData['name'],
      email: userData['email'],
      role: userData['role'],
      
      // Ambil avatar dari data user
      avatar: userData['avatar'], 
      
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