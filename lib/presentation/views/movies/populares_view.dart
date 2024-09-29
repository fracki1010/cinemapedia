import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/widgets.dart';

class PopularesView extends ConsumerStatefulWidget {
  const PopularesView({super.key});

  @override
  PopularesViewState createState() => PopularesViewState();
}

//Le coloco un mixin para poder usar el PageView en HomeScreen
class PopularesViewState extends ConsumerState<PopularesView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final popularMovies = ref.watch(popularMoviesProvider);

    if (popularMovies.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return Scaffold(
      body: MovieMasonry(
        movies: popularMovies,
        loadNextPage: () =>
            ref.read(popularMoviesProvider.notifier).loadNextPage(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
