import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryData {
  final String categoryName;
  final String categoryImageUrl;
  final String categoryDataTimeStamp;

  static CategoryData fromSnapshot(DocumentSnapshot snap) {
    CategoryData category = CategoryData(
        categoryName: snap['categoryName'],
        categoryImageUrl: snap['categoryImageUrl'],
        categoryDataTimeStamp: snap['categoryDataTimeStamp']);
    return category;
  }

  const CategoryData({
    required this.categoryName,
    required this.categoryImageUrl,
    required this.categoryDataTimeStamp,
  });

  factory CategoryData.fromMap(Map<dynamic, dynamic> map) {
    return CategoryData(
      categoryName: map['categoryName'] ?? '',
      categoryImageUrl: map['categoryImageUrl'] ?? '',
      categoryDataTimeStamp: map['categoryDataTimeStamp'] ?? ''
    );
  }
}
