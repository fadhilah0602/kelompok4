import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_ecommerce/detail_product.dart';
import 'package:project_ecommerce/model/model_favourite.dart';
import 'package:project_ecommerce/profile.dart';
import 'package:project_ecommerce/utils/session_manager.dart';
import 'cart_screen.dart';
import 'checkout_screen.dart';
import 'edit_profile.dart';
import 'home_page.dart';
import 'login.dart';
import 'model/model_user.dart';
import 'navigation_page.dart';
import 'order_screen.dart';
import 'package:http/http.dart' as http;

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreen();
}

class _FavouriteScreen extends State<FavouriteScreen> with WidgetsBindingObserver {
  late ModelUsers currentUser; // Nullable currentUser
  late Favourite favourite;

  int _selectedIndex = 1;
  List<Favourite> _favouriteList = [];
  List<Favourite> _filteredFavouriteList = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add the observer
    getDataSession();// Load session data when the widget initializes
    _fetchFavourite();
  }

  Future<void> _fetchFavourite() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.12/kelompok4/favourite.php?id_user=${sessionManager.id_user}'));
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        setState(() {
          _favouriteList = List<Favourite>.from(parsed['data'].map((x) => Favourite.fromJson(x)));
          _filteredFavouriteList = _favouriteList;
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
    WidgetsBinding.instance.removeObserver(this); // Remove the observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getDataSession();
    }
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

  Future<void> _deleteFavourite(String idFavourite) async {
    final String apiUrl = 'http://192.168.1.12/kelompok4//deleteFavourite.php';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {"id_favourite": idFavourite},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['isSuccess']) {
        setState(() {
          _fetchFavourite();
          // _keranjangList.removeAt(idKeranjang.toString() as int);
          // _filteredKeranjangList = List.from(_keranjangList);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      } else {
        throw Exception(responseData['message']);
      }
    } else {
      throw Exception('Failed to delete data');
    }
  }

  // void _deleteFavourite(Favourite favourite) {
  //   setState(() {
  //     _filteredFavouriteList.remove(favourite);
  //     _favouriteList.remove(favourite);
  //   });
  //   // Jika Anda memiliki operasi tambahan seperti menghapus dari database, tambahkan di sini
  // }


  void _filterFavouriteList(String query) {
    setState(() {
      _filteredFavouriteList = _favouriteList.where((favourite) => favourite.nama_produk.toLowerCase().contains(query.toLowerCase())).toList();
    });
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
      // Navigasi ke halaman Keranjang
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartScreen()),
        );
        break;
      case 2:
      // Navigasi ke halaman Pesanan
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
        // // Tambahkan logika logout
        //   setState(() {
        //     sessionManager.clearSession();
        //     Navigator.pushAndRemoveUntil(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) =>
        //               LoginScreen()),
        //           (route) => false,
        //     );
        //   });
        break;
      default:
    }
  }

  Future<void> _refreshData() async {
    // Simulate a long-running operation
    await Future.delayed(Duration(seconds: 2));

    // Fetch new data or update existing data
    // For example, you can fetch data from an API
    setState(() {
      getDataSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF87CEEB),
        title: Text('My Favourite'),
      ),
      backgroundColor: Color(0xFF87CEEB),
      body: _isLoading
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
                onChanged: _filterFavouriteList,
                decoration: InputDecoration(
                  labelText: 'Search Cart',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredFavouriteList.length,
                itemBuilder: (context, index) {
                  final favourite = _filteredFavouriteList[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                favourite.nama_produk,
                                style: TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteFavourite(favourite.id_favourite.toString()),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Harga:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Rp. ${favourite.harga.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Stok:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${favourite.stok}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Harga:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp. ${favourite.harga.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // body: SingleChildScrollView(
      //   child: Stack(
      //     children: [
      //       // Image.asset(
      //       //   'images/img2.png',
      //       //   fit: BoxFit.cover,
      //       //   height: MediaQuery.of(context).size.height,
      //       //   width: MediaQuery.of(context).size.width,
      //       // ),
      //       Padding(
      //         padding: const EdgeInsets.all(20.0),
      //         child: Column(
      //           children: [
      //             // SizedBox(
      //             //   height: 20,
      //             // ),
      //             // Padding(
      //             //   padding: const EdgeInsets.all(8.0),
      //             //   child: TextField(
      //             //     // controller: _searchController,
      //             //     // onChanged: _filterSejarawanList,
      //             //     decoration: InputDecoration(
      //             //       labelText: 'Search Cart',
      //             //       prefixIcon: Icon(Icons.search),
      //             //       border: OutlineInputBorder(),
      //             //     ),
      //             //   ),
      //             // ),
      //             Padding(
      //               padding: const EdgeInsets.only(bottom: 10),
      //               child: Container(
      //                 decoration: BoxDecoration(
      //                   color: Colors.white,
      //                   borderRadius: BorderRadius.circular(20),
      //                 ),
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.start,
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.all(12.0),
      //                       child: Row(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: [
      //                           Image.asset(
      //                             'images/img2.png',
      //                             width: 100,
      //                           ),
      //                           SizedBox(width: 20),
      //                           Expanded(
      //                             child: Column(
      //                               crossAxisAlignment: CrossAxisAlignment.start,
      //                               children: [
      //                                 Text(
      //                                   "Langit Biru",
      //                                   style: TextStyle(
      //                                     fontSize: 18,
      //                                     fontWeight: FontWeight.bold,
      //                                   ),
      //                                 ),
      //                                 Text(
      //                                   "Jumlah : 1",
      //                                   style: TextStyle(
      //                                     color: Colors.black,
      //                                     fontSize: 14,
      //                                   ),
      //                                 ),
      //                                 Text(
      //                                   "Rp. 87.000",
      //                                   style: TextStyle(
      //                                     color: Colors.black,
      //                                     fontSize: 14,
      //                                   ),
      //                                 ),
      //                                 SizedBox(height: 10), // Menambahkan spasi antara teks dan tombol
      //                                 Row(
      //                                   mainAxisAlignment: MainAxisAlignment.end,
      //                                   children: [
      //                                     // GestureDetector(
      //                                     //   onTap: () {
      //                                     //     Navigator.push(
      //                                     //       context,
      //                                     //       MaterialPageRoute(builder: (context) => CheckoutScreen()),
      //                                     //     );
      //                                     //   },
      //                                     //   child: Icon(
      //                                     //     Icons.edit,
      //                                     //     size: 20,
      //                                     //     color: Colors.blue,
      //                                     //   ),
      //                                     // ),
      //                                     // SizedBox(width: 10),
      //                                     GestureDetector(
      //                                       onTap: () {
      //                                         // Implementasi fungsi untuk tombol hapus
      //                                       },
      //                                       child: Icon(
      //                                         Icons.delete,
      //                                         color: Colors.red,
      //                                         size: 20,
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
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
