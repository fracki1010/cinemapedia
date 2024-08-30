import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRepositoryProvider = Provider((ref) {
  //Con esto proveemos el repositorio, osea que lo implementamos
  //Este repositorio es inmutable
  //Su objetivo es proporsionar a todos los provider que tengo
  //la informacion necesaria para que puedan consultar los datos al repositorio
  return MovieRepositoryImpl(MoviedbDatasource());
});
