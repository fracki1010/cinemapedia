import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: _HomeView(),
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    //Now Playing
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    //Popular
    final popularMovies = ref.watch(popularMoviesProvider);
    //Up Coming
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    //Top Rated
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    //
    final slideShowMovies = ref.watch(moviesSlideshowProvider);

    //Cambiamos a un CustomScrollView para trabajar con SliverList
    //De esta manera le doy funcionalidad a el CustomAppBar
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
        ),

        //

        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Column(
            children: [
              //const CustomAppbar(),

              //

              MoviesSlideshow(movies: slideShowMovies),

              //
              MovieHorizontalListview(
                movies: nowPlayingMovies,
                title: 'En cines',
                subTitle: 'Lunes 20',
                loadNextPage: () =>
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
              ),

              //

              MovieHorizontalListview(
                movies: upcomingMovies,
                title: 'Proximamente',
                subTitle: 'En este mes',
                loadNextPage: () =>
                    ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
              ),

              //

              MovieHorizontalListview(
                movies: popularMovies,
                title: 'Populares',
                loadNextPage: () =>
                    ref.read(popularMoviesProvider.notifier).loadNextPage(),
              ),

              //

              MovieHorizontalListview(
                movies: topRatedMovies,
                title: 'Mejor calificados',
                loadNextPage: () =>
                    ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
              ),

              //

              const SizedBox(height: 10),
            ],
          );
        }, childCount: 1))
      ],
    );
  }
}
