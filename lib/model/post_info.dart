import 'package:flutter/material.dart';

class PostInfo {
  final String title;
  final String imageUrl;
  String description;

  PostInfo(
      {required this.title, required this.imageUrl, required this.description});

  factory PostInfo.fromMap(dynamic x) {
    return PostInfo(
        title: x['title'],
        imageUrl: x['imageUrl'],
        description: x['description']);
  }
}
