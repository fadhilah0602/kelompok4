import 'dart:convert';

ModelKeranjang modelKeranjangFromJson(String str) =>
    ModelKeranjang.fromJson(json.decode(str));

String modelKeranjangToJson(ModelKeranjang data) => json.encode(data.toJson());

class ModelKeranjang {
  bool isSuccess;
  List<Keranjang> data;

  ModelKeranjang({
    required this.isSuccess,
    required this.data,
  });

  factory ModelKeranjang.fromJson(Map<String, dynamic> json) => ModelKeranjang(
    isSuccess: json["isSuccess"],
    data: List<Keranjang>.from(json["data"].map((x) => Keranjang.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Keranjang {
  int id_keranjang;
  String nama_produk;
  int jumlah;
  int harga;
  int subtotal;

  Keranjang({
    required this.id_keranjang,
    required this.nama_produk,
    required this.harga,
    required this.jumlah,
    required this.subtotal,
  });

  factory Keranjang.fromJson(Map<String, dynamic> json) => Keranjang(
    id_keranjang: json["id_keranjang"],
    nama_produk: json["nama_produk"],
    harga: json["harga"],
    jumlah: json["jumlah"],
    subtotal: json["subtotal"],
  );

  Map<String, dynamic> toJson() => {
    "id_keranjang": id_keranjang,
    "nama_produk": nama_produk,
    "harga": harga,
    "jumlah": jumlah,
    "subtotal": subtotal,
  };
}
