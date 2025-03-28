import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';

//Este trata de contar lo del swipe show soloanete

final moviesSlideshowProvider = Provider<List<Movie>>((ref) {
  final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
  //
  if (nowPlayingMovies.isEmpty) return [];
  //
  return nowPlayingMovies.sublist(0, 6);
});
