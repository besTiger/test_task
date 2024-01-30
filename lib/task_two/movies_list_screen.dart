import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'movie_details_screen.dart';
import 'movie_model.dart';
import 'movie_service.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key}) : super(key: key);

  @override
  MoviesScreenState createState() => MoviesScreenState();
}

class MoviesScreenState extends State<MoviesScreen> {
  final MovieService movieService = MovieService();
  final ScrollController _scrollController = ScrollController();
  final List<MovieModel> _movies = [];
  bool _loading = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMovies() async {
    setState(() {
      _loading = true;
    });

    try {
      final List<MovieModel> movies = await movieService.fetchMovies(_currentPage);
      setState(() {
        _movies.addAll(movies);
        _loading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading movies: $e');
      }
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _refreshMovies() async {
    _currentPage = 1;
    _movies.clear();
    _loadMovies();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_loading) {
        _currentPage++;
        _loadMovies();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movies List'),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshMovies,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.6,
              ),
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                final movie = _movies[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Colors.grey[300]!, width: 1.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailsScreen(movie: movie),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            movie.posterPath,
                            height: 120.0,
                            width: 80.0,
                            fit: BoxFit.cover,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Release Year: ${movie.releaseYear}',
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Rating: ${movie.rating}',
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
