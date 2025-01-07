import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieColumn extends StatelessWidget {
  final String title;
  final Movie? movie;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const MovieColumn({
    required this.title,
    this.movie,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 8.0),
          if (movie != null)
            Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(movie!.imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            )
          else
            Container(
              width: 100,
              height: 150,
              color: Colors.grey[800],
              child: const Center(
                child: Icon(Icons.movie, color: Colors.white),
              ),
            ),
          const SizedBox(height: 8.0),
          if (movie != null)
            Text(
              movie!.title,
              style: const TextStyle(fontSize: 14, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: Colors.green,
            checkColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
