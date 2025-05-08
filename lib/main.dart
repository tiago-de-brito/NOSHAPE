import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: LoginScreen(),
    );
  }
}

// Tela de Login
class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  Future<void> loginUser(BuildContext context, String email, String senha) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'senha': senha,
      }),
    );

    if (response.statusCode == 200) {
      print('Login bem-sucedido');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login bem-sucedido!')),
      );
      // Navegar para a próxima tela após o login, se necessário
    } else {
      print('Erro ao fazer login: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/IMG_6624.jpeg', width: 300, height: 300),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha', border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  loginUser(context, emailController.text, senhaController.text);
                },
                child: Text('Entrar'),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroScreen()),
                );
              },
              child: Text('Não tem uma conta? Cadastre-se'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecuperarSenhaScreen()),
                );
              },
              child: Text('Esqueceu sua senha?'),
            ),
          ],
        ),
      ),
    );
  }
}

// Tela de Cadastro
class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  Future<void> cadastrarUsuario(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/usuario'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': nomeController.text,
        'email': emailController.text,
        'senha': senhaController.text,
      }),
    );

    if (response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sucesso'),
          content: Text('Cadastro realizado!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha alerta
                Navigator.pop(context); // Volta para tela de login
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      print('Erro ao cadastrar: ${response.statusCode} - ${response.body}');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Falha ao cadastrar.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Para não estourar se abrir teclado
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/IMG_6624.jpeg',
                width: 300,
                height: 300,
              ),
              SizedBox(height: 20),
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: senhaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    cadastrarUsuario(context);
                  },
                  child: Text('Cadastrar'),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Já tem uma conta? Faça login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tela de Recuperar Senha (sem alterações na lógica de envio do e-mail)
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