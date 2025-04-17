import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/cat.dart';
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
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 300,
          ),
          child: Column(
            children: [
              Expanded(
                child: Hero(
                  tag: 'cat-${cat.id}',
                  child: CachedNetworkImage(
                    imageUrl: cat.url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 48),
                          const SizedBox(height: 8),
                          Text(
                            'Не удалось загрузить кота',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () =>
                                (context as Element).markNeedsBuild(),
                            child: const Text('Повторить'),
                          ),
                        ],
                      ),
                    ),
                  ),
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
      ),
    );
  }
}
