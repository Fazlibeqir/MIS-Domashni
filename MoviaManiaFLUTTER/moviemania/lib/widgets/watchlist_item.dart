import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../screens/movie_details_screen.dart';

class WatchlistItem extends StatelessWidget {
  final Movie movie;

  const WatchlistItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: movie)),
      ),
      child: Card(
        child: ListTile(
          leading: movie.imageUrl.isNotEmpty
              ? Image.network(movie.imageUrl, fit: BoxFit.cover, width: 50)
              : const Icon(Icons.movie, size: 50),
          title: Text(movie.title),
          subtitle: Text(movie.releaseDate.toLocal().toString().split(' ')[0]),
        ),
      ),
    );
  }
}