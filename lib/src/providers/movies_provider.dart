import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/models/actor_model.dart';

class MoviesProvider {

  String _apiKey = '020502e889590e1b139d83e531923f88';
  String _url = 'api.themoviedb.org';
  String _language = 'de';
  String _region = 'DE';
  
  int _popularsPage = 0;
  bool _loading = false;

  List<Movie> _populars = new List();
  final _popularsStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularsSink => _popularsStreamController.sink.add;

  Stream<List<Movie>> get popularsStream => _popularsStreamController.stream;

  void disposeStreams() {
    _popularsStreamController?.close();
  }

  Future<List<Movie>> _processResponse(Uri url) async{
    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);

    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }

  Future<List<Movie>> getOnTheaters() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key':_apiKey,
      'language': _language
    });

    return await _processResponse(url);
  }

  Future<List<Movie>> getPopulars() async {
    
    if (_loading) return [];

    _loading = true;

    _popularsPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key':_apiKey,
      'language': _language,
      'page': _popularsPage.toString()
    });

    final resp = await _processResponse(url);

    _populars.addAll(resp);
    popularsSink(_populars);

    _loading = false;

    return resp;
  }

  Future<List<Actor>> getCast(int movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits', {
      'api_key': _apiKey,
      'language': _language
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actors;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });

    return await _processResponse(url);
  }

}