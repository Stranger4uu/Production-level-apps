class FoodItem {
  final String id;
  final String name;
  final String imageUrl;

  FoodItem({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory FoodItem.fromMap(String id, Map<String, dynamic> data) {
    return FoodItem(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}