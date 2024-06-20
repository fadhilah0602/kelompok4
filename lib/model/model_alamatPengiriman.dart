import 'dart:convert';

ModelAlamatPengiriman modelAlamatPengirimanFromJson(String str) =>
    ModelAlamatPengiriman.fromJson(json.decode(str));

String modelAlamatPengirimanToJson(ModelAlamatPengiriman data) => json.encode(data.toJson());

class ModelAlamatPengiriman {
  bool isSuccess;
  List<AlamatPengiriman> data;

  ModelAlamatPengiriman({
    required this.isSuccess,
    required this.data,
  });

  factory ModelAlamatPengiriman.fromJson(Map<String, dynamic> json) => ModelAlamatPengiriman(
    isSuccess: json["isSuccess"],
    data: List<AlamatPengiriman>.from(json["data"].map((x) => AlamatPengiriman.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AlamatPengiriman {
  String nama;
  String no_hp;
  String alamat;
  String kode_pos;

  AlamatPengiriman({
    required this.nama,
    required this.no_hp,
    required this.alamat,
    required this.kode_pos,
  });

  factory AlamatPengiriman.fromJson(Map<String, dynamic> json) => AlamatPengiriman(
    nama: json["nama"],
    no_hp: json["no_hp"],
    alamat: json["alamat"],
    kode_pos: json["kode_pos"],
  );

  Map<String, dynamic> toJson() => {
    "nama": nama,
    "no_hp": no_hp,
    "alamat": alamat,
    "kode_pos": kode_pos,
  };
}
