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
  List<Movie> initialMovies;

  final SearchMoviesCallback searchMovies;
  //El stream controller es para que no se hagan tantas peticiones
  //con la busqueda, osea que se hacian peticiones con cada letra
  //Que se tocaba
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  //broadcast permite escuchar funcionalidades
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  SearchMovieDelegate({
    required this.initialMovies,
    required this.searchMovies,
  });

//Con este crearStreams limpio todos los streams que se utilizaron en cada
//llamada que se hizo para buscar una pelicula ya que estos
//Datos siguen por la aplicacion
  void clearStreams() {
    debouncedMovies.close();
  }

  Timer? _debounceTime;
  //Es para determinar un periodo de tiempo
  //Esta variable emite el valor cuando una persona deja de escribir
  //por un sierto tiempo

  void _onQueryChanged(String query) {
    //Simpre que presione una tecla entra aca para
    //Saber si esta activo y eso me va a decir que el usuario
    //Dejo de escirbir y puedo hacer la peticion
    // print('query stream cambio');

    //Le añade un true apenas el usuario comienza a escribir entonces
    // se puede ver la spin girando
    isLoadingStream.add(true);

    if (_debounceTime?.isActive ?? false) _debounceTime!.cancel();
    //Esto sirve para decir que el timer ya no sirve, cancelalo

    _debounceTime = Timer(
      const Duration(milliseconds: 800),
      () async {
        /* if (query.isEmpty) {
          debouncedMovies.add([]);
          return;
        } */

        final movies = await searchMovies(query);
        debouncedMovies.add(movies);
        initialMovies = movies;
        //Cuando termina de escribir el usuario desaparece el spin girando y aparece la cruz
        isLoadingStream.add(false);
      },
    );
  }

  //

//Esto es para evitar la duplicidad de codigo (Don't Repeat Yourself)
  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      //future: searchMovies(query),
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies =
            snapshot.data ?? []; //Si no tenemos data no mostramos nada;
        //Esta variable (movies) obtiene toda la data

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];

            return _MovieItem(
              movie: movie,
              onMovieSelected: (context, movie) {
                clearStreams();
                close(context, movie);
              },
            );
          },
        );
      },
    );
  }

  //

  //Eso es para cambiarle el nombre al label del buscador
  @override
  String get searchFieldLabel => 'Buscar película';

  //Esto es para contruir las acciones
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
          initialData: false,
          stream: isLoadingStream.stream,
          builder: (context, snapshot) {
            if (snapshot.data ?? false) {
              return SpinPerfect(
                duration: const Duration(seconds: 1),
                spins: 10,
                infinite: true,
                child: IconButton(
                  onPressed: () => query = '',
                  //llamando al query que es una propiedad del SearchDelegate
                  //Logramos borrar lo que esta dentro del input de busqueda
                  icon: const Icon(Icons.refresh_rounded),
                ),
              );
            }

            return FadeIn(
              animate: query.isNotEmpty,
              child: IconButton(
                onPressed: () => query = '',
                //llamando al query que es una propiedad del SearchDelegate
                //Logramos borrar lo que esta dentro del input de busqueda
                icon: const Icon(Icons.clear),
              ),
            );
          }),
    ];
  }

  //

  //Esto es para contruir un icono, para el inicio
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

//Para mostrar los resultados que van a aparecer cuando la persona presione enter
  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  //

  //Es para cuando la persona esta escribiendo, a ver que hago
  @override
  Widget buildSuggestions(BuildContext context) {
    //Este onQueryChanged es para llamar la funcion cada vez
    //Que se precione una tecla para hacer la comparacion y saber
    //Si el usuario dejo de escribir para poder realizar la
    //Peticion
    _onQueryChanged(query);

    //Uso un FutureBuilder para contruir widget basados en FUTURES
    return buildResultsAndSuggestions();
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
