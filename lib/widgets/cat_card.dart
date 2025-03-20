import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../api/cat_api.dart';
import '../screens/detail_screen.dart';

class CatCard extends StatelessWidget {
  final Cat cat;

  const CatCard({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    final isSecretCat = cat.id == 'secret_cat';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(cat: cat),
        ),
      ),
      child: Card(
        elevation: isSecretCat ? 8.0 : 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSecretCat
              ? const BorderSide(color: Colors.amber, width: 2.0)
              : BorderSide.none,
        ),
        child: Column(
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: cat.url,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                cat.breedName ?? 'Unknown Breed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSecretCat ? Colors.amber : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
