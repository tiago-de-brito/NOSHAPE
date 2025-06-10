import 'package:flutter/material.dart';
import 'inserir_serie_screen.dart';

class AdicionarTreinoScreen extends StatelessWidget {
  final int usuarioId;

  AdicionarTreinoScreen({required this.usuarioId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Treino')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InserirSerieScreen(
                      usuarioId: usuarioId,
                      nomeExercicio: 'Supino',
                    ),
                  ),
                );
              },
              child: Text('Supino'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InserirSerieScreen(
                      usuarioId: usuarioId,
                      nomeExercicio: 'Remada',
                    ),
                  ),
                );
              },
              child: Text('Remada'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InserirSerieScreen(
                      usuarioId: usuarioId,
                      nomeExercicio: 'Agachamento',
                    ),
                  ),
                );
              },
              child: Text('Agachamento'),
            ),
          ],
        ),
      ),
    );
  }
}
