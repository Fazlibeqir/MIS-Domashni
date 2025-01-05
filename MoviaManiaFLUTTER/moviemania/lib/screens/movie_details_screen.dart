import 'package:flutter/material.dart';
import '../models/movie.dart';


class MovieDetailsScreen extends StatelessWidget{
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(movie.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(movie.description),
            const SizedBox(height: 8),
            Text('Release Date: ${movie.releaseDate.toLocal().toString().split(' ')[0]}'),
          ],
        ),
      ),
    );
  }
}