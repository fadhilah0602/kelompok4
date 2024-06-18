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
  String nama_produk;
  int jumlah;
  int harga;
  int subtotal;

  Keranjang({
    required this.nama_produk,
    required this.harga,
    required this.jumlah,
    required this.subtotal,
  });

  factory Keranjang.fromJson(Map<String, dynamic> json) => Keranjang(
    nama_produk: json["nama_produk"],
    harga: json["harga"],
    jumlah: json["jumlah"],
    subtotal: json["subtotal"],
  );

  Map<String, dynamic> toJson() => {
    "nama_produk": nama_produk,
    "harga": harga,
    "jumlah": jumlah,
    "subtotal": subtotal,
  };
}
