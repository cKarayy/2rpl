class Item {
  final String id;          
  final String name;        
  final String type;        
  final double price;      
  final String details;     
  final double rating;     
  final String imageUrl;    

  Item({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.details,
    required this.rating,
    required this.imageUrl,
  });

  factory Item.fromFirestore(Map<String, dynamic> json, String docId) {
    return Item(
      id: docId,
      name: json['name'],
      type: json['type'],
      price: json['price'].toDouble(),
      details: json['details'],
      rating: json['rating'].toDouble(),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'type': type,
      'price': price,
      'details': details,
      'rating': rating,
      'imageUrl': imageUrl,
    };
  }
}
