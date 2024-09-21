import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      bottom: false, //Es un espacio que tiene prestablecido el "SafeArea"
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double
              .infinity, //Esto significa que le de todo el espacion posible
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colors.primary),
              const SizedBox(width: 5),
              Text('C I N E M A P E D I A', style: titleStyle),
              //
              const Spacer(), //Es un tipo de flex, que toma todo el espacio posible
              //
              IconButton(
                onPressed: () {
                  //TODO:
                  final searchedMovies = ref.read(searchedMoviesProvider);

                  //Esto trae lo que busamos anteriormente con el search
                  final searchQuery = ref.read(searchQueryProvider);

                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMovieDelegate(
                      initialMovies: searchedMovies,
                      searchMovies: ref
                          .read(searchedMoviesProvider.notifier)
                          .searchMoviesByQuery,
                      //Estoy enviando la referencia, no la llamda a la funcion
                    ),
                  ).then(
                    (movie) {
                      //Si no busconinguna pelicula y me salgo
                      //no retorna nada
                      if (movie == null) return;
                      //Sino me lleva a la pelicula con el link
                      context.push('/movie/${movie.id}');
                    },
                  );
                },
                icon: const Icon(Icons.search),
              )
            ],
          ),
        ),
      ),
    );
  }
}
