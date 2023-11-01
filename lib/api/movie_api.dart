import 'package:http/http.dart' as http;

class MovieApi {
  static Future getMovies(int page) {
    return http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US&page=$page'));
  }

  static Future getMoviesSearchByTitleFromApi(String title, int page) {
    return http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US&query=$title&page=$page'));
  }
}
