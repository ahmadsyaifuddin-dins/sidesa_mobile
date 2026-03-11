class AduanModel {
  final int id;
  final String kodeAduan;
  final String judul;
  final String kategori;
  final String deskripsi;
  final String prioritas;
  final String status;
  final int isAnonymous;
  final String? tanggapan;
  final String? fotoUrl;
  final String createdAt;

  AduanModel({
    required this.id,
    required this.kodeAduan,
    required this.judul,
    required this.kategori,
    required this.deskripsi,
    required this.prioritas,
    required this.status,
    required this.isAnonymous,
    this.tanggapan,
    this.fotoUrl,
    required this.createdAt,
  });

  factory AduanModel.fromJson(Map<String, dynamic> json) {
    return AduanModel(
      id: json['id'],
      kodeAduan: json['kode_aduan'],
      judul: json['judul'],
      kategori: json['kategori'],
      deskripsi: json['deskripsi'],
      prioritas: json['prioritas'],
      status: json['status'],
      isAnonymous: json['is_anonymous'] is int 
          ? json['is_anonymous'] 
          : (json['is_anonymous'] == true ? 1 : 0),
      tanggapan: json['tanggapan'],
      fotoUrl: json['foto_url'],
      createdAt: json['created_at'],
    );
  }
}