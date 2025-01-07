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

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> _movies;
  int _currentIndex = 0;
  bool _previousWatched = false;
  bool _todayWatched = false;
  bool _tomorrowWatched = false;

  @override
  void initState() {
    super.initState();
    _movies = MovieApiService().fetchAllMovies();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              const Text('MovieMania'),
              const SizedBox(height: 8.0),
              LinearProgressIndicator(
                value: 0.5, // Example progress value
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0), // Add padding for better spacing
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align items at the top
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Previous',
                              style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 10),
                          const Icon(
                            Icons.movie,
                            size: 100,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Watched',
                                  style: TextStyle(fontSize: 16)),
                              Checkbox(
                                value: _previousWatched,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _previousWatched = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Today', style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 10),
                          const Icon(
                            Icons.movie,
                            size: 100,
                            color: Colors.amber,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Watched',
                                  style: TextStyle(fontSize: 16)),
                              Checkbox(
                                value: _todayWatched,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _todayWatched = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Tomorrow',
                              style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 10),
                          const Icon(
                            Icons.movie,
                            size: 100,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Watched',
                                  style: TextStyle(fontSize: 16)),
                              Checkbox(
                                value: _tomorrowWatched,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _tomorrowWatched = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          centerTitle: true,
        ),
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
      const WatchlistScreen(), // Watchlist screen
      const SearchScreen(), // Search screen
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('MovieMania'),
        centerTitle: true,
      ),
      body: screens[
          _currentIndex], // Display the current screen based on the selected index
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped, // Handle tap on bottom navigation
      ),
    );
  }
}
