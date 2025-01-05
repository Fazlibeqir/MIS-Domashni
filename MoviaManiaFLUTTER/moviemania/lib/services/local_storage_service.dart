import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/movie.dart';

class LocalStorageService {

  static const String watchlistKey = 'watchlist';
  static const String watchedMoviesKey = 'watched_movies';
  static const String allMoviesKey = 'all_movies';

  Future<void> saveMovies(List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> moviesJson = movies.map((movie) => jsonEncode(movie.toJson())).toList();
    await prefs.setStringList(allMoviesKey, moviesJson);
  }
    Future<List<Movie>> getAllMovies() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> moviesJson = prefs.getStringList(allMoviesKey) ?? [];
    return moviesJson.map((movieJson) => Movie.fromJson(jsonDecode(movieJson))).toList();
  }



  Future<void> saveToWatchlist(String movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final watchlist = prefs.getStringList(watchlistKey) ?? [];
    if(!watchlist.contains(movieId)) {
      watchlist.add(movieId);
      await prefs.setStringList(watchlistKey, watchlist);
    }
  }

  Future<List<String>> getWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(watchlistKey) ?? [];
  }

  Future<void> removeFromWatchlist(String movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final watchlist = prefs.getStringList(watchlistKey) ?? [];
    watchlist.remove(movieId);
    await prefs.setStringList(watchlistKey, watchlist);
  }

  Future<void> markAsWatched(String movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final watchedMovies = prefs.getStringList(watchedMoviesKey) ?? [];
    if(!watchedMovies.contains(movieId)) {
      watchedMovies.add(movieId);
      await prefs.setStringList(watchedMoviesKey, watchedMovies);
    }
  }
  Future<List<String>> getWatchedMovies() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(watchedMoviesKey) ?? [];
  }
  
  Future<void> unmarkAsWatched(String movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final watchedMovies = prefs.getStringList(watchedMoviesKey) ?? [];
    watchedMovies.remove(movieId);
    await prefs.setStringList(watchedMoviesKey, watchedMovies);
  }
}