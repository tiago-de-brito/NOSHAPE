import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InserirSerieScreen extends StatefulWidget {
  final int usuarioId;
  final String nomeExercicio;

  InserirSerieScreen({required this.usuarioId, required this.nomeExercicio});

  @override
  _InserirSerieScreenState createState() => _InserirSerieScreenState();
}

class _InserirSerieScreenState extends State<InserirSerieScreen> {
  final TextEditingController repeticoesController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();

  Future<void> inserirTreino() async {
    final int? repeticoes = int.tryParse(repeticoesController.text);
    final double? peso = double.tryParse(pesoController.text);

    if (repeticoes == null || peso == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos corretamente.')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://localhost:3000/treino'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'usuario_id': widget.usuarioId,
        'nome_exercicio': widget.nomeExercicio,
        'repeticoes': repeticoes,
        'peso': peso,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Série inserida com sucesso!')),
      );
      repeticoesController.clear();
      pesoController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao inserir treino.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inserir Série - ${widget.nomeExercicio}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: repeticoesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Repetições'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: pesoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Peso (kg)'),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: inserirTreino,
                child: Text('Inserir Série'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
