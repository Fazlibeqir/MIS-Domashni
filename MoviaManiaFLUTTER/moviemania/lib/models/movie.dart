class Movie {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? '',
      title: json['titleText']?['text'] ?? 'Unknown Title',
      description: json['plot']?['plotText']?['plainText'] ?? 'No description available',
      imageUrl: json['primaryImage']?['url'] ?? '',
      releaseDate: DateTime.tryParse(json['releaseDate']?['year']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': description,
      'poster_path': imageUrl,
      'release_date': releaseDate.toIso8601String(),
    };
  }
}
