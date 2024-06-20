import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ecommerce/model/model_keranjang.dart';
import 'package:project_ecommerce/profile.dart';
import 'package:project_ecommerce/utils/session_manager.dart';
import 'checkout_screen.dart';
import 'model/model_user.dart';
import 'navigation_page.dart';
import 'order_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  // final ModelKeranjang keranjang;
  //
  // const CartScreen({Key? key, required this.keranjang})
  //     : super(key: key);


  @override
  State<CartScreen> createState() => _CartScreen();
}

class _CartScreen extends State<CartScreen> with WidgetsBindingObserver {
  late ModelUsers currentUser;
  late Keranjang keranjang;

  int _selectedIndex = 1;
  List<Keranjang> _keranjangList = [];
  List<Keranjang> _filteredKeranjangList = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getDataSession();
    _fetchKeranjang();
  }

  Future<void> _fetchKeranjang() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.12/kelompok4/listKeranjang.php?id_user=${sessionManager.id_user}'));
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        setState(() {
          _keranjangList = List<Keranjang>.from(parsed['data'].map((x) => Keranjang.fromJson(x)));
          _filteredKeranjangList = _keranjangList;
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

  Future<void> deleteKeranjang(String idKeranjang) async {
    final String apiUrl = 'http://192.168.1.12/kelompok4/deleteKeranjang.php';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {"id_keranjang": idKeranjang},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['isSuccess']) {
        setState(() {
          _fetchKeranjang();
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

  // Future<void> deleteKeranjang(String id_keranjang) async {
  //   final url = Uri.parse('http://192.168.1.12/kelompok4/deleteKeranjang.php');
  //   final body = {'id_keranjang': id_keranjang}; // Ensure 'idKeranjang' is populated
  //
  //   final response = await http.post(url, body: jsonEncode(body));
  //
  //   if (response.statusCode == 200) {
  //     print('Produk data for category $id_keranjang deleted successfully.');
  //     // Update your UI to reflect the deletion (e.g., remove deleted products from lists)
  //   } else {
  //     print('Error deleting produk data: ${response.statusCode}');
  //     // Handle errors (e.g., show a toast message to the user)
  //   }
  // }

  void _filterKeranjangList(String query) {
    setState(() {
      _filteredKeranjangList = _keranjangList.where((keranjang) => keranjang.nama_produk.toLowerCase().contains(query.toLowerCase())).toList();
    });
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CartScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrderScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
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
        title: Text('Keranjang Saya'),
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
                onChanged: _filterKeranjangList,
                decoration: InputDecoration(
                  labelText: 'Search Cart',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredKeranjangList.length,
                itemBuilder: (context, index) {
                  final keranjang = _filteredKeranjangList[index];
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
                                keranjang.nama_produk,
                                style: TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                onPressed: () => deleteKeranjang(keranjang.id_keranjang.toString()),
                                    ),
                                    // Icon(
                              //   Icons.close,
                              //   size: 20,
                              //   color: Colors.red,
                              // ),
                            ],
                          ),
                          // Text(
                          //   keranjang.nama_produk,
                          //   style: TextStyle(
                          //     fontSize: 18,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Harga:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Rp. ${keranjang.harga.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Jumlah:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${keranjang.jumlah}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp. ${keranjang.subtotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CheckoutScreen(data: keranjang)),
                                        );
                                      },
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CheckoutScreen(data: keranjang)),
                                          );
                                        },
                                        child: Text('Checkout'),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     // Implementasi fungsi untuk tombol hapus
                                    //   },
                                    //   child: Icon(
                                    //     Icons.delete,
                                    //     color: Colors.red,
                                    //     size: 20,
                                    //   ),
                                    // ),
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
