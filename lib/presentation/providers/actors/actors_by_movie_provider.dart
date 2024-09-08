import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProvider =
    StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>(
  (ref) {
    final actorsRepository = ref.watch(actorsRepositoryProvider);

    return ActorsByMovieNotifier(getActors: actorsRepository.getActorsByMovie);
  },
);

//Este va a tratar de guardar en un mapa peliculas que ya fueron buscadas
// {
// 78940: List<Actor>[],
// 33425: List<Actor>[],
//}

//Este es para que esta funcion me regrese una pelicula,
//Para que llame a germoviecallback y este sea una funcion
typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  //Asi se va a llamar la funcion
  final GetActorsCallback getActors;

  ActorsByMovieNotifier({
    required this.getActors,
  }) : super({});

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;
    //print('Realizando peticion https');
    final List<Actor> actors = await getActors(movieId);

    state = {...state, movieId: actors};
  }
}
