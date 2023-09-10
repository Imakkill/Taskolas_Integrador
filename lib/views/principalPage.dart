// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/tarefasController.dart';
import 'CriarTarefasPage.dart';
import 'TarefasPage.dart';

class PrincipalPage extends StatefulWidget {
  final DateTime selectedDate;
  final TarefaController tarefaController;

  const PrincipalPage(
      {Key? key, required this.selectedDate, required this.tarefaController})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Tarefas para ${_currentDate.day}/${_currentDate.month}/${_currentDate.year}'),
      ),
      body: FutureBuilder(
        future: widget.tarefaController.fetchTarefas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar tarefas.'));
          } else {
            final tarefasDoDia =
                widget.tarefaController.getTarefasParaData(_currentDate);

            return Stack(
              children: [
                ListView.builder(
                  itemCount: tarefasDoDia.length,
                  itemBuilder: (context, index) {
                    final tarefa = tarefasDoDia[index];
                    final horaFormatada = DateFormat('HH:mm')
                        .format(tarefa.dataHora); // Formata a hora.
                    return ListTile(
                      title: Text(tarefa.nome),
                      subtitle: Text('${tarefa.descricao} - $horaFormatada'),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TarefaPage(
                              tarefa: tarefa,
                              tarefaController: widget.tarefaController,
                            ),
                          ),
                        );

                        if (result != null && result == true) {
                          setState(
                              () {}); // Isso irá disparar a reconstrução da tela e refazer a chamada do FutureBuilder
                        }
                      },

                      // Outros detalhes da tarefa, se necessário
                    );
                  },
                ),
                Positioned(
                  bottom: 10.0,
                  left: 10.0,
                  child: FloatingActionButton(
                    heroTag: "calendar",
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _currentDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null && pickedDate != _currentDate) {
                        setState(() {
                          _currentDate = pickedDate;
                        });
                      }
                    },
                    tooltip: 'Selecionar dia',
                    child: const Icon(Icons.calendar_today),
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  right: 10.0,
                  child: FloatingActionButton(
                    heroTag: "taskCreate",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CriarTarefaPage(
                            selectedDate:
                                _currentDate, // Passe a data selecionada
                            tarefaController: widget.tarefaController,
                          ),
                        ),
                      );
                    },
                    tooltip: 'Ir para a próxima página',
                    child: const Icon(Icons.navigate_next),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
