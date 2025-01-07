import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviemania/services/local_storage_service.dart';
import '../models/movie.dart';
import '../widgets/bottom_navbar.dart';
import 'home_screen.dart';
import 'watchlist_screen.dart';
import 'search_screen.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  DateTime selectedDate = DateTime.now();

  int currentIndex = 0;

  final LocalStorageService _localStorageService = LocalStorageService();

  String getFormattedDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('h:mm a');
    return '${dateFormat.format(dateTime)} ${timeFormat.format(dateTime)}';
  }

  void _onNavItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    switch (index) {
      case 0: // Home
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1: // Watchlist
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WatchlistScreen()),
        );
        break;
      case 2: // Search
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
        break;
    }
  }
   Future<void> _addToWatchlist() async {
    await _localStorageService.saveToWatchlist(widget.movie.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Movie added to Watchlist')),
    );
  }
  Future<void> _markAsWatched() async {
    await _localStorageService.markAsWatched(widget.movie.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Movie marked as Watched')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               // Movie Title
              Text(
                widget.movie.title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              // Movie Image
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.movie.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              const SizedBox(height: 16.0),

              // Movie Description
              Text(
                widget.movie.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16.0),

              // Date and Time Picker for Release Date and Time
              Text(
                'Release Date & Time',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () async {
                  // Date picker
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    // Time picker
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDate),
                    );
                    if (pickedTime != null) {
                      // Update selectedDate with the picked date and time
                      setState(() {
                        selectedDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  getFormattedDateTime(selectedDate),
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 16.0),

              // Buttons: Add to Watchlist & Add to Watched
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _addToWatchlist,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Add to Watchlist',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _markAsWatched,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Add to Watched',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // Use your custom BottomNavBar here
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
