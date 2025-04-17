class Cat {
  final String id;
  final String url;
  final String? breedName;
  final String? breedDescription;
  final DateTime? likedAt;

  Cat({
    required this.id,
    required this.url,
    this.breedName,
    this.breedDescription,
    this.likedAt,
  });
}
