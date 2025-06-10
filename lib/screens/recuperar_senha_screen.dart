// Tela de Recuperar Senha (sem alterações na lógica de envio do e-mail)
import 'package:flutter/material.dart';

class RecuperarSenhaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recuperar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/IMG_6624.jpeg', width: 300, height: 300),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Digite seu e-mail para recuperar a senha',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // A lógica para enviar o email de recuperação seria implementada aqui
                },
                child: Text('Recuperar Senha'),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Voltar para o login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
