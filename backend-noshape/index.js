const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const app = express();
const port = 3000;

// Middleware para aceitar JSON no body das requisições
app.use(express.json());

// Conectar ao banco SQLite
const db = new sqlite3.Database('database.sqlite', (err) => {
    if (err) {
        console.error('Erro ao conectar ao banco de dados:', err);
    } else {
        console.log('Conectado ao banco de dados SQLite');
        
        // Criar tabela de usuários se não existir
        db.run(`
            CREATE TABLE IF NOT EXISTS usuarios (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nome TEXT NOT NULL,
                email TEXT UNIQUE NOT NULL,
                senha TEXT NOT NULL
            )
        `, (err) => {
            if (err) {
                console.error('Erro ao criar tabela:', err);
            } else {
                console.log('Tabela de usuários pronta');
            }
        });
    }
});

// Rota inicial
app.get('/', (req, res) => {
    res.send('Servidor Node + Express + SQLite rodando!');
});

// Rota para obter os usuários
app.get('/usuario', (req, res) => {
    db.all('SELECT id, nome, email FROM usuarios', [], (err, rows) => {
        if (err) {
            res.status(500).json({ erro: 'Erro ao buscar usuários' });
            return;
        }
        res.json(rows);
    });
});

// Rota para cadastrar um usuário
app.post('/usuario', (req, res) => {
    const { nome, email, senha } = req.body;

    // Validação básica dos campos
    if (!nome || !email || !senha) {
        return res.status(400).json({ mensagem: 'Todos os campos são obrigatórios!' });
    }

    // Inserir novo usuário
    const sql = 'INSERT INTO usuarios (nome, email, senha) VALUES (?, ?, ?)';
    db.run(sql, [nome, email, senha], function(err) {
        if (err) {
            if (err.message.includes('UNIQUE constraint failed')) {
                return res.status(409).json({ mensagem: 'Este e-mail já está cadastrado!' });
            }
            console.error('Erro ao cadastrar:', err);
            return res.status(500).json({ mensagem: 'Erro ao cadastrar usuário' });
        }

        console.log('Novo usuário cadastrado:', nome, email);
        return res.status(201).json({ 
            mensagem: 'Usuário cadastrado com sucesso!',
            id: this.lastID 
        });
    });
});

// Rota de login
app.post('/api/login', (req, res) => {
    const { email, senha } = req.body;

    if (!email || !senha) {
        return res.status(400).json({ mensagem: 'E-mail e senha são obrigatórios!' });
    }

    const sql = 'SELECT * FROM usuarios WHERE email = ? AND senha = ?';
    db.get(sql, [email, senha], (err, usuario) => {
        if (err) {
            console.error('Erro ao fazer login:', err);
            return res.status(500).json({ mensagem: 'Erro ao fazer login' });
        }

        if (usuario) {
            return res.status(200).json({ 
                mensagem: 'Login realizado com sucesso!',
                usuario: {
                    id: usuario.id,
                    nome: usuario.nome,
                    email: usuario.email
                }
            });
        } else {
            return res.status(401).json({ mensagem: 'Credenciais inválidas!' });
        }
    });
});

// Iniciar o servidor
app.listen(port, () => {
    console.log(`Servidor rodando na porta ${port}`);
});