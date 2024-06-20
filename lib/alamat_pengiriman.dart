import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:project_ecommerce/checkout_screen.dart';
import 'package:project_ecommerce/detail_product.dart';
import 'package:project_ecommerce/model/model_addAlamatPengiriman.dart';
import 'package:project_ecommerce/profile.dart';
import 'package:project_ecommerce/utils/session_manager.dart';
import 'cart_screen.dart';
import 'edit_profile.dart';
import 'home_page.dart';
import 'login.dart';
import 'model/model_user.dart';
import 'order_screen.dart';
import 'package:http/http.dart' as http;

class AlamatPengiriman extends StatefulWidget {
  const AlamatPengiriman({Key? key}) : super(key: key);

  @override
  State<AlamatPengiriman> createState() => _AlamatPengiriman();
}

class _AlamatPengiriman extends State<AlamatPengiriman> with WidgetsBindingObserver {
  TextEditingController _nama = TextEditingController();
  TextEditingController _noHp = TextEditingController();
  TextEditingController _alamat = TextEditingController();
  TextEditingController _kodePos = TextEditingController();
  String? _name;
  late ModelUsers currentUser; // Nullable currentUser
  int _selectedIndex = 0;
  // late List<Datum> _sejarawanList;
  // late List<Datum> _filteredSejarawanList;
  late bool _isLoading;

  bool isLoading = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add the observer
    getDataSession();// Load session data when the widget initializes
    _isLoading = true;
    // _fetchSejarawan();
    // _filteredSejarawanList = [];
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    await sessionManager.getSession();
    setState(() {
      _userId = sessionManager.id_user;
    });
  }

  // Future<void> _fetchSejarawan() async {
  //   final response = await http
  //       .get(Uri.parse('http://192.168.1.12/kebudayaan/sejarawan.php'));
  //   if (response.statusCode == 200) {
  //     final parsed = jsonDecode(response.body);
  //     setState(() {
  //       _sejarawanList =
  //       List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
  //       _filteredSejarawanList = _sejarawanList;
  //       _isLoading = false;
  //     });
  //   } else {
  //     throw Exception('Failed to load pegawai');
  //   }
  // }
  //
  // void _filterSejarawanList(String query) {
  //   setState(() {
  //     _filteredSejarawanList = _sejarawanList
  //         .where((sejarawan) =>
  //     sejarawan.nama.toLowerCase().contains(query.toLowerCase()) ||
  //         sejarawan.asal.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   });
  // }

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
        // currentUser = ModelUsers(
        //   id_user: sessionManager.id_user!,
        //   username: sessionManager.username!,
        //   email: sessionManager.email!,
        //   no_hp: sessionManager.no_hp!,
        //   fullname: sessionManager.fullname!,
        //   alamat: sessionManager.alamat!,
        //   role: sessionManager.role!,
        //   jenis_kelamin: sessionManager.jenis_kelamin!,
        // );
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
          MaterialPageRoute(builder: (context) => HomePage()),
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

Future<void> addAlamatPengiriman() async {
  if (_nama.text.isEmpty || _noHp.text.isEmpty || _alamat.text.isEmpty || _kodePos.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Semua field harus diisi')),
    );
    return;
  }

  if (_userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User ID tidak ditemukan')),
    );
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    Uri uri = Uri.parse('http://192.168.1.12/kelompok4/addDeliveryAddress.php');

    http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..fields['id_user'] = _userId! // Menambahkan id_user
      ..fields['nama'] = _nama.text
      ..fields['no_hp'] = _noHp.text
      ..fields['kode_pos'] = _kodePos.text
      ..fields['alamat'] = _alamat.text; // set status

    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    print("Server response: $responseBody");

    if (response.statusCode == 200) {
      try {
        ModelAddAlamatPengiriman data = modelAddAlamatPengirimanFromJson(responseBody);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data.message}')),
        );
        if (data.isSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CartScreen()),
                (route) => false,
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to parse response: $e')),
        );
      }
    } else {
      throw Exception('Failed to upload data, status code: ${response.statusCode}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF87CEEB),
        title: Text('Alamat Pengiriman'),
      ),
      backgroundColor: Color(0xFF87CEEB),
        body: Form(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: 450,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              validator: (val) {
                                return val!.isEmpty
                                    ? "Name Tidak Boleh kosong"
                                    : null;
                              },
                              controller: _nama,
                              decoration: InputDecoration(
                                // fillColor: Colors.white.withOpacity(0.2),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                hintText: 'Name',
                                suffixIcon: _name != null && _name!.isNotEmpty
                                    ? Icon(Icons.check, color: Colors.blue)
                                    : null,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _name = value.trim();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 450,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              validator: (val) {
                                return val!.isEmpty
                                    ? "No HP Tidak Boleh kosong"
                                    : null;
                              },
                              controller: _noHp,
                              decoration: InputDecoration(
                                // fillColor: Colors.white.withOpacity(0.2),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                hintText: 'No HP',
                                suffixIcon: _name != null && _name!.isNotEmpty
                                    ? Icon(Icons.check, color: Colors.blue)
                                    : null,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _name = value.trim();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 450,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              validator: (val) {
                                return val!.isEmpty
                                    ? "Alamat Tidak Boleh kosong"
                                    : null;
                              },
                              controller: _alamat,
                              decoration: InputDecoration(
                                // fillColor: Colors.white.withOpacity(0.2),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                hintText: 'Alamat',
                                suffixIcon: _name != null && _name!.isNotEmpty
                                    ? Icon(Icons.check, color: Colors.blue)
                                    : null,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _name = value.trim();
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 450,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              validator: (val) {
                                return val!.isEmpty
                                    ? "Kode Pos Tidak Boleh kosong"
                                    : null;
                              },
                              controller: _kodePos,
                              decoration: InputDecoration(
                                // fillColor: Colors.white.withOpacity(0.2),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                hintText: 'Kode POS',
                                suffixIcon: _name != null && _name!.isNotEmpty
                                    ? Icon(Icons.check, color: Colors.blue)
                                    : null,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _name = value.trim();
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            width:
                            MediaQuery.of(context).size.width - (2 * 98),
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 7,
                                backgroundColor: Color(0xFF00BFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                addAlamatPengiriman();
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
