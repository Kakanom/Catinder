import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../blocs/cat_bloc.dart';
import '../blocs/cat_event.dart';
import '../blocs/cat_state.dart';
import '../widgets/cat_card.dart';
import '../widgets/like_button.dart';
import '../widgets/dislike_button.dart';
import 'settings_screen.dart';
import 'liked_cats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final CardSwiperController _swiperController = CardSwiperController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Нет интернета'),
        content: const Text('Проверьте подключение и попробуйте снова.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CatBloc, CatState>(
      listener: (context, state) {
        if (state.error != null && !state.isLoading && state.cats.isEmpty) {
          _showNoConnectionDialog();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Catinder PRO'),
            actions: [
              IconButton(
                icon: Image.asset('assets/images/cat_heart2.png', width: 40),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LikedCatsScreen()),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                ),
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
                child: state.isLoading || state.cats.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : CardSwiper(
                        controller: _swiperController,
                        cardsCount: state.cats.length,
                        onSwipe: (previousIndex, currentIndex, direction) {
                          print('CardSwiper onSwipe: previousIndex=$previousIndex, direction=$direction');
                          context.read<CatBloc>().add(SwipeCatEvent(previousIndex, direction));
                          return true;
                        },
                        cardBuilder: (context, index, horizontalOffsetPercentage, verticalOffsetPercentage) {
                          return CatCard(cat: state.cats[index]);
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DislikeButton(
                      onPressed: () {
                        print('DislikeButton pressed');
                        _swiperController.swipe(CardSwiperDirection.left);
                      },
                    ),
                    Column(
                      children: [
                        Text('Likes: ${state.likeCount}', style: const TextStyle(fontSize: 18)),
                        Text('Streak: ${state.streakCount}', style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    LikeButton(
                      onPressed: () {
                        print('LikeButton pressed');
                        _swiperController.swipe(CardSwiperDirection.right);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _swiperController.dispose();
    super.dispose();
  }
}
