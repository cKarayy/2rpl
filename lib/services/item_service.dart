import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testt/models/item.dart';  

class FoodItemService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final CollectionReference _itemsCollection =
      _firestore.collection('items');

  // Nama koleksi di Firestore
  final String collectionName = 'foodItems';

  // Method untuk menambahkan FoodItem baru ke Firestore
  Future<void> addFoodItem(Item menuItem) async {
    try {
      await _firestore.collection(collectionName).add(menuItem.toFirestore());
      print('Menu item added successfully');
    } catch (e) {
      print('Error adding food item: $e');
    }
  }

  // Method untuk memperbarui FoodItem di Firestore
  Future<void> updateFoodItem(Item menuItem) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(menuItem.id)
          .update(menuItem.toFirestore());
      print('Food item updated successfully');
    } catch (e) {
      print('Error updating food item: $e');
    }
  }

  // Method untuk menghapus FoodItem dari Firestore
  Future<void> deleteFoodItem(String menuItemId) async {
    try {
      await _firestore.collection(collectionName).doc(menuItemId).delete();
      print('Menu item deleted successfully');
    } catch (e) {
      print('Error deleting food item: $e');
    }
  }

  static Future<List<Item>> searchFoodItems({required String query}) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('items')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    return querySnapshot.docs
        .map((doc) => Item.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  static Future<String> uploadImage(File image) async {
    try {
      // Mendapatkan nama file
      String fileName = path.basename(image.path);
      
      // Membuat referensi ke Firebase Storage
      Reference storageRef = _storage.ref().child('food_images/$fileName');
      
      // Upload file gambar ke Firebase Storage
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      
      // Mengembalikan URL download gambar
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  // Method untuk mengambil daftar semua FoodItems dari Firestore
  Future<List<Item>> getAllFoodItems() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(collectionName).get();
      return querySnapshot.docs.map((doc) {
        return Item.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching food items: $e');
      return [];
    }
  }

  // Method untuk mengambil FoodItem berdasarkan ID
  Future<Item?> getFoodItemById(String foodItemId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collectionName).doc(foodItemId).get();
      if (doc.exists) {
        return Item.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        print('Food item not found');
        return null;
      }
    } catch (e) {
      print('Error fetching food item: $e');
      return null;
    }
  }
}
