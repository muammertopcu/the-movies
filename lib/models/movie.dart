class Movie {
  int id;
  String originalTitle;
  String? posterPath;
  String title;

  Movie({
    required this.id,
    required this.originalTitle,
    this.posterPath,
    required this.title,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      originalTitle: json['original_title'],
      posterPath: json['poster_path'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original_title': originalTitle,
      'poster_path': posterPath,
      'title': title,
    };
  }
}
