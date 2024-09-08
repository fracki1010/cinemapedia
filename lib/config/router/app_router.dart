import 'package:go_router/go_router.dart';

import '../../presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path: '/',
        name: HomeScreen.name,
        builder: (context, state) => const HomeScreen(),
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
        ]),
  ],
);
