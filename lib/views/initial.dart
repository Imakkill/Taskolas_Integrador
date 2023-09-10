import 'package:flutter/material.dart';
import 'package:taskolas/views/principalPage.dart';

import '../controllers/tarefasController.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Taskolas'),
          centerTitle: true,
          titleTextStyle: const TextStyle(fontSize: 20),
        ),
        body: Center(
          child: Builder(
            builder: (BuildContext innerContext) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Te ajudando a ganhar tempo',
                    style: TextStyle(fontSize: 30),
                  ),
                  Image.asset('assets/taskimage.jpg'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        innerContext, // Aqui usamos innerContext ao invés de context.
                        MaterialPageRoute(
                          builder: (context) => PrincipalPage(
                            selectedDate: DateTime.now(),
                            tarefaController: TarefaController(),
                          ),
                        ),
                      );
                    },
                    child: const Text('Vamos começar'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
