// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '/models/tarefas.dart';
import '../controllers/tarefasController.dart';
import 'principalPage.dart';

class CriarTarefaPage extends StatefulWidget {
  final DateTime selectedDate; // Declare a variável selectedDate
  final TarefaController tarefaController;

  const CriarTarefaPage({
    super.key,
    required this.selectedDate, // Receba a data selecionada no construtor
    required this.tarefaController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CriarTarefaPageState createState() => _CriarTarefaPageState();
}

class _CriarTarefaPageState extends State<CriarTarefaPage> {
  final _formKey = GlobalKey<FormState>();
  final TarefaController _tarefaController = TarefaController();
  String _nome = '';
  String _descricao = '';
  DateTime _dataHora = DateTime.now();

  Future<void> _selecionarDataHora() async {
    DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: _dataHora,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (dataEscolhida != null) {
      // ignore: use_build_context_synchronously
      TimeOfDay? horaEscolhida = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (horaEscolhida != null) {
        setState(() {
          _dataHora = DateTime(
            dataEscolhida.year,
            dataEscolhida.month,
            dataEscolhida.day,
            horaEscolhida.hour,
            horaEscolhida.minute,
          );
        });
      }
    }
  }

  Future<void> _adicionarTarefa() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Tarefa novaTarefa = Tarefa(
        nome: _nome,
        descricao: _descricao,
        dataHora: _dataHora,
      );
      await _tarefaController.adicionarTarefa(novaTarefa);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PrincipalPage(
            selectedDate: widget.selectedDate, // Use widget.selectedDate
            tarefaController: widget.tarefaController,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome da Tarefa'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o nome da tarefa.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nome = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira uma descrição.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _descricao = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selecionarDataHora,
                child: Text(
                  'Escolher Data e Hora: ${_dataHora.day}/${_dataHora.month}/${_dataHora.year} ${_dataHora.hour}:${_dataHora.minute}',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _adicionarTarefa,
                child: const Text('Adicionar Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
