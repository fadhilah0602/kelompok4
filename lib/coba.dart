// import 'dart:async';
//
// import 'package:app_kosmetik/PageDetailProduk.dart';
// import 'package:app_kosmetik/PageListCart.dart';
// import 'package:app_kosmetik/models/ModelCategory.dart';
// import 'package:app_kosmetik/models/ModelProduk.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// class PageMulai extends StatefulWidget {
//   final PageController pageController;
//
//   const PageMulai({required this.pageController, Key? key}) : super(key: key);
//
//   @override
//   State<PageMulai> createState() => _PageMulaiState();
// }
//
// class _PageMulaiState extends State<PageMulai> with TickerProviderStateMixin {
//   String? userFirst;
//   String? userLast;
//   // String? userFull;
//   String? userEmail;
//   late Timer _timer;
//   List<Category> _categories = [];
//   List<Datum> _products = [];
//   int _selectedCategoryIndex = -1;
//   late TextEditingController _searchController;
//
//   int _currentPage = 0;
//
//   Future<bool> _checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool? isLoggedIn = prefs.getBool('isLoggedIn');
//     return isLoggedIn ?? false;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//     getUsername();
//     startTimer();
//     widget.pageController.addListener(_handlePageChange);
//     fetchProducts();
//     fetchCategories();
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     _searchController.dispose();
//     widget.pageController.removeListener(_handlePageChange);
//     super.dispose();
//   }
//
//   void startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 3), (timer) {
//       widget.pageController.nextPage(
//         duration: Duration(milliseconds: 500),
//         curve: Curves.ease,
//       );
//     });
//   }
//
//   void _handlePageChange() {
//     if (widget.pageController.page == 2) {
//       Future.delayed(Duration(seconds: 3), () {
//         if (widget.pageController.hasClients) {
//           widget.pageController.jumpToPage(0);
//         }
//       });
//     }
//   }
//
//   // filter kategori
//   // void _onCategoryTabSelected(int index) {
//   //   setState(() {
//   //     if (index == 0) {
//   //       _selectedCategoryIndex =
//   //           -1; // Mengatur indeks kategori menjadi -1 untuk "All"
//   //     } else {
//   //       _selectedCategoryIndex =
//   //           index - 1; // Mengurangi 1 untuk kategori aktual
//   //     }
//   //     fetchProducts(); // Memuat ulang produk saat kategori berubah
//   //   });
//   // }
//
//   // filter search
//   void _filterProducts(String query) {
//     if (query.isEmpty) {
//       //menampilkan semua produk jika tidak melakukan pencarian
//       fetchProducts();
//       return;
//     }
//
//     String lowerCaseQuery = query.toLowerCase();
//
//     setState(() {
//       _products = _products
//           .where((product) => product.productName.toLowerCase().contains(lowerCaseQuery))
//           .toList();
//     });
//   }
//
//   void _onCategoryTabSelected(int index) {
//     setState(() {
//       _selectedCategoryIndex = index == 0 ? -1 : index - 1;
//     });
//     fetchProducts(); // Memuat ulang produk saat kategori berubah
//   }
//
//   Future<void> getUsername() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userFirst = prefs.getString('first_name') ?? '';
//       userLast = prefs.getString('last_name') ?? '';
//       userEmail = prefs.getString('email');
//     });
//   }
//
//   Future<void> fetchProducts() async {
//     try {
//       http.Response res =
//       await http.get(Uri.parse('http://127.0.0.1:8000/api/produk'));
//       if (res.statusCode == 200) {
//         List<Datum> allProducts = modelProdukFromJson(res.body).data;
//         // Filter produk berdasarkan kategori yang dipilih
//         _products = _selectedCategoryIndex == -1
//             ? allProducts // Jika kategori "All" dipilih, tampilkan semua produk
//             : allProducts
//             .where((product) =>
//         product.categoryId ==
//             _categories[_selectedCategoryIndex].id)
//             .toList();
//         setState(() {});
//       } else {
//         throw Exception('Failed to load products: ${res.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching products: $e');
//       setState(() {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(e.toString())));
//       });
//     }
//   }
//
//   // Future<List<Datum>?> fetchProducts() async {
//   //   try {
//   //     http.Response res =
//   //         await http.get(Uri.parse('http://127.0.0.1:8000/api/produk'));
//   //     if (res.statusCode == 200) {
//   //       setState(() {
//   //         _products = modelProdukFromJson(res.body).data;
//   //       });
//   //     } else {
//   //       throw Exception('Failed to load products: ${res.statusCode}');
//   //     }
//   //   } catch (e) {
//   //     print('Error fetching products: $e');
//   //     setState(() {
//   //       ScaffoldMessenger.of(context)
//   //           .showSnackBar(SnackBar(content: Text(e.toString())));
//   //     });
//   //   }
//   // }
//
//   Future<void> fetchCategories() async {
//     try {
//       http.Response res =
//       await http.get(Uri.parse('http://127.0.0.1:8000/api/category'));
//       setState(() {
//         _categories = modelCategoryFromJson(res.body).categories ?? [];
//       });
//     } catch (e) {
//       setState(() {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(e.toString())));
//       });
//     }
//   }
//
//   String capitalize(String s) {
//     if (s.isEmpty) return s;
//     return s[0].toUpperCase() + s.substring(1);
//   }
//
//   String? getCategoryName(int categoryId) {
//     final category = _categories.firstWhere(
//           (cat) => cat.id == categoryId,
//       orElse: () => Category(
//           id: -1,
//           categoryName: 'Unknown',
//           description: 'No description available',
//           createdAt: DateTime(1970, 1, 1),
//           updatedAt: DateTime(1970, 1, 1)),
//     );
//     return category.categoryName != 'Unknown' ? category.categoryName : null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         // toolbarHeight: 20,
//         // backgroundColor: Color(0xFFE6E6E6),
//         backgroundColor: Colors.white,
//         title: Text(
//           'Enchanté Beauty',
//           style: TextStyle(
//             color: Color(0xFF424252),
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PageListCart(),
//                 ),
//               );
//             },
//             icon: Container(
//               child: Icon(
//                 Icons.shopping_cart,
//                 color: Color(0xFF424252),
//               ),
//             ),
//           ),
//         ],
//       ),
//       // resizeToAvoidBottomInset: false,
//       body: SingleChildScrollView(
//         child: Container(
//           height: 1500,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFFE6E6E6), // Warna utama di tengah
//                 Color(0xFFE6E6E6), // Warna transparan di pinggir
//                 Color(0xFFE6E6E6), // Warna transparan di pinggir
//                 Color(0xFFE6E6E6), // Warna utama di tengah
//               ],
//               stops: [
//                 0.1,
//                 0.4,
//                 0.6,
//                 0.9
//               ], // Menentukan ukuran masing-masing warna
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: SafeArea(
//             child: Column(
//               children: [
//                 // Slider
//                 Container(
//                   height: 200,
//                   child: PageView(
//                     controller: widget.pageController,
//                     onPageChanged: (int page) {
//                       setState(() {
//                         _currentPage = page;
//                       });
//                       print("Page changed to: $page");
//                     },
//                     physics: AlwaysScrollableScrollPhysics(),
//                     children: [
//                       Image.network(
//                         'https://goodstats.id/img/articles/original/2022/09/15/7-merek-kosmetik-lokal-paling-banyak-digunakan-di-indonesia-2022-ccBqp8iCKF.jpg?p=articles-lg',
//                         fit: BoxFit.cover,
//                       ),
//                       Image.network(
//                         'https://images.tokopedia.net/blog-tokopedia-com/uploads/2020/08/Featured_Merk-Kosmetik-Lokal.jpg',
//                         fit: BoxFit.cover,
//                       ),
//                       Image.network(
//                         'https://asset.kompas.com/crops/K06M4do5yUPjJOP5CkYe2aITo5w=/0x0:1999x1333/1200x800/data/photo/2019/06/12/3246172269.jpg',
//                         fit: BoxFit.cover,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 //search
//                 Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextField(
//                         controller: _searchController,
//                         onChanged: (value) {
//                           _filterProducts(value);
//                         },
//                         decoration: InputDecoration(
//                           labelText: 'Search',
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(
//                                 10.0), // Set border radius here
//                             borderSide: BorderSide(color: Color(0xFFE6E6E6)),
//                           ),
//                           prefixIcon: Icon(
//                               Icons.search), // Icon on the left side of input
//                         ),
//                       ),
//                     ),
//
//                     // Expanded(
//                     //   child: ListView.builder(
//                     //     itemCount: _filteredBudayaList.length,
//                     //     itemBuilder: (context, index) {
//                     //       return Card(
//                     //         child: ListTile(
//                     //           title: Text(
//                     //             _filteredBudayaList[index]['judul'],
//                     //             style: TextStyle(
//                     //                 color: Color.fromARGB(255, 74, 48, 0)),
//                     //           ),
//                     //           onTap: () => _navigateToDetail(
//                     //               _filteredBudayaList[
//                     //                   index]), // Tambahkan fungsi onTap di sini
//                     //         ),
//                     //       );
//                     //     },
//                     //   ),
//                     // ),
//                   ],
//                 ),
//
//                 SizedBox(height: 16),
//
//                 // Tab Bar
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Category',
//                         style: TextStyle(
//                           color: Color(0xFF424252),
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       // GestureDetector(
//                       //   onTap: () {
//                       //     // Handle view all action here
//                       //   },
//                       //   child: Text(
//                       //     'View All',
//                       //     style: TextStyle(
//                       //       color: Colors.blue,
//                       //       fontSize: 14,
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//
//                 _categories.isEmpty
//                     ? CircularProgressIndicator() // Show loading indicator while fetching data
//                     : DefaultTabController(
//                   length: _categories.length + 1,
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding:
//                         const EdgeInsets.only(left: 8.0, right: 8.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: TabBar(
//                             isScrollable: true,
//                             unselectedLabelColor: Color(0xFF424252),
//                             labelColor: Colors.purple,
//                             labelStyle: TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                             unselectedLabelStyle: TextStyle(
//                               fontWeight: FontWeight.normal,
//                             ),
//                             // indicator: BoxDecoration(
//                             //   color: Color(0xFF424252).withOpacity(0.4),
//                             // ),
//                             tabs: [
//                               Tab(
//                                   text:
//                                   'All'), // Tab baru untuk menampilkan semua produk
//                               ..._categories.map((category) =>
//                                   Tab(text: category.categoryName)),
//                             ],
//                             // tabs: _categories
//                             //     .map((category) => Tab(
//                             //           text: category.categoryName,
//                             //         ))
//                             //     .toList(),
//                             onTap: _onCategoryTabSelected,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       // Tab Bar View
//                       // Padding(
//                       //   padding:
//                       //       const EdgeInsets.only(left: 8.0, right: 8.0),
//                       //   child: Container(
//                       //     height: 100,
//                       //     child: TabBarView(
//                       //       children: _categories
//                       //           .map((category) => Container(
//                       //                 color: Colors.white,
//                       //                 child: Center(
//                       //                   child: Text(
//                       //                     category.categoryName,
//                       //                     style: TextStyle(
//                       //                       color: Color(0xFF424252),
//                       //                       fontSize: 24,
//                       //                     ),
//                       //                   ),
//                       //                 ),
//                       //               ))
//                       //           .toList(),
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//
//                 // produk
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Product',
//                         style: TextStyle(
//                           color: Color(0xFF424252),
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       // GestureDetector(
//                       //   onTap: () {
//                       //     // Handle view all action here
//                       //   },
//                       //   child: Text(
//                       //     'View All',
//                       //     style: TextStyle(
//                       //       color: Colors.blue,
//                       //       fontSize: 14,
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//
//                 // list produk
//                 _products.isEmpty
//                     ? Center(
//                   child: Text(
//                     'No Products Available',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 )
//                     : Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: GridView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                     SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2, // item perbaris
//                       crossAxisSpacing: 10, //horizontal space between
//                       mainAxisSpacing: 10, //vertical space between
//                       childAspectRatio: 1, //height
//                     ),
//                     itemCount: _products.length,
//                     itemBuilder: (context, index) {
//                       final product = _products[index];
//                       final categoryName =
//                           getCategoryName(product.categoryId) ??
//                               'Unknown';
//
//                       // Filter produk sesuai dengan kategori yang dipilih
//                       if (_selectedCategoryIndex != -1 &&
//                           product.categoryId !=
//                               _categories[_selectedCategoryIndex].id) {
//                         return Container(); // Jika bukan kategori yang dipilih, tampilkan kontainer kosong
//                       }
//                       return InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   PageDetailProduk(product: product),
//                             ),
//                           );
//                         },
//                         child: Card(
//                           margin: EdgeInsets.all(0),
//                           color: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           elevation: 4,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.vertical(
//                                   top: Radius.circular(10),
//                                 ),
//                                 child: Image.network(
//                                   // product.image,
//                                   'http://127.0.0.1:8000/image/${product.image}',
//                                   height: 150,
//                                   width: double.infinity,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 8.0, right: 8.0, top: 8.0),
//                                 child: Text(
//                                   // capitalize(product.productName),
//                                   capitalize('$categoryName'),
//                                   style: TextStyle(
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 8.0,
//                                     right: 8.0,
//                                     top: 1.0,
//                                     bottom: 8.0),
//                                 child: Text(
//                                   capitalize(product.productName),
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 8.0),
//                                     child: Text(
//                                       'Rp. ${product.price}',
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         color: Colors.red,
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 8.0),
//                                     child: Text(
//                                       'Stock : ${product.stock}',
//                                       style: TextStyle(
//                                         fontSize: 11,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_ecommerce/detail_product.dart';
import 'package:project_ecommerce/model/model_kategori.dart';
import 'package:project_ecommerce/profile.dart';
import 'package:project_ecommerce/utils/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'cart_screen.dart';
import 'favourite_screen.dart';
import 'home_page.dart';
import 'login.dart';
import 'model/model_produk.dart';
import 'model/model_user.dart';
import 'order_screen.dart';

