class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? nik;
  final String? namaLengkapWarga;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.nik,
    this.namaLengkapWarga,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Sesuaikan dengan respon API Laravel kamu
    final userData = json['data']['user'];
    final wargaData = json['data']['warga'];
    final token = json['data']['access_token'];

    return UserModel(
      id: userData['id'],
      name: userData['name'],
      email: userData['email'],
      role: userData['role'],
      // Handle null safety jika data warga kosong
      nik: wargaData != null ? wargaData['nik'] : null,
      namaLengkapWarga: wargaData != null ? wargaData['nama_lengkap'] : null,
      token: token,
    );
  }
}