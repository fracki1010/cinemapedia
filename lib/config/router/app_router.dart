import 'package:go_router/go_router.dart';

import '../../presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        //Esto es para buscar en cual pagina estoy, home, cat o fav
        final pageIndex = int.parse(state.pathParameters['page'] ?? '0');
        return HomeScreen(pageIndex: pageIndex);
      },
      routes: [
        //Estas son las rutas hijas, asi puedo siempre regresar a home
        GoRoute(
          path: 'movie/:id',

          //no se le pone (/) porque ya la tiene el padre arriba(path)
          //Estoy diciendo que voy a mandar este argumento id
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id'; //Busca id

            return MovieScreen(movieId: movieId);
          },
        )
      ],
    ),

    //Con esto se redirecciona el path "/" a la ruta "/home/0"
    //porque la app esta configurada para que este sea su home "/"
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home/0',
    ),
  ],
);
