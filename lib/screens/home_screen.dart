import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:audioplayers/audioplayers.dart';
import '../api/cat_api.dart';
import '../widgets/cat_card.dart';
import '../widgets/like_button.dart';
import '../widgets/dislike_button.dart';
import 'settings_screen.dart';

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
      final fetchedCats = await CatApi.fetchCats();
      setState(() {
        cats = fetchedCats;
        showSecretCat = false;
      });
    } catch (e) {
      print('Error fetching cats: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playMeowSound() async {
    if (widget.soundEnabled) {
      await _audioPlayer.play(AssetSource('meow.mp3'));
    }
  }

  void resetProgress() {
    setState(() {
      likeCount = 0;
      streakCount = 0;
      showSecretCat = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catinder'),
        actions: [
          GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    onThemeChanged: widget.onThemeChanged,
                    onSoundChanged: widget.onSoundChanged,
                    isDarkMode: Theme.of(context).brightness == Brightness.dark,
                    soundEnabled: widget.soundEnabled,
                    onResetProgress: resetProgress,
                  ),
                ),
              );
            },
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/icon/app_icon.png',
                  width: 125,
                  height: 125,
                ),
              ),
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
                Text(
                  'Likes: $likeCount',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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

  bool _onSwipe(
      int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    setState(() {
      if (direction == CardSwiperDirection.right) {
        likeCount++;
        streakCount++;
        if (streakCount == 10) {
          cats.add(Cat.getSecretCat());
          showSecretCat = true;
          streakCount = 0;
          _playMeowSound();
        }
      } else {
        streakCount = 0;
      }

      if (showSecretCat && currentIndex == cats.length - 1) {
        showSecretCat = false;
      }
    });

    if (currentIndex == cats.length - 2 && !showSecretCat) {
      fetchCats();
    }
    return true;
  }
}
