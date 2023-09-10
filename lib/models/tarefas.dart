import 'package:cloud_firestore/cloud_firestore.dart';

class Tarefa {
  final String? id;
  final String nome;
  final String descricao;
  final DateTime dataHora;
  final bool status; // Novo campo

  Tarefa({
    this.id,
    required this.nome,
    required this.descricao,
    required this.dataHora,
    this.status = false, // Defina um valor padrão
  });

  Tarefa copyWith({
    String? id,
    String? nome,
    String? descricao,
    DateTime? dataHora,
    bool? status, // Novo campo
  }) {
    return Tarefa(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      dataHora: dataHora ?? this.dataHora,
      status: status ?? this.status, // Novo campo
    );
  }

  // Converte um documento do Firebase para a model Tarefa
  factory Tarefa.fromDocument(QueryDocumentSnapshot doc) {
    return Tarefa(
      id: doc.id,
      nome: doc['nome'],
      descricao: doc['descricao'],
      dataHora: DateTime.fromMillisecondsSinceEpoch(doc['dataHora']),
      status: doc['status'] ??
          false, // Aqui nós pegamos o status, e se ele não existir, o valor padrão será false
    );
  }

  // Converte a model Tarefa para um formato adequado para o Firebase
  Map<String, dynamic> toFirestore() {
    final data = {
      'nome': nome,
      'descricao': descricao,
      'dataHora': dataHora.millisecondsSinceEpoch,
      'status': status, // Adicione o campo status
    };

    if (id != null) {
      data['id'] = id!;
    }

    return data;
  }
}
