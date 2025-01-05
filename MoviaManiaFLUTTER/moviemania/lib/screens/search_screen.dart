import 'package:flutter/material.dart';
import '../services/movie_api_service.dart';
import '../models/movie.dart';
import '../widgets/search_result_item.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Movie>>? _searchResults;

  void _searchMovies(String query) {
    setState(() {
      _searchResults = MovieApiService().searchMovies(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Movies'),
       centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchMovies(_searchController.text),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Movie>>(
                future: _searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No results found'));
                  } else {
                    final movies = snapshot.data!;
                    return ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (ctx, index) => SearchResultItem(movie: movies[index]),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
