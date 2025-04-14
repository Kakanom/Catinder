import 'package:flutter/material.dart';
import '../api/cat_api.dart';
import 'detail_screen.dart';

class LikedCatsScreen extends StatefulWidget {
  final List<Cat> likedCats;
  final Function(Cat) onRemove;

  const LikedCatsScreen({
    Key? key,
    required this.likedCats,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<LikedCatsScreen> createState() => _LikedCatsScreenState();
}

class _LikedCatsScreenState extends State<LikedCatsScreen> {
  String? selectedBreed;

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  List<Cat> get _filteredCats {
    if (selectedBreed == null) return widget.likedCats;
    return widget.likedCats.where((cat) => cat.breedName == selectedBreed).toList();
  }

  List<String?> get _availableBreeds {
    final breeds = widget.likedCats
        .map((cat) => cat.breedName)
        .where((breed) => breed != null)
        .toSet()
        .toList();
    breeds.sort((a, b) => a!.compareTo(b!));
    return breeds;
  }

  void _removeCat(Cat cat) {
    final currentBreed = selectedBreed;
    final catBreed = cat.breedName;
    
    widget.onRemove(cat);
    
    final shouldUpdateBreeds = !widget.likedCats.any((c) => c.breedName == catBreed);
    
    final shouldResetFilter = currentBreed != null && 
        _filteredCats.isEmpty && 
        catBreed == currentBreed;
    if (mounted) {
      setState(() {
        if (shouldResetFilter) {
          selectedBreed = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Cats'),
        actions: [
          if (selectedBreed != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => setState(() => selectedBreed = null),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String?>(
              value: selectedBreed,
              decoration: InputDecoration(
                labelText: 'Filter by breed',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.filter_alt),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All breeds'),
                ),
                ..._availableBreeds.map((breed) => DropdownMenuItem(
                      value: breed,
                      child: Text(breed!),
                    )),
              ],
              onChanged: (value) => setState(() => selectedBreed = value),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                final catsToShow = selectedBreed == null 
                    ? widget.likedCats 
                    : widget.likedCats.where((c) => c.breedName == selectedBreed).toList();

                if (catsToShow.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.favorite_border, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          selectedBreed == null
                              ? 'No liked cats yet'
                              : 'No cats of this breed',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: catsToShow.length,
                  itemBuilder: (context, index) {
                    final cat = catsToShow[index];
                    return Dismissible(
                      key: Key('${cat.id}_${cat.likedAt?.millisecondsSinceEpoch}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Remove cat'),
                            content: const Text('Are you sure you want to remove this cat from favorites?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Remove'),
                              ),
                            ],
                          ),
                        );
                        return shouldDelete ?? false;
                      },
                      onDismissed: (_) {
                        _removeCat(cat);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Removed ${cat.breedName ?? 'cat'}'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(cat: cat),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    cat.url,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cat.breedName ?? 'Unknown breed',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      if (cat.likedAt != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          _formatDate(cat.likedAt!),
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}