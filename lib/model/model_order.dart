import 'dart:convert';

ModelOrder modelOrderFromJson(String str) =>
    ModelOrder.fromJson(json.decode(str));

String modelOrderToJson(ModelOrder data) => json.encode(data.toJson());

class ModelOrder {
  bool isSuccess;
  List<Order> data;

  ModelOrder({
    required this.isSuccess,
    required this.data,
  });

  factory ModelOrder.fromJson(Map<String, dynamic> json) => ModelOrder(
    isSuccess: json["isSuccess"],
    data: List<Order>.from(json["data"].map((x) => Order.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Order {
  String nama;
  String no_hp;
  String alamat;
  int kode_pos;
  String no_pesanan;
  String nama_produk;
  int jumlah;
  int harga;
  int total_bayar;
  String status;

  Order({
    required this.nama,
    required this.no_hp,
    required this.alamat,
    required this.kode_pos,
    required this.no_pesanan,
    required this.nama_produk,
    required this.jumlah,
    required this.harga,
    required this.total_bayar,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    nama: json["nama"],
    no_hp: json["ni_hp"],
    alamat: json["alamat"],
    kode_pos: json["kode_pos"],
    no_pesanan: json["no_pesanan"],
    nama_produk: json["nama_produk"],
    jumlah: json["jumlah"],
    harga: json["harga"],
    total_bayar: json["total_bayar"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "nama": nama,
    "no_hp": no_hp,
    "alamat": alamat,
    "kode_pos": kode_pos,
    "no_pesanan": no_pesanan,
    "nama_produk": nama_produk,
    "jumlah": jumlah,
    "harga": harga,
    "total_bayar": total_bayar,
    "status": status,
  };
}
