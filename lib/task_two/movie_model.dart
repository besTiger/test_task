class MovieModel {
  final int id;
  final String title;
  final String posterPath;
  final int releaseYear;
  final double rating;
  final String overview;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseYear,
    required this.rating,
    required this.overview,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String,
      releaseYear: json['release_year'] as int,
      rating: (json['rating'] as num).toDouble(),
      overview: json['overview'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'release_year': releaseYear,
      'rating': rating,
      'overview': overview,
    };
  }
}
