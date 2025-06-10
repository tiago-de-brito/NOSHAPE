import 'package:flutter/material.dart';
import 'adicionar_treino_screen.dart';
import 'acompanhar_progresso_screen.dart';

class HomeScreen extends StatelessWidget {
  final int usuarioId;

  HomeScreen({required this.usuarioId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Página Inicial')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdicionarTreinoScreen(usuarioId: usuarioId),
                  ),
                );
              },
              child: Text('Adicionar Treino'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AcompanharProgressoScreen(usuarioId: usuarioId),
                  ),
                );
              },
              child: Text('Acompanhar Progresso'),
            ),
          ],
        ),
      ),
    );
  }
}