class PageMulai extends StatefulWidget {
  final PageController pageController;

  PageMulai({Key? key, required this.pageController}) : super(key: key);

  // const PageMulai({Key? key}) : super(key: key);

  @override
  State<PageMulai> createState() => _PageMulaiState();
}

class _PageMulaiState extends State<PageMulai> with TickerProviderStateMixin {
  String? userFirst;
  String? userLast;
  // String? userFull;
  String? userEmail;
  late Timer _timer;
  List<Kategori> _categories = [];
  List<Produk> _products = [];
  int _selectedCategoryIndex = -1;
  late TextEditingController _searchController;
  int _selectedIndex = 0;
  late ModelUsers currentUser;

  int _currentPage = 0;
  bool _isFavorite = false;

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    return isLoggedIn ?? false;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    getUsername();
    startTimer();
    widget.pageController.addListener(_handlePageChange);
    fetchProducts();
    fetchCategories();
    getDataSession();
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

  @override
  void dispose() {
    _timer.cancel();
    _searchController.dispose();
    widget.pageController.removeListener(_handlePageChange);
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      widget.pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  void _handlePageChange() {
    if (widget.pageController.page == 2) {
      Future.delayed(Duration(seconds: 3), () {
        if (widget.pageController.hasClients) {
          widget.pageController.jumpToPage(0);
        }
      });
    }
  }

  // filter kategori
  void _onCategoryTabSelected(int index) {
    setState(() {
      if (index == 0) {
        _selectedCategoryIndex =
            -1; // Mengatur indeks kategori menjadi -1 untuk "All"
      } else {
        _selectedCategoryIndex =
            index - 1; // Mengurangi 1 untuk kategori aktual
      }
      fetchProducts(); // Memuat ulang produk saat kategori berubah
    });
  }

  // filter search
  void _filterProducts(String query) {
    if (query.isEmpty) {
      //menampilkan semua produk jika tidak melakukan pencarian
      fetchProducts();
      return;
    }

    String lowerCaseQuery = query.toLowerCase();

    setState(() {
      _products = _products
          .where((product) => product.nama_produk.toLowerCase().contains(lowerCaseQuery))
          .toList();
    });
  }

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userFirst = prefs.getString('first_name') ?? '';
      userLast = prefs.getString('last_name') ?? '';
      userEmail = prefs.getString('email');
    });
  }

  Future<void> fetchProducts() async {
    try {
      http.Response res =
      await http.get(Uri.parse('http://192.168.1.12/kelompok4/produk1.php'));
      if (res.statusCode == 200) {
        List<Produk> allProducts = modelProdukFromJson(res.body).data;
        // Filter produk berdasarkan kategori yang dipilih
        _products = _selectedCategoryIndex == -1
            ? allProducts // Jika kategori "All" dipilih, tampilkan semua produk
            : allProducts
            .where((product) =>
        product.id_kategori ==
            _categories[_selectedCategoryIndex].id_kategori)
            .toList();
        setState(() {});
      } else {
        throw Exception('Failed to load products: ${res.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  Future<void> fetchCategories() async {
    try {
      http.Response res =
      await http.get(Uri.parse('http://192.168.1.12/kelompok4/kategori.php'));
      setState(() {
        _categories = modelKategoriFromJson(res.body).data ?? [];
      });
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  String? getCategoryName(String categoryId) {
    final category = _categories.firstWhere(
          (cat) => cat.id_kategori == categoryId,
      orElse: () => Kategori(
          id_kategori: "-1",
          kategori: 'Unknown'),
    );
    return category.kategori != 'Unknown' ? category.kategori : null;
  }

  // Future<void> _toggleFavorite() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> favoriteProductIds =
  //       prefs.getStringList('favoriteProducts') ?? [];
  //   if (_isFavorite) {
  //     favoriteProductIds.remove(widget._products.id_produk);
  //   } else {
  //     favoriteProductIds.add(widget.product.id_produk);
  //   }
  //   await prefs.setStringList('favoriteProducts', favoriteProductIds);
  //   setState(() {
  //     _isFavorite = !_isFavorite;
  //   });
  // }

  // Future<void> _checkIfFavorite() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> favoriteProductIds =
  //       prefs.getStringList('favoriteProducts') ?? [];
  //   setState(() {
  //     _isFavorite = favoriteProductIds.contains(widget.product.id.toString());
  //   });
  // }

  // Future<void> _fetchKategori() async {
  //   final response =
  //   await http.get(Uri.parse('http://192.168.42.233/kelompok4/kategori.php'));
  //   if (response.statusCode == 200) {
  //     final parsed = jsonDecode(response.body);
  //     setState(() {
  //       _kategoriList =
  //       List<Kategori>.from(parsed['data'].map((x) => Kategori.fromJson(x)));
  //       _filteredKategoriList = _kategoriList;
  //       _isLoading = false;
  //     });
  //   } else {
  //     throw Exception('Failed to load kategori');
  //   }
  // }

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
      // Navigasi ke halaman Pesanan
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavouriteScreen()),
        );
        break;
      case 4:

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(currentUser: currentUser)),
        );
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // toolbarHeight: 20,
        // backgroundColor: Color(0xFFE6E6E6),
        backgroundColor: Color(0xFF00BFFF),
        title: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.only(top: 40, left: 50),
            //   child: Expanded(
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           'Welcome, ${currentUser!.fullname}',
            //           style: TextStyle(
            //             color: Colors.white,
            //           ),
            //         ),
            //         Text(
            //           "Find Your Book",
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             color: Colors.white,
            //             fontSize: 20,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => PageListCart(),
          //       ),
          //     );
          //   },
          //   icon: Container(
          //     child: Icon(
          //       Icons.shopping_cart,
          //       color: Color(0xFF424252),
          //     ),
          //   ),
          // ),
          Text(
            'Welcome, ${currentUser!.fullname}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen()));
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      backgroundColor: Color(0xFFADD8E6),
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: 1500,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE6E6E6), // Warna utama di tengah
                Color(0xFFE6E6E6), // Warna transparan di pinggir
                Color(0xFFE6E6E6), // Warna transparan di pinggir
                Color(0xFFE6E6E6), // Warna utama di tengah
              ],
              stops: [
                0.1,
                0.4,
                0.6,
                0.9
              ], // Menentukan ukuran masing-masing warna
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Slider
                // Container(
                //   height: 200,
                //   child: PageView(
                //     controller: widget.pageController,
                //     onPageChanged: (int page) {
                //       setState(() {
                //         _currentPage = page;
                //       });
                //       print("Page changed to: $page");
                //     },
                //     physics: AlwaysScrollableScrollPhysics(),
                //     children: [
                //       Image.network(
                //         'https://goodstats.id/img/articles/original/2022/09/15/7-merek-kosmetik-lokal-paling-banyak-digunakan-di-indonesia-2022-ccBqp8iCKF.jpg?p=articles-lg',
                //         fit: BoxFit.cover,
                //       ),
                //       Image.network(
                //         'https://images.tokopedia.net/blog-tokopedia-com/uploads/2020/08/Featured_Merk-Kosmetik-Lokal.jpg',
                //         fit: BoxFit.cover,
                //       ),
                //       Image.network(
                //         'https://asset.kompas.com/crops/K06M4do5yUPjJOP5CkYe2aITo5w=/0x0:1999x1333/1200x800/data/photo/2019/06/12/3246172269.jpg',
                //         fit: BoxFit.cover,
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 16),
                //search
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          _filterProducts(value);
                        },
                        decoration: InputDecoration(
                          labelText: 'Search',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Set border radius here
                            borderSide: BorderSide(color: Color(0xFFE6E6E6)),
                          ),
                          prefixIcon: Icon(
                              Icons.search), // Icon on the left side of input
                        ),
                      ),
                    ),

                    // Expanded(
                    //   child: ListView.builder(
                    //     itemCount: _filteredBudayaList.length,
                    //     itemBuilder: (context, index) {
                    //       return Card(
                    //         child: ListTile(
                    //           title: Text(
                    //             _filteredBudayaList[index]['judul'],
                    //             style: TextStyle(
                    //                 color: Color.fromARGB(255, 74, 48, 0)),
                    //           ),
                    //           onTap: () => _navigateToDetail(
                    //               _filteredBudayaList[
                    //                   index]), // Tambahkan fungsi onTap di sini
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),

                SizedBox(height: 16),

                // Tab Bar
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Category',
                        style: TextStyle(
                          color: Color(0xFF424252),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     // Handle view all action here
                      //   },
                      //   child: Text(
                      //     'View All',
                      //     style: TextStyle(
                      //       color: Colors.blue,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),

                _categories.isEmpty
                    ? CircularProgressIndicator() // Show loading indicator while fetching data
                    : DefaultTabController(
                  length: _categories.length + 1,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TabBar(
                            isScrollable: true,
                            unselectedLabelColor: Color(0xFF424252),
                            labelColor: Colors.purple,
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                            // indicator: BoxDecoration(
                            //   color: Color(0xFF424252).withOpacity(0.4),
                            // ),
                            tabs: [
                              Tab(
                                  text:
                                  'All'), // Tab baru untuk menampilkan semua produk
                              ..._categories.map((category) =>
                                  Tab(text: category.kategori)),
                            ],
                            // tabs: _categories
                            //     .map((category) => Tab(
                            //           text: category.categoryName,
                            //         ))
                            //     .toList(),
                            onTap: _onCategoryTabSelected,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Tab Bar View
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.only(left: 8.0, right: 8.0),
                      //   child: Container(
                      //     height: 100,
                      //     child: TabBarView(
                      //       children: _categories
                      //           .map((category) => Container(
                      //                 color: Colors.white,
                      //                 child: Center(
                      //                   child: Text(
                      //                     category.categoryName,
                      //                     style: TextStyle(
                      //                       color: Color(0xFF424252),
                      //                       fontSize: 24,
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ))
                      //           .toList(),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),

                // produk
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product',
                        style: TextStyle(
                          color: Color(0xFF424252),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     // Handle view all action here
                      //   },
                      //   child: Text(
                      //     'View All',
                      //     style: TextStyle(
                      //       color: Colors.blue,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),

                // list produk
                _products.isEmpty
                    ? Center(
                  child: Text(
                    'No Products Available',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // item perbaris
                      crossAxisSpacing: 10, //horizontal space between
                      mainAxisSpacing: 10, //vertical space between
                      childAspectRatio: 1, //height
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      final categoryName =
                          getCategoryName(product.id_produk) ??
                              'Unknown';

                      // Filter produk sesuai dengan kategori yang dipilih
                      if (_selectedCategoryIndex != -1 &&
                          product.id_kategori !=
                              _categories[_selectedCategoryIndex].id_kategori) {
                        return Container(); // Jika bukan kategori yang dipilih, tampilkan kontainer kosong
                      }
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailProduct(data:  product),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.all(0),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                                child: Image.network(
                                  // product.image,
                                  'http://192.168.1.12/kelompok4/${product.gambar}',
                                  height:150,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 8.0),
                                // child: Text(
                                //   // capitalize(product.productName),
                                //   capitalize('$product.'),
                                //   style: TextStyle(
                                //     fontSize: 11,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                    top: 1.0,
                                    bottom: 8.0),
                                child: Text(
                                  capitalize(product.nama_produk),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      'Rp. ${product.harga}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      'Stock : ${product.stok}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isFavorite = !_isFavorite;
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Positioned(
                                          top: 16,
                                          right: 16,
                                          child: Icon(
                                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                                            color: _isFavorite ? Colors.red : Colors.white,
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
                      );
                    },
                  ),
                ),
              ],
            ),
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
            icon: Icon(Icons.favorite),
            label: 'Favourite',
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

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:project_ecommerce/utils/session_manager.dart';
//
// import 'model/model_produk.dart';
// import 'model/model_user.dart';
//
// class HomePageCoba extends StatefulWidget {
//   @override
//   _HomePageCobaState createState() => _HomePageCobaState();
// }
//
// class _HomePageCobaState extends State<HomePageCoba> {
//   List<Produk> _produkList = [];
//   bool _isLoading = true;
//   bool isLoved = false;
//   late ModelUsers currentUser;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProduk();
//     getDataSession();
//   }
//
//   Future<void> fetchProduk() async {
//     final response = await http.get(Uri.parse('http://192.168.42.233/kelompok4/produk.php'));
//     if (response.statusCode == 200) {
//       List<dynamic> body = jsonDecode(response.body)['data'];
//       setState(() {
//         _produkList = body.map((dynamic item) => Produk.fromJson(item)).toList();
//         _isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to load produk');
//     }
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Produk berdasarkan Kategori'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: 180),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               width: 300,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   _buildKategoriItem('Dongeng'),
//                   SizedBox(width: 20),
//                   _buildKategoriItem('Biografi'),
//                   SizedBox(width: 20),
//                   _buildKategoriItem('Pelajaran'),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               width: 300,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   _buildKategoriItem('Komik'),
//                   SizedBox(width: 20),
//                   _buildKategoriItem('Cerita Pendek'),
//                   SizedBox(width: 20),
//                   _buildKategoriItem('Novel'),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           GridView.builder(
//             shrinkWrap: true,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               childAspectRatio: 0.7,
//             ),
//             itemCount: _produkList.length,
//             itemBuilder: (context, index) {
//               return _buildProdukItem(_produkList[index]);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildKategoriItem(String kategori) {
//     return Container(
//       height: 60,
//       width: 80,
//       decoration: BoxDecoration(
//         color: Color(0xFFADD8E6),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(5.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               kategori,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProdukItem(Produk produk) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           // Toggle favorite status
//           isLoved = !isLoved;
//         });
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 190, top: 10),
//             // child: Icon(CupertinoIcons.heart_fill, color: Colors.red,),
//           ),
//           GestureDetector(
//             onTap: () {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (context) => DetailProduct(produk: produk),
//               //   ),
//               // );
//             },
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Image.network(
//                   produk.gambar,
//                   width: 100,
//                   height: 100,
//                   fit: BoxFit.cover,
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   produk.nama_produk,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   "Rp. ${produk.harga}",
//                   style: TextStyle(
//                     color: Colors.blue,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 16,
//             right: 16,
//             child: Icon(
//               isLoved ? Icons.favorite : Icons.favorite_border,
//               color: isLoved ? Colors.red : Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
