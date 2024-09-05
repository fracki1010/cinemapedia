import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_providers.dart';

//Este provider va a determinar cuando termine de cargar la pagina y este lista para su uso
final initialLoadingProvider = Provider((ref) {
//Now Playing
  final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider).isEmpty;
  //Popular
  final popularMovies = ref.watch(popularMoviesProvider).isEmpty;
  //Up Coming
  final upcomingMovies = ref.watch(upcomingMoviesProvider).isEmpty;
  //Top Rated
  final topRatedMovies = ref.watch(topRatedMoviesProvider).isEmpty;

  if (nowPlayingMovies || popularMovies || upcomingMovies || topRatedMovies)
    return true;

  return false; //esto significa que terminamos de cargar
});
