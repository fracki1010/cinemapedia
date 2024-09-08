import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//cuando necesitemos saber las peliculas que esta ahora en el cine, consultamos
//este provider para la informacion
final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>(
  //LA CLASE QUE CONTROLA O NOTIFICA ES "MoviesNotifier" y la data o state es "List<Movie>"
  (ref) {
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;

    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);

//

//

final popularMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>(
  //LA CLASE QUE CONTROLA O NOTIFICA ES "MoviesNotifier" y la data o state es "List<Movie>"
  (ref) {
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;

    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);

//

//

final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>(
  //LA CLASE QUE CONTROLA O NOTIFICA ES "MoviesNotifier" y la data o state es "List<Movie>"
  (ref) {
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;

    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);

//

//

final upcomingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>(
  //LA CLASE QUE CONTROLA O NOTIFICA ES "MoviesNotifier" y la data o state es "List<Movie>"
  (ref) {
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;

    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);

//El StateNotiferProvider
// es  un "proveedor de informacion que notifica el estado cuando cambia el estado"
//

//Este typedef es el tipo de funcion que espera
//el objetivo es definir un caso de uso, para cargar mas peliculas solo se llama esta funcion
typedef MovieCallBack = Future<List<Movie>> Function({int page});

//Ahora lo de abajo dice que vamos a manter un listado de movie
//el StateNotifier va a pedir que tipo de estado es el que yo voy a mantener sobre el
//osea que voy a mantener un estado de MOVIE
class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;
  MovieCallBack fetchMoreMovies;

  MoviesNotifier({
    required this.fetchMoreMovies,
  }) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;

    isLoading = true;

    currentPage++;

    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];

    await Future.delayed(const Duration(milliseconds: 500));
    isLoading = false;
  }
}
