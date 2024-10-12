import 'package:flutter/material.dart';
import 'package:cloud_firebase';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> bannerImages = [];
  List<Map<String, dynamic>> foodCategories = [];

  @override
  void initState() {
    super.initState();
    fetchBannerImages();
    fetchCategories();
  }

  // Fetch banner images from Firebase Storage
  void fetchBannerImages() async {
    final ListResult result = await FirebaseStorage.instance.ref('banners').listAll();
    final List<String> urls = await Future.wait(result.items.map((item) => item.getDownloadURL()).toList());
    setState(() {
      bannerImages = urls;
    });
  }

  // Fetch food categories from Firestore
  void fetchCategories() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('foodCategories').get();
    setState(() {
      foodCategories = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B3C3D),
      body: Column(
        children: [
          // Carousel slider for banner
          if (bannerImages.isNotEmpty)
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: bannerImages.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.network(imageUrl, fit: BoxFit.cover);
                  },
                );
              }).toList(),
            ),

          // Welcome section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Hi...',
                  style: TextStyle(
                    fontFamily: 'Calistoga',
                    color: Color(0xFFEEF0E5),
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 10),
                Image.asset('assets/images/logo.png', width: 100, height: 100),
              ],
            ),
          ),

          // Food categories
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemCount: foodCategories.length,
              itemBuilder: (context, index) {
                final category = foodCategories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CategoryPage(categoryName: category['name'])),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        category['name'],
                        style: TextStyle(
                          fontFamily: 'Calistoga',
                          color: Color(0xFF1B3C3D),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'My Order'),
        ],
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String categoryName;

  const CategoryPage({Key? key, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Center(
        child: Text('Displaying items for $categoryName'),
      ),
    );
  }
}
