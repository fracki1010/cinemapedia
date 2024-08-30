import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb_response.dart';
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

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response =
        await dio.get('/movie/now_playing'); //Usa dio para hacer la peticion

    final moviesDBResponse = MovieDbResponse.fromJson(response.data);
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
}
