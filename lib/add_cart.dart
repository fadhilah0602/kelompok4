import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_ecommerce/utils/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'model/model_produk.dart';

class AddCart extends StatefulWidget {
  final Produk data;
  //
  AddCart({required this.data});

  @override
  _AddCartState createState() => _AddCartState();

}

class _AddCartState extends State<AddCart> {

  int jumlah = 1;
  bool _isAddingToCart = false;

  Produk get data => this.widget.data;

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  void _incrementQuantity() {
    setState(() {
      jumlah++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (jumlah > 1) {
        jumlah--;
      }
    });
  }

  double getTotalAmount() {
    double harga = double.tryParse(widget.data.harga) ?? 0.0;
    return jumlah * harga;
  }

  Future<void> _addToCart(Produk product) async {

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.12/kelompok4/addKeranjang.php'),
        body: {
          'id_user': sessionManager.id_user,
          'id_produk': product.id_produk,
          'jumlah': jumlah.toString(), // This can be adjusted if you implement quantity selection
        },
      );

      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 && responseBody['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product added to cart successfully")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseBody['message'] ?? "Failed to add product to cart")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error adding product to cart: $e")));
    }
  }

  // Future<void> _addToCart() async {
  //   if (_isAddingToCart) {
  //     return; // menghindari pemanggilan API ganda
  //   }
  //   try {
  //     setState(() {
  //       _isAddingToCart = true; // Menonaktifkan tombol "Add to Cart"
  //     });
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     // String? token = prefs.getString('token');
  //     //
  //     // print('Token: $token');
  //
  //     // if (token == null) {
  //     //   throw Exception('Token not found!');
  //     // }
  //
  //     print('Product ID: ${widget.data.id_produk}');
  //     print('Quantity: $jumlah');
  //     print(
  //         'Data yang dikirim ke API: { "product_id": ${widget.data.id_produk}, "jumlah": $jumlah }');
  //
  //     final response = await http.post(
  //       Uri.parse(
  //           'http://192.168.1.12/kelompok4/addKeranjang.php'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         // 'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({
  //         'product_id': widget.data.id_produk,
  //         'jumlah': jumlah,
  //       }),
  //     );
  //
  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       final responseBody = jsonDecode(response.body);
  //       if (responseBody['status']) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Product successfully added to cart')),
  //         );
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //               content: Text(
  //                   'Failed to add product to cart: ${responseBody['message']}')),
  //         );
  //       }
  //     } else if (response.statusCode == 422) {
  //       final responseBody = jsonDecode(response.body);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             content: Text('Validation error: ${responseBody['errors']}')),
  //       );
  //     } else if (response.statusCode == 404) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Product not found')),
  //       );
  //     } else {
  //       throw Exception('Failed to add to cart: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error adding to cart: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error adding to cart: $e')),
  //     );
  //   } finally {
  //     setState(() {
  //       _isAddingToCart = false; // Mengaktifkan kembali tombol "Add to Cart"
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, // Arahkan widget ke kiri
        children: [
          // LoginScreen01(),
          SizedBox(height: 10),
          Container(
            height: 4,
            width: 50,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 223, 221, 221),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 30), // Jarak antara judul dan input field
          Text(
            'Jumlah : ', // Judul input field
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, color: Colors.blue),
                      onPressed: _decrementQuantity,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '$jumlah',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.blue),
                      onPressed: _incrementQuantity,
                    ),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () async {
                    await _addToCart(data);
                  },
                  padding: EdgeInsets.symmetric(
                    horizontal: 175,
                    vertical: 15,
                  ),
                  color:  Color(0xFF87CEEB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Agar Row menyesuaikan dengan ukuran konten
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.blue), // Mengubah warna ikon menjadi biru
                      SizedBox(width: 5), // Memberi jarak antara ikon dan teks
                      Text(
                        "add to cart",
                        style: TextStyle(color: Colors.white), // Mengubah warna teks menjadi biru
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),// Jarak antara judul dan input field
        ],
      ),
    );
  }
}
