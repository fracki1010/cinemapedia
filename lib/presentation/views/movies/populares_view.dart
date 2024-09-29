import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/widgets.dart';

class PopularesView extends ConsumerStatefulWidget {
  const PopularesView({super.key});

  @override
  PopularesViewState createState() => PopularesViewState();
}

class PopularesViewState extends ConsumerState<PopularesView> {
  @override
  Widget build(BuildContext context) {
    //Todo esto es para hacer un infinite scroll
    bool isLoading = false;

    void loadNextPage() {
      if (isLoading) return;

      isLoading = true;
      ref.read(popularMoviesProvider.notifier).loadNextPage();
      isLoading = false;
    }

    @override
    void initState() {
      super.initState();

      loadNextPage();
    }

    final popularMovies = ref.watch(popularMoviesProvider);

    return Scaffold(
      body: MovieMasonry(
        movies: popularMovies,
        loadNextPage: loadNextPage,
      ),
    );
  }
}
