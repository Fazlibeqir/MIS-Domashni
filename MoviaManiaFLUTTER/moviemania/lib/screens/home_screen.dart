import 'package:flutter/material.dart';
import '../services/movie_api_service.dart';
import '../models/movie.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/movie_column.dart';
import '../widgets/trending_movie_card.dart';
import 'watchlist_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> _movies;
  int _currentIndex = 0;
  final List<bool> _previousDayChecked = [false, false, false];
  final List<bool> _todayChecked = [false, false, false];
  final List<bool> _tomorrowChecked = [false, false, false];

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

  double _getProgress() {
    int checkedCount = _previousDayChecked.where((e) => e).length +
        _todayChecked.where((e) => e).length +
        _tomorrowChecked.where((e) => e).length;
    int totalCount = _previousDayChecked.length +
        _todayChecked.length +
        _tomorrowChecked.length;
    return checkedCount / totalCount;
  }

  String _getWatchedCount() {
    int checkedCount = _previousDayChecked.where((e) => e).length +
        _todayChecked.where((e) => e).length +
        _tomorrowChecked.where((e) => e).length;
    int totalCount = _previousDayChecked.length +
        _todayChecked.length +
        _tomorrowChecked.length;
    return '$checkedCount/$totalCount';
  }

  Widget _buildHomeContent() {
    return FutureBuilder<List<Movie>>(
      future: _movies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Failed to load movies.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No movies available.'));
        }

        final movies = snapshot.data!;

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Watched: ${_getWatchedCount()}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LinearProgressIndicator(
                  value: _getProgress(),
                  backgroundColor: Colors.blueGrey[900],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MovieColumn(
                      title: 'Previous Day',
                      movie: movies.isNotEmpty ? movies[0] : null,
                      isChecked: _previousDayChecked[0],
                      onChanged: (value) {
                        setState(() {
                          _previousDayChecked[0] = value!;
                        });
                      },
                    ),
                    MovieColumn(
                      title: 'Today',
                      movie: movies.length > 1 ? movies[1] : null,
                      isChecked: _todayChecked[0],
                      onChanged: (value) {
                        setState(() {
                          _todayChecked[0] = value!;
                        });
                      },
                    ),
                    MovieColumn(
                      title: 'Tomorrow',
                      movie: movies.length > 2 ? movies[2] : null,
                      isChecked: _tomorrowChecked[0],
                      onChanged: (value) {
                        setState(() {
                          _tomorrowChecked[0] = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Watched Text and Progress Bar

              const SizedBox(height: 16.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Trending',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return TrendingMovieCard(movie: movies[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      Scaffold(
        appBar: AppBar(
          title: const Text('MovieMania',
          textAlign: TextAlign.center,),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: _buildHomeContent(),
      ),
      const WatchlistScreen(),
      const SearchScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
