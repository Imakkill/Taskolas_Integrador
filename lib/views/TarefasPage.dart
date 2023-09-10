// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../controllers/tarefasController.dart';
import '../models/tarefas.dart';

class TarefaPage extends StatefulWidget {
  final Tarefa tarefa;
  final TarefaController tarefaController;

  const TarefaPage(
      {super.key, required this.tarefa, required this.tarefaController});

  @override
  // ignore: library_private_types_in_public_api
  _TarefaPageState createState() => _TarefaPageState();
}

class _TarefaPageState extends State<TarefaPage> {
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late bool _isConcluido; // 1. Estado local para rastrear o status da tarefa

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.tarefa.nome);
    _descricaoController = TextEditingController(text: widget.tarefa.descricao);
    _isConcluido =
        widget.tarefa.status; // Inicialize com o status atual da tarefa
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes da Tarefa"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red, // Isso muda a cor do ícone para vermelho
            ),
            onPressed: () async {
              await widget.tarefaController.removerTarefa(widget.tarefa.id!);
              Navigator.pop(context, true); // Retorne `true` ao fazer pop
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: "Nome da Tarefa",
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: "Descrição",
              ),
            ),
            const SizedBox(height: 16.0),
            CheckboxListTile(
              // 2. Adicione um CheckboxListTile
              title: const Text("Concluído"),
              value: _isConcluido,
              onChanged: (value) {
                setState(() {
                  _isConcluido = value!;
                });
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                Tarefa updatedTarefa = Tarefa(
                  id: widget.tarefa.id,
                  nome: _nomeController.text,
                  descricao: _descricaoController.text,
                  dataHora: widget.tarefa.dataHora,
                  status: _isConcluido,
                );
                await widget.tarefaController.atualizarTarefa(updatedTarefa);

                Navigator.pop(context, true); // Retorne `true` ao fazer pop
              },
              child: const Text("Salvar Alterações"),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }
}
