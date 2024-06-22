import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ecommerce/alamat_pengiriman.dart';
import 'package:project_ecommerce/detail_product.dart';
import 'package:project_ecommerce/profile.dart';
import 'package:project_ecommerce/utils/session_manager.dart';
import 'cart_screen.dart';
import 'edit_profile.dart';
import 'home_page.dart';
import 'login.dart';
import 'model/model_order.dart';
import 'model/model_user.dart';
import 'order_screen.dart';
import 'package:http/http.dart' as http;

class DetailOrder extends StatelessWidget {
  final Order? data;

  const DetailOrder({Key? key, this.data}) : super(key: key);
  // const DetailOrder({super.key});

//   @override
//   State<DetailOrder> createState() => _DetailOrder();
// }
//
// class _DetailOrder extends State<DetailOrder> with WidgetsBindingObserver {
//   late ModelUsers currentUser; // Nullable currentUser
//   int _selectedIndex = 0;
//   List<Order> _pesananList = [];
//   List<Order> _filteredPesananList = [];
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this); // Add the observer
//     getDataSession();// Load session data when the widget initializes
//     _fetchPesanan();
//   }
//
//   Future<void> _fetchPesanan() async {
//     try {
//       final response = await http.get(Uri.parse('http://192.168.1.12/kelompok4/order.php?id_user=${sessionManager.id_user}'));
//       if (response.statusCode == 200) {
//         final parsed = jsonDecode(response.body);
//         setState(() {
//           _pesananList = List<Order>.from(parsed['data'].map((x) => Order.fromJson(x)));
//           _filteredPesananList = _pesananList;
//           _isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load keranjang');
//       }
//     } catch (e) {
//       print('Error fetching products: $e');
//       setState(() {
//         _isLoading = false;
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this); // Remove the observer
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       getDataSession();
//     }
//   }
//
//   void _filterPesananList(String query) {
//     setState(() {
//       _filteredPesananList = _pesananList.where((pesanan) => pesanan.namaProduk.toLowerCase().contains(query.toLowerCase())).toList();
//     });
//   }
//
//   Future<void> getDataSession() async {
//     bool hasSession = await sessionManager.getSession();
//     if (hasSession) {
//       setState(() {
//         currentUser = ModelUsers(
//           id_user: sessionManager.id_user!,
//           username: sessionManager.username!,
//           email: sessionManager.email!,
//           no_hp: sessionManager.no_hp!,
//           fullname: sessionManager.fullname!,
//           alamat: sessionManager.alamat!,
//           role: sessionManager.role!,
//           jenis_kelamin: sessionManager.jenis_kelamin!,
//         );
//       });
//     } else {
//       print('Log Session tidak ditemukan!');
//     }
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     switch (index) {
//       case 0:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage()),
//         );
//         break;
//       case 1:
//       // Navigasi ke halaman Keranjang
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => CartScreen()),
//         );
//         break;
//       case 2:
//       // Navigasi ke halaman Pesanan
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => OrderScreen()),
//         );
//         break;
//       case 3:
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ProfilePage(currentUser: currentUser)),
//         );
//         break;
//         // // Tambahkan logika logout
//         //   setState(() {
//         //     sessionManager.clearSession();
//         //     Navigator.pushAndRemoveUntil(
//         //       context,
//         //       MaterialPageRoute(
//         //           builder: (context) =>
//         //               LoginScreen()),
//         //           (route) => false,
//         //     );
//         //   });
//         break;
//       default:
//     }
//   }
//
//   Future<void> _refreshData() async {
//     await Future.delayed(Duration(seconds: 2));
//     setState(() {
//       getDataSession();
//     });
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF87CEEB),
        title: Text('Rincian Pesanan'),
      ),
      backgroundColor: Color(0xFF87CEEB),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.place,
                                  size: 30,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data?.alamat ?? 'No Title',
                                        // "Alamat Pengiriman",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${data?.nama}|${data?.noHp}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        data?.alamat ?? 'No Title',
                                        // "Jalan Raya Kalibata",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:  const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    "Informasi Pengiriman",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        "Ambil di Tempat",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:  const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    "Metode Pembayaran",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        "Cash",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image.asset(
                                //   'images/img2.png',
                                //   width: 100,
                                // ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data?.namaProduk ?? 'No Title',
                                        // "Ketika Cinta Bertasbih",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Jumlah : ${data?.jumlah}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "Rp. ${data?.harga}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 20), // Menambahkan spasi antara teks dan tombol
                                      Text(
                                        "Total Pesanan : ${data?.totalBayar}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:  const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    "Pesanan",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "No Pesanan",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            data?.noPesanan ?? 'No Title',
                                            // "H29ISKLE421",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.shopping_cart),
      //       label: 'Keranjang',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.bookmarks_outlined),
      //       label: 'Pesanan',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Colors.blue,
      //   backgroundColor: Color(0xFF87CEEB),
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
