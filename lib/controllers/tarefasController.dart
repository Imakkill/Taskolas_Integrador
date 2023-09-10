// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/tarefas.dart';

class TarefaController with ChangeNotifier {
  List<Tarefa> _tarefas = [];
  final CollectionReference tarefas =
      FirebaseFirestore.instance.collection('tarefas');

  List<Tarefa> get todas => [..._tarefas];

  Future<void> adicionarTarefa(Tarefa tarefa) async {
    Tarefa tarefaSalva = await salvarTarefa(tarefa);
    if (!_tarefas.any((t) => t.id == tarefaSalva.id)) {
      _tarefas.add(tarefaSalva);
      notifyListeners();
    }
  }

  Future<Tarefa> salvarTarefa(Tarefa tarefa) async {
    if (tarefa.id == null) {
      DocumentReference docRef = await tarefas.add(tarefa.toFirestore());
      return tarefa.copyWith(id: docRef.id);
    } else {
      await tarefas.doc(tarefa.id).update(tarefa.toFirestore());
      return tarefa;
    }
  }

  Future<void> atualizarTarefa(Tarefa tarefa) async {
    try {
      await salvarTarefa(tarefa);

      // Verifique se a tarefa já existe na lista _tarefas
      int index = _tarefas.indexWhere((t) => t.id == tarefa.id);

      if (index != -1) {
        // Atualiza a tarefa existente na lista
        _tarefas[index] = tarefa;
        notifyListeners();
      }
    } catch (error) {
      print('Erro ao atualizar tarefa: $error');
      throw error; // Re-lance o erro para ser tratado em um nível superior, se necessário
    }
  }

  Future<void> removerTarefa(String id) async {
    print("Tentando remover tarefa com ID: $id");
    await tarefas.doc(id).delete();
    _tarefas.removeWhere((tarefa) => tarefa.id == id);
    notifyListeners();
  }

  Future<void> fetchTarefas() async {
    QuerySnapshot snapshot = await tarefas.get();
    List<Tarefa> fetchedTarefas = snapshot.docs.map((doc) {
      return Tarefa.fromDocument(doc); // Esta linha foi modificada
    }).toList();
    _tarefas = fetchedTarefas; // Redefina a lista _tarefas
    notifyListeners();
  }

  List<Tarefa> getTarefasParaData(DateTime data) {
    return _tarefas.where((tarefa) {
      final tarefaData =
          tarefa.dataHora.toLocal(); // Converter para a zona horária local
      return tarefaData.year == data.year &&
          tarefaData.month == data.month &&
          tarefaData.day == data.day;
    }).toList();
  }
}
