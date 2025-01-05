import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieApiService {
  static const String baseUrl = 'https://moviesdatabase.p.rapidapi.com';
  static final String apiKey = dotenv.env['API-KEY'] ?? ''; // Replace with your actual API key

  // Fetch all movies from the API
  Future<List<Movie>> fetchAllMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/titles'),
      headers: {
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host': 'moviesdatabase.p.rapidapi.com',
      },
    );

    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        List<Movie> movies = [];
        // Loop through the results and map to Movie objects
        for (var singleMovie in data["results"]) {
          Movie movie = Movie.fromJson(singleMovie);
          movies.add(movie);
        }
        return movies;
      } else {
        throw Exception('No results found for movies');
      }
    } else {
      throw Exception('Failed to load movies: ${response.statusCode}');
    }
  }

  // Search for movies by title
  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/titles/search/title/$query?exact=true&titleType=movie'),
      headers: {
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host': 'moviesdatabase.p.rapidapi.com',
      },
    );

    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        return (data['results'] as List).map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('No results found for search query');
      }
    } else {
      throw Exception('Failed to search movies: ${response.statusCode}');
    }
  }
}
