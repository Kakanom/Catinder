import '../../domain/entities/cat.dart';

class CatModel extends Cat {
  CatModel({
    required String id,
    required String url,
    String? breedName,
    String? breedDescription,
    DateTime? likedAt,
  }) : super(
          id: id,
          url: url,
          breedName: breedName,
          breedDescription: breedDescription,
          likedAt: likedAt,
        );

  factory CatModel.fromJson(Map<String, dynamic> json) {
    final breed = json['breeds']?.isNotEmpty == true ? json['breeds'][0] : null;
    return CatModel(
      id: json['id'],
      url: json['url'],
      breedName: breed?['name'],
      breedDescription: breed?['description'],
    );
  }

  static CatModel getSecretCat() {
    return CatModel(
      id: 'secret_cat',
      url: 'https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg',
      breedName: 'Secret Maine Coon',
      breedDescription: 'You found the Secret Cat after 10 likes!',
    );
  }
}
