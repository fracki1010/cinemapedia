import 'package:flutter/material.dart';

import '../../views/views.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'home-screen';
  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//Este mixin es para mantener el estado en el PageView
class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late PageController pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController(keepPage: true);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final viewRoutes = const <Widget>[
    HomeView(),
    PopularesView(),
    FavoriteView(),
  ];

  @override
  Widget build(BuildContext context) {
    if (pageController.hasClients) {
      pageController.animateToPage(
        widget.pageIndex,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }

    //En esta parte estamos cambiano el IndexedStack
    return Scaffold(
      body: PageView(
        //Esto evita que rebote
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: viewRoutes,
      ),
      bottomNavigationBar:
          CustomBottomNavigation(currentIndex: widget.pageIndex),
    );

    //Este es el de antes
    /*  return Scaffold(
      body: IndexedStack(
        index: widget.pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar:
          CustomBottomNavigation(currentIndex: widget.pageIndex),
    ); */
  }

  //Esto es parte del PageView
  @override
  bool get wantKeepAlive => true;
}
