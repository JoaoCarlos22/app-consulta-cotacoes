import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  'Seja bem-vindo',
                  style: TextStyle(color: Colors.black, fontSize: 28, decoration: TextDecoration.none),
                  textAlign: TextAlign.center,
                ),
                Text(
                    'App de Cotações Financeiras',
                    style: TextStyle(color: Colors.black, fontSize: 20, decoration: TextDecoration.none),
                    textAlign: TextAlign.center
                )
              ],
            ),
            ElevatedButton(onPressed: (){}, child: Text(
                'Iniciar'
            ))
          ],
        ),
      ),
    );
  }
}
