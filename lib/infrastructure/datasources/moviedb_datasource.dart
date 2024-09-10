import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX',
      },
    ),
  );

  //Con esto evitamos hacer muchas veces la peticion para todas las movies
  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final moviesDBResponse = MovieDbResponse.fromJson(json);
    //Convierte los datos de la peticion en el modelo(models)
    // que usamos para darle la forma
    //que nosotros deseamos
    //

    final List<Movie> movies = moviesDBResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((e) => MovieMapper.movieDBToEntity(e))
        .toList();
    //Ahora utilizamos los result que es donde esta toda la informacion ordenada
    //para mapear un mapper en donde lo convertimos en entidades para
    //crear la lista que necesitamos
    //
    return movies;
  }

  //

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {
        'page': page,
      },
    ); //Usa dio para hacer la peticion

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get(
      '/movie/popular',
      queryParameters: {
        'page': page,
      },
    ); //Usa dio para hacer la peticion

    return _jsonToMovies(response.data);
  }

  // TOPRATED
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get(
      '/movie/top_rated',
      queryParameters: {
        'page': page,
      },
    ); //Usa dio para hacer la peticion

    return _jsonToMovies(response.data);
  }

  //UPCOMING
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get(
      '/movie/upcoming',
      queryParameters: {
        'page': page,
      },
    ); //Usa dio para hacer la peticion

    return _jsonToMovies(response.data);
  }

  //para buscar por id

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');
    //Usa dio para hacer la peticion

    if (response.statusCode != 200) {
      throw Exception('Movie with id: $id not found');
    }

    final movieDetails = MovieDetails.fromJson(response.data);

    final Movie movie = MovieMapper.movieDatailsToEntity(movieDetails);

    return movie;
  }

  //Es para la busqueda con el search
  @override
  Future<List<Movie>> searchMovies(String query) async {
    final response = await dio.get(
      '/search/movie',
      queryParameters: {
        'query': query,
      },
    ); //Usa dio para hacer la peticion

    return _jsonToMovies(response.data);
  }
}
