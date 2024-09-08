import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import '../mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMoviedbDatasource extends ActorsDatasource {
//Se utiliza dio para hacer las peticiones https
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
  List<Actor> _jsonToMovies(Map<String, dynamic> json) {
    final castResponse = CreditsResponse.fromJson(json);
    //Convierte los datos de la peticion en el modelo(models)
    // que usamos para darle la forma
    //que nosotros deseamos
    //

    final List<Actor> actors =
        castResponse.cast.map((e) => ActorMapper.castToEntity(e)).toList();
    //Ahora utilizamos los result que es donde esta toda la informacion ordenada
    //para mapear un mapper en donde lo convertimos en entidades para
    //crear la lista que necesitamos
    //
    return actors;
  }

  //Peticion limpia
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get(
      '/movie/$movieId/credits',
    ); //Usa dio para hacer la peticion

    return _jsonToMovies(response.data);
  }
}
