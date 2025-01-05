import 'package:flutter/material.dart';
import '../services/movie_api_service.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import '../widgets/bottom_navbar.dart';
import 'search_screen.dart';
import 'watchlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
 _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  late Future<List<Movie>> _movies;
  int _currentIndex = 0;

  @override
  void initState(){
    super.initState();
    _movies = MovieApiService().fetchAllMovies();
  }
  void _onNavItemTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
     Scaffold(
        appBar: AppBar(title: const Text('Trending')
        , centerTitle: true,),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<Movie>>(
            future: _movies,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No movies available'));
              } else {
                final movies = snapshot.data!;
                return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (ctx, index) => MovieCard(movie: movies[index]),
                );
              }
            },
          ),
        ),
      ),
      const SearchScreen(), // Search screen
      const WatchlistScreen(), // Watchlist screen
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('MovieMania'),
         centerTitle: true,
      ),
      body: screens[_currentIndex], // Display the current screen based on the selected index
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped, // Handle tap on bottom navigation
      ),
    );
  }
}