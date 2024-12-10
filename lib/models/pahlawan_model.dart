class PahlawanModel {
  final String userId;
  final String laporId;
  final DateTime tanggalSelesai;

  PahlawanModel({
    required this.userId,
    required this.laporId,
    required this.tanggalSelesai,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'laporId': laporId,
      'tanggalSelesai': tanggalSelesai.toIso8601String(),
    };
  }
}
