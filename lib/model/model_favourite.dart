import 'dart:convert';

ModelFavourite modelFavouriteFromJson(String str) =>
    ModelFavourite.fromJson(json.decode(str));

String modelFavouriteToJson(ModelFavourite data) => json.encode(data.toJson());

class ModelFavourite {
  bool isSuccess;
  List<Favourite> data;

  ModelFavourite({
    required this.isSuccess,
    required this.data,
  });

  factory ModelFavourite.fromJson(Map<String, dynamic> json) => ModelFavourite(
    isSuccess: json["isSuccess"],
    data: List<Favourite>.from(json["data"].map((x) => Favourite.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Favourite {
  int id_favourite;
  int id_produk;
  String nama_produk;
  int harga;
  int stok;
  String keterangan;
  String gambar;

  Favourite({
    required this.id_favourite,
    required this.id_produk,
    required this.nama_produk,
    required this.harga,
    required this.stok,
    required this.keterangan,
    required this.gambar,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) => Favourite(
    id_favourite: json["id_favourite"],
    id_produk: json["id_produk"],
    nama_produk: json["nama_produk"],
    harga: json["harga"],
    stok: json["stok"],
    keterangan: json["keterangan"],
    gambar: json["gambar"],
  );

  Map<String, dynamic> toJson() => {
    "id_favourite": id_favourite,
    "id_produk": id_produk,
    "nama_produk": nama_produk,
    "harga": harga,
    "stok": stok,
    "keterangan": keterangan,
    "gambar": gambar,
  };
}
