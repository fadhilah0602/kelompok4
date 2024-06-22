import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_ecommerce/alamat_pengiriman.dart';
import 'package:project_ecommerce/detail_order.dart';
import 'package:project_ecommerce/detail_product.dart';
import 'package:project_ecommerce/model/model_keranjang.dart';
import 'package:project_ecommerce/profile.dart';
import 'package:project_ecommerce/utils/session_manager.dart';
import 'cart_screen.dart';
import 'edit_profile.dart';
import 'home_page.dart';
import 'login.dart';
import 'model/model_order.dart';
import 'model/model_user.dart';
import 'package:http/http.dart' as http;

import 'navigation_page.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreen();
}

class _OrderScreen extends State<OrderScreen> with WidgetsBindingObserver {
  late ModelUsers currentUser;
  late Order pesanan;
  // late AlamatPengiriman alamatPengiriman;
  int _selectedIndex = 0;
  List<Order> _pesananList = [];
  List<Order> _filteredPesananList = [];
  // late bool _Loading;
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getDataSession();
    _fetchPesanan();
  }

  Future<void> _fetchPesanan() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.12/kelompok4/order.php?id_user=${sessionManager.id_user}'));
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        setState(() {
          _pesananList = List<Order>.from(parsed['data'].map((x) => Order.fromJson(x)));
          _filteredPesananList = _pesananList;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load keranjang');
      }
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        _isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getDataSession();
    }
  }

  void _filterPesananList(String query) {
    setState(() {
      _filteredPesananList = _pesananList.where((pesanan) => pesanan.nama.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  Future<void> getDataSession() async {
    bool hasSession = await sessionManager.getSession();
    if (hasSession) {
      setState(() {
        currentUser = ModelUsers(
          id_user: sessionManager.id_user!,
          username: sessionManager.username!,
          email: sessionManager.email!,
          no_hp: sessionManager.no_hp!,
          fullname: sessionManager.fullname!,
          alamat: sessionManager.alamat!,
          role: sessionManager.role!,
          jenis_kelamin: sessionManager.jenis_kelamin!,
        );
      });
    } else {
      print('Log Session tidak ditemukan!');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavigationPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(currentUser: currentUser)),
        );
        break;
      default:
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      getDataSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF87CEEB),
        title: Text('Pesanan '),
      ),
      backgroundColor: Color(0xFF87CEEB),
      body:  _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterPesananList,
                decoration: InputDecoration(
                  labelText: 'Search Pesanan',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredPesananList.length,
                itemBuilder: (context, index) {
                  final pesanan = _filteredPesananList[index];
                  return InkWell(
                    onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DetailOrder(data: pesanan)),
                            );
                      print('Card tapped: ${pesanan.namaProduk}');
                    },
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pesanan.namaProduk,
                              // "Langit Biru",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Jumlah : ${pesanan.jumlah}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "Rp. ${pesanan.harga}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Total Pesanan : ${pesanan.totalBayar}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )

            // Padding(
                  //   padding: const EdgeInsets.only(bottom: 10),
                  //   child: InkWell(
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(builder: (context) => DetailOrder()),
                  //       );
                  //     },
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(20),
                  //       ),
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.all(12.0),
                  //             child: Row(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 // Image.asset(
                  //                 //   'images/img2.png',
                  //                 //   width: 100,
                  //                 // ),
                  //                 SizedBox(width: 20),
                  //                 Expanded(
                  //                   child: ListView.builder(
                  //                       itemCount: _pesananList.length,
                  //                       itemBuilder: (context, index) {
                  //                         final keranjang = _pesananList[index];
                  //                         return Card(
                  //                           elevation: 4,
                  //                           margin: EdgeInsets.all(8.0),
                  //                           child: Padding(
                  //                             padding: EdgeInsets.all(16.0),
                  //                             child: Column(
                  //                               crossAxisAlignment: CrossAxisAlignment.start,
                  //                               children: [
                  //                                 Text(
                  //                                   pesanan.nama_produk ?? 'No Title',
                  //                                   // "Langit Biru",
                  //                                   style: TextStyle(
                  //                                     fontSize: 18,
                  //                                     fontWeight: FontWeight.bold,
                  //                                   ),
                  //                                 ),
                  //                                 Text(
                  //                                   "Jumlah : ${pesanan.jumlah}",
                  //                                   style: TextStyle(
                  //                                     color: Colors.black,
                  //                                     fontSize: 14,
                  //                                   ),
                  //                                 ),
                  //                                 Text(
                  //                                   "Rp. ${pesanan.harga.toStringAsFixed(2)}",
                  //                                   style: TextStyle(
                  //                                     color: Colors.black,
                  //                                     fontSize: 14,
                  //                                   ),
                  //                                 ),
                  //                                 SizedBox(height: 20),
                  //                                 Text(
                  //                                   "Total Pesanan : ${pesanan.total_bayar.toStringAsFixed(2)}",
                  //                                   style: TextStyle(
                  //                                     fontSize: 18,
                  //                                     fontWeight: FontWeight.bold,
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         );
                  //                       }),
                  //
                  //
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmarks_outlined),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue,
        backgroundColor: Color(0xFF87CEEB),
        onTap: _onItemTapped,
      ),
    );
  }
}
