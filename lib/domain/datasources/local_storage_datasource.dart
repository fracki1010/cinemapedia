import 'package:cinemapedia/domain/entities/movie.dart';

abstract class LocalStorageDatasource {
  Future<void> toggleFavorite(Movie movie);
}
