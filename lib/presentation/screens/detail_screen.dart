import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/cat.dart';

class DetailScreen extends StatelessWidget {
  final Cat cat;

  const DetailScreen({super.key, required this.cat});

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _shareCat() async {
    await Share.share(
      'Look at this beautiful ${cat.breedName ?? "cat"}!\n\n'
      '${cat.breedDescription ?? "Amazing feline companion"}\n\n'
      'Image: ${cat.url}',
      subject: 'Check out this cat!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cat.breedName ?? 'Cat Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareCat,
            tooltip: 'Share this cat',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'cat-${cat.id}',
              child: CachedNetworkImage(
                imageUrl: cat.url,
                height: 300,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 300,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 300,
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 8),
                      const Text("Cat couldn't be downloaded"),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          (context as Element).markNeedsBuild();
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat.breedName ?? 'Unknown Breed',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (cat.likedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Liked at: ${_formatDate(cat.likedAt!)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    cat.breedDescription ?? 'No description available',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
