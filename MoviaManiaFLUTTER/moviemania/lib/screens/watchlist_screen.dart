import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import 'dart:convert';
import '../models/movie.dart';
import '../widgets/watchlist_item.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  WatchlistScreenState createState() => WatchlistScreenState();
}

class WatchlistScreenState extends State<WatchlistScreen> {
  List<Movie> _watchlist = [];

  @override
  void initState() {
    super.initState();
    _loadWatchlist();
  }

  void _loadWatchlist() {
    LocalStorageService().getWatchlist().then((list) {
      setState(() {
        _watchlist = list.map<Movie>((item) => Movie.fromJson(jsonDecode(item))).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist'),
       centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _watchlist.isEmpty
            ? const Center(child: Text('No movies in your watchlist'))
            : ListView.builder(
                itemCount: _watchlist.length,
                itemBuilder: (ctx, index) => WatchlistItem(movie: _watchlist[index]),
              ),
      ),
    );
  }
}
