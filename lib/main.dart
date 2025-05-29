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
    Uri.parse('http://localhost:3000/api/login'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'email': email,
      'senha': senha,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final int usuarioId = data['usuario']['id'];

    print('Login bem-sucedido, ID do usuário: $usuarioId');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(usuarioId: usuarioId)),
    );
  } else {
    print('Erro ao fazer login: ${response.statusCode} - ${response.body}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao fazer login.')),
    );
    print('Email digitado: $email');
    print('Senha digitada: $senha');
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
      Uri.parse('http://localhost:3000/usuario'),
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
// Tela Inicial após login
class HomeScreen extends StatelessWidget {
  final int usuarioId;

  HomeScreen({required this.usuarioId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Página Inicial')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AcompanharProgressoScreen()),
                    );
                  },
                  child: Text('Acompanhar Progresso'),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AlterarDadosScreen()),
                    );
                  },
                  child: Text('Alterar Dados'),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ComoUsarScreen()),
                    );
                  },
                  child: Text('Como Usar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class AdicionarTreinoScreen extends StatelessWidget {
  final int usuarioId;

  AdicionarTreinoScreen({required this.usuarioId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Treino')),
      body: Center(
        child: Padding(
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
                        usuarioId: usuarioId, // certifique-se que essa variável esteja disponível
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
                          usuarioId: usuarioId, // certifique-se que essa variável esteja disponível
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
      ),
    );
  }
}


class AcompanharProgressoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acompanhar Progresso')),
      body: Center(child: Text('Página Acompanhar Progresso')),
    );
  }
}

class AlterarDadosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alterar Dados')),
      body: Center(child: Text('Página Alterar Dados')),
    );
  }
}

class ComoUsarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Como Usar')),
      body: Center(child: Text('Página Como Usar')),
    );
  }
}
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
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Série ${data['serie']} inserida com sucesso!')),
      );
      repeticoesController.clear();
      pesoController.clear();
    } else {
      print('Erro ao inserir treino: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao inserir treino')),
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