import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {
  //El Cast es de la propiedades de entities, lo que hace
  //que este ya tenga una clase y solo la estamos instanciando
  static Actor castToEntity(Cast cast) => Actor(
      id: cast.id,
      name: cast.name,
      //Si el profilePath es diferente de null este muestra la imagen
      //y si es null muestra una imagen que traigo de internet
      profilePath: cast.profilePath != null
          ? 'https//image.tmdb.org/t/p/w500${cast.profilePath}'
          : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
      character: cast.character);
}
