import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:the_movies/api/movie_api.dart';
import '../models/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State {
  List<Movie> movies = [];
  List<Widget> movieWidgets = [];
  int page = 1;
  int totalPages = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getMoviesFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Movies'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search by title',
              ),
              onChanged: (text) {
                handleSearch(text);
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: _handleScrollNotification,
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemCount: movies.length + 1,
                itemBuilder: (context, index) {
                  if (index == movies.length) {
                    return page <= totalPages
                        ? const CircularProgressIndicator()
                        : Container();
                  } else {
                    return _buildMovieListItem(context, index);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getMoviesFromApi() async {
    final response = await MovieApi.getMovies(page);
    final data = json.decode(response.body);
    final list = data['results'] as Iterable;
    setState(() {
      movies = list.map((model) => Movie.fromJson(model)).toList();
      page++;
      totalPages = data['total_pages'];
    });
  }

  Future<void> loadMoreMovies() async {
    if (page > totalPages || movies.isEmpty || totalPages <= 1 || isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    final response = await MovieApi.getMovies(page);
    final list = json.decode(response.body)['results'] as Iterable;
    setState(() {
      movies.addAll(list.map((model) => Movie.fromJson(model)).toList());
      page++;
      isLoading = false;
    });
  }

  Future<void> getMoviesSearchByTitleFromApi(String title) async {
    final response = await MovieApi.getMoviesSearchByTitleFromApi(title, page);
    final data = json.decode(response.body);
    final list = data['results'] as Iterable;
    setState(() {
      movies = list.map((model) => Movie.fromJson(model)).toList();
      page++;
      totalPages = data['total_pages'];
    });
  }

  void handleSearch(String text) {
    page = 1;
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);

    if (text.length >= 2) {
      getMoviesSearchByTitleFromApi(text);
    } else {
      getMoviesFromApi();
    }
  }

  bool _handleScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      loadMoreMovies();
    }
    return true;
  }

  Widget _buildMovieListItem(BuildContext context, int index) {
    final movie = movies[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              movie.posterPath == null
                  ? 'https://via.placeholder.com/150x200'
                  : 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie.title,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
