import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsRepositoryProvider = Provider((ref) {
  //Con esto proveemos el repositorio, osea que lo implementamos
  //Este repositorio es inmutable
  //Su objetivo es proporsionar a todos los provider que tengo
  //la informacion necesaria para que puedan consultar los datos al repositorio
  return ActorRepositoryImpl(ActorMoviedbDatasource());
});
