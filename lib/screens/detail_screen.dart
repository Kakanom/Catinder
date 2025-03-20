import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../api/cat_api.dart';

class DetailScreen extends StatelessWidget {
  final Cat cat;

  const DetailScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cat.breedName ?? 'Cat Details')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(imageUrl: cat.url),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                cat.breedDescription ?? 'No description available',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
