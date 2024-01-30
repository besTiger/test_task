import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'movie_model.dart';


class MovieService {
  final String apiKey = 'e8bf0a88d8c448b3069dca27bd1d7619';
  final String baseUrl = 'https://api.themoviedb.org/3';
  final String imagePath = 'https://image.tmdb.org/t/p/w500';

  Future<List<MovieModel>> fetchMovies(int page) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/discover/movie?api_key=$apiKey&page=$page'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<MovieModel> movies = [];

        for (var movieData in data['results']) {
          movies.add(MovieModel(
            id: movieData['id'],
            title: movieData['title'],
            posterPath: '$imagePath${movieData['poster_path']}',
            releaseYear: int.parse(movieData['release_date'].substring(0, 4)),
            rating: (movieData['vote_average'] as num).toDouble(),
            overview: movieData['overview'],
          ));
        }

        return movies;
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> saveMovies(List<MovieModel> movies) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = File('${directory.path}/movies.json');

      final jsonData = movies.map((movie) => movie.toJson()).toList();
      final jsonString = json.encode(jsonData);

      await filePath.writeAsString(jsonString);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving movies: $e');
      }
    }
  }

  Future<List<MovieModel>> loadSavedMovies() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = File('${directory.path}/movies.json');
      if (filePath.existsSync()) {
        final jsonString = await filePath.readAsString();
        final jsonData = json.decode(jsonString);

        final List<MovieModel> movies = jsonData
            .map<MovieModel>((json) => MovieModel.fromJson(json))
            .toList();

        return movies;
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading saved movies: $e');
      }
      return [];
    }
  }
}
