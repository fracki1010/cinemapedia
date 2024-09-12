import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

//Significa que disfrazo este nombre (SearchMoviesCallback) en una funcion
//que pide de parametro un query
//Osea que tiene que ser una funcion que cumpla esta firma
typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

//Esto es para controlar el search de la busqueda
class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  //El stream controller es para que no se hagan tantas peticiones
  //con la busqueda, osea que se hacian peticiones con cada letra
  //Que se tocaba
  StreamController debounceMovies = StreamController.broadcast();

  SearchMovieDelegate({required this.searchMovies});

  //Eso es para cambiarle el nombre al label del buscador
  @override
  String get searchFieldLabel => 'Buscar película';

  //

  //Esto es para contruir las acciones
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        FadeIn(
          animate: query.isNotEmpty,
          child: IconButton(
            onPressed: () => query = '',
            //llamando al query que es una propiedad del SearchDelegate
            //Logramos borrar lo que esta dentro del input de busqueda
            icon: const Icon(Icons.clear),
          ),
        )
    ];
  }

  //

  //Esto es para contruir un icono, para el inicio
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

//Para mostrar los resultados que van a aparecer cuando la persona presione enter
  @override
  Widget buildResults(BuildContext context) {
    return Text('');
  }

  //

  //Es para cuando la persona esta escribiendo, a ver que hago
  @override
  Widget buildSuggestions(BuildContext context) {
    //Uso un FutureBuilder para contruir widget basados en FUTURES
    return FutureBuilder(
      future: searchMovies(query),
      builder: (context, snapshot) {
        final movies =
            snapshot.data ?? []; //Si no tenemos data no mostramos nada;
        //Esta variable (movies) obtiene toda la data

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];

            return _MovieItem(movie: movie, onMovieSelected: close);
          },
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected; //Esto es para recibir una funcion

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      //Con esto puedo detectar si interactuaron el elemento
      onTap: () {
        onMovieSelected(context, movie);
        //con esto sale de la pantalla y va a movie
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            //Image
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(
                    child: child,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),
            //

            //Description
            SizedBox(
              width: size.width * 0.7,
              //Se a dejado espacio para padding entre
              // la imagen y esto
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyle.titleMedium),
                  //
                  (movie.overview.length > 100)
                      ? Text('${movie.overview.substring(0, 100)}...')
                      //Es para que el texto se corte en 100 letras
                      : Text(movie.overview),

                  Row(
                    children: [
                      Icon(Icons.star_half_rounded,
                          color: Colors.yellow.shade800),
                      //
                      const SizedBox(width: 5),
                      //
                      Text(
                        HumanFormats.number(movie.voteAverage, 1),
                        style: textStyle.bodyMedium!
                            .copyWith(color: Colors.yellow.shade800),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
