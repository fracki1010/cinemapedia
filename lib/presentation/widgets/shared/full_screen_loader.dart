import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    final messages = <String>[
      'Cargando películas',
      'Comprando palomitas de maíz',
      'Cargando populares',
      'Llamando a mi novia',
      'Ahora mismo ...',
      'Esto está tardando más de lo esperado :(',
    ];

    return Stream.periodic(
      const Duration(milliseconds: 1200),
      (computationCount) {
        return messages[
            computationCount]; //Este seria como el index, para que cada
        //1200 milisegundos pase por messages
      },
    ).take(messages
        .length); //Con esto (take) frenamos el stream cuando recorra todos los mensajes
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Espere por favor'),
          const SizedBox(height: 10),
          LoadingAnimationWidget.horizontalRotatingDots(
              color: Colors.white, size: 100),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Cargando');
              //Si no tiene datos entonces
              return Text(snapshot.data!);
            },
          )
        ],
      ),
    );
  }
}
