import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:audioplayers/audioplayers.dart';
import '../api/cat_api.dart';
import '../widgets/cat_card.dart';
import '../widgets/like_button.dart';
import '../widgets/dislike_button.dart';
import 'settings_screen.dart';
import 'liked_cats_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(bool) onThemeChanged;
  final void Function(bool) onSoundChanged;
  final bool soundEnabled;

  const HomeScreen({
    super.key,
    required this.onThemeChanged,
    required this.soundEnabled,
    required this.onSoundChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final CardSwiperController _swiperController = CardSwiperController();
  List<Cat> cats = [];
  List<Cat> likedCats = [];
  int likeCount = 0;
  int streakCount = 0;
  bool showSecretCat = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    fetchCats();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> fetchCats() async {
    try {
      setState(() => cats = []);
      final fetchedCats = await CatApi.fetchCats();
      setState(() {
        cats = fetchedCats;
        showSecretCat = false;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to load cats: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _removeLikedCat(Cat cat) {
    setState(() {
      likedCats.remove(cat);
      likeCount = likedCats.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catinder PRO'),
        actions: [
          IconButton(
            icon: Image.asset('assets/images/cat_heart2.png', width: 40),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LikedCatsScreen(
                  likedCats: likedCats,
                  onRemove: _removeLikedCat,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    onThemeChanged: widget.onThemeChanged,
                    onSoundChanged: widget.onSoundChanged,
                    isDarkMode: Theme.of(context).brightness == Brightness.dark,
                    soundEnabled: widget.soundEnabled,
                    onResetProgress: () => setState(() {
                      likeCount = 0;
                      streakCount = 0;
                      likedCats.clear();
                    }),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/icon/app_icon.png', width: 40),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: cats.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : CardSwiper(
                    controller: _swiperController,
                    cardsCount: cats.length,
                    onSwipe: _onSwipe,
                    cardBuilder: (context, index, horizontalOffsetPercentage,
                        verticalOffsetPercentage) {
                      return CatCard(cat: cats[index]);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DislikeButton(
                  onPressed: () =>
                      _swiperController.swipe(CardSwiperDirection.left),
                ),
                Column(
                  children: [
                    Text('Likes: $likeCount',
                        style: const TextStyle(fontSize: 18)),
                    Text('Streak: $streakCount',
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
                LikeButton(
                  onPressed: () =>
                      _swiperController.swipe(CardSwiperDirection.right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
  setState(() {
    if (direction == CardSwiperDirection.right) {
      likeCount++;
      streakCount++;
      likedCats.insert(0, Cat(
        id: cats[previousIndex].id,
        url: cats[previousIndex].url,
        breedName: cats[previousIndex].breedName,
        breedDescription: cats[previousIndex].breedDescription,
        likedAt: DateTime.now(),
      ));
      if (streakCount == 10) {
        cats.add(Cat.getSecretCat());
        showSecretCat = true;
        streakCount = 0;
        _playMeowSound();
      }
    } else {
      streakCount = 0;
    }
  });

  if (currentIndex == cats.length - 2 && !showSecretCat) {
    fetchCats();
  }
  return true;
}

  Future<void> _playMeowSound() async {
    if (widget.soundEnabled) {
      await _audioPlayer.play(AssetSource('meow.mp3'));
    }
  }
}