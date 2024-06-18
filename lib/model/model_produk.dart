import 'dart:convert';

ModelProduk modelProdukFromJson(String str) =>
    ModelProduk.fromJson(json.decode(str));

String modelProdukToJson(ModelProduk data) => json.encode(data.toJson());

class ModelProduk {
  bool isSuccess;
  List<Produk> data;

  ModelProduk({
    required this.isSuccess,
    required this.data,
  });

  factory ModelProduk.fromJson(Map<String, dynamic> json) => ModelProduk(
    isSuccess: json["isSuccess"],
    data: List<Produk>.from(json["data"].map((x) => Produk.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Produk {
  String id_kategori;
  String id_produk;
  String nama_produk;
  String harga;
  String stok;
  String berat;
  String keterangan;
  String gambar;

  Produk({
    required this.id_kategori,
    required this.id_produk,
    required this.nama_produk,
    required this.harga,
    required this.stok,
    required this.berat,
    required this.keterangan,
    required this.gambar,
  });

  factory Produk.fromJson(Map<String, dynamic> json) => Produk(
    id_kategori: json["id_kategori"].toString(),
    id_produk: json["id_produk"].toString(),
    nama_produk: json["nama_produk"],
    harga: json["harga"],
    stok: json["stok"],
    berat: json["berat"],
    keterangan: json["keterangan"],
    gambar: json["gambar"],
  );

  Map<String, dynamic> toJson() => {
    "id_kategori": id_kategori,
    "id_produk": id_produk,
    "nama_produk": nama_produk,
    "harga": harga,
    "stok": stok,
    "berat": berat,
    "keterangan": keterangan,
    "gambar": gambar,
  };
}
