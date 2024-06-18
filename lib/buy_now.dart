import 'package:flutter/material.dart';

class BuyNow extends StatelessWidget {
  int quantity = 1;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

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
                        '$quantity',
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
                  onPressed: () {
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
                      // Icon(Icons.shopping_cart, color: Colors.blue), // Mengubah warna ikon menjadi biru
                      SizedBox(width: 5), // Memberi jarak antara ikon dan teks
                      Text(
                        "buy now",
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

  void setState(Null Function() param0) {}
}
