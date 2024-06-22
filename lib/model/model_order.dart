// import 'dart:convert';
//
// ModelOrder modelOrderFromJson(String str) =>
//     ModelOrder.fromJson(json.decode(str));
//
// String modelOrderToJson(ModelOrder data) => json.encode(data.toJson());
//
// class ModelOrder {
//   bool isSuccess;
//   List<Order> data;
//
//   ModelOrder({
//     required this.isSuccess,
//     required this.data,
//   });
//
//   factory ModelOrder.fromJson(Map<String, dynamic> json) => ModelOrder(
//     isSuccess: json["isSuccess"],
//     data: List<Order>.from(json["data"].map((x) => Order.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "isSuccess": isSuccess,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//   };
// }
//
// class Order {
//   String nama;
//   String no_hp;
//   String alamat;
//   String kode_pos;
//   String no_pesanan;
//   String nama_produk;
//   String jumlah;
//   String harga;
//   String total_bayar;
//   String status;
//
//   Order({
//     required this.nama,
//     required this.no_hp,
//     required this.alamat,
//     required this.kode_pos,
//     required this.no_pesanan,
//     required this.nama_produk,
//     required this.jumlah,
//     required this.harga,
//     required this.total_bayar,
//     required this.status,
//   });
//
//   factory Order.fromJson(Map<String, dynamic> json) => Order(
//     nama: json["nama"],
//     no_hp: json["ni_hp"],
//     alamat: json["alamat"],
//     kode_pos: json["kode_pos"].toString(),
//     no_pesanan: json["no_pesanan"],
//     nama_produk: json["nama_produk"],
//     jumlah: json["jumlah"].toString(),
//     harga: json["harga"].toString(),
//     total_bayar: json["total_bayar"].toString(),
//     status: json["status"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "nama": nama,
//     "no_hp": no_hp,
//     "alamat": alamat,
//     "kode_pos": kode_pos,
//     "no_pesanan": no_pesanan,
//     "nama_produk": nama_produk,
//     "jumlah": jumlah,
//     "harga": harga,
//     "total_bayar": total_bayar,
//     "status": status,
//   };
// }

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
  String noHp;
  String alamat;
  String kodePos;
  String noPesanan;
  String namaProduk;
  String jumlah;
  String harga;
  String totalBayar;
  String status;

  Order({
    required this.nama,
    required this.noHp,
    required this.alamat,
    required this.kodePos,
    required this.noPesanan,
    required this.namaProduk,
    required this.jumlah,
    required this.harga,
    required this.totalBayar,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    nama: json["nama"] ?? '',
    noHp: json["no_hp"] ?? '',
    alamat: json["alamat"] ?? '',
    kodePos: json["kode_pos"]?.toString() ?? '',
    noPesanan: json["no_pesanan"] ?? '',
    namaProduk: json["nama_produk"] ?? '',
    jumlah: json["jumlah"]?.toString() ?? '',
    harga: json["harga"]?.toString() ?? '',
    totalBayar: json["total_bayar"]?.toString() ?? '',
    status: json["status"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "nama": nama,
    "no_hp": noHp,
    "alamat": alamat,
    "kode_pos": kodePos,
    "no_pesanan": noPesanan,
    "nama_produk": namaProduk,
    "jumlah": jumlah,
    "harga": harga,
    "total_bayar": totalBayar,
    "status": status,
  };
}

