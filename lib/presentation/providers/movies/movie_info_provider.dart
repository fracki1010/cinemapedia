import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>(
  (ref) {
    final movieRepository = ref.watch(movieRepositoryProvider);

    return MovieMapNotifier(getMovie: movieRepository.getMovieById);
  },
);

//Este va a tratar de guardar en un mapa peliculas que ya fueron buscadas
// {
// 78940: Movie(),
// 33425: Movie(),
//}

//Este es para que esta funcion me regrese una pelicula,
//Para que llame a germoviecallback y este sea una funcion
typedef GetMovieCallBack = Future<Movie> Function(String movie);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  //Asi se va a llamar la funcion
  final GetMovieCallBack getMovie;

  MovieMapNotifier({required this.getMovie}) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;
    //print('Realizando peticion https');
    final movie = await getMovie(movieId);

    state = {...state, movieId: movie};
  }
}
