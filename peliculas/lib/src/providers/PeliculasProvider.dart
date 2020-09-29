import 'dart:async';
import 'dart:convert';
import 'package:peliculas/src/models/PeliculaModel.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apikey = '0a7b3987c1e750b3c6cb02ce7759326f';
  String _url = 'api.themoviedb.org';
  String _languaje = 'es-ES';
  int _popularesPage = 0;

  List<Pelicula> _peliculas = new List();
  final _peliculasStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _peliculasStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream => _peliculasStreamController.stream;

  void disposeStreams() {
    _peliculasStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    return peliculas.peliculas;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',{
      'api_key': _apikey,
      'languaje': _languaje});
    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    _popularesPage++;
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'languaje': _languaje,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);
    _peliculas.addAll(resp);
    popularesSink(_peliculas);
    return resp;
  }
}
