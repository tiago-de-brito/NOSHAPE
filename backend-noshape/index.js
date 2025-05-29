const express = require('express');
const { sql, config } = require('./db');
const app = express();
const port = 3000;
const cors = require('cors');
app.use(cors());


// Middleware para aceitar JSON
app.use(express.json());

// Conectar ao SQL Server e criar tabelas se não existirem
sql.connect(config).then(async pool => {
    await pool.request().query(`
        IF NOT EXISTS (
            SELECT * FROM sysobjects WHERE name='usuarios' AND xtype='U'
        )
        CREATE TABLE usuarios (
            id INT PRIMARY KEY IDENTITY,
            nome NVARCHAR(100) NOT NULL,
            email NVARCHAR(100) NOT NULL UNIQUE,
            senha NVARCHAR(100) NOT NULL
        )
    `);

    await pool.request().query(`
        IF NOT EXISTS (
            SELECT * FROM sysobjects WHERE name='treinos' AND xtype='U'
        )
        CREATE TABLE treinos (
            id INT PRIMARY KEY IDENTITY,
            usuario_id INT NOT NULL,
            nome_exercicio NVARCHAR(100) NOT NULL,
            repeticoes INT NOT NULL,
            peso DECIMAL(10, 2) NOT NULL,
            serie_numero INT NOT NULL,
            data DATETIME NOT NULL DEFAULT GETDATE(),
            FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
        )
    `);

    console.log('Conectado ao SQL Server, tabelas verificadas');
}).catch(err => {
    console.error('Erro na conexão ou criação das tabelas:', err);
});

// Rota raiz
app.get('/', (req, res) => {
    res.send('Servidor Node + Express + SQL Server rodando!');
});

// Listar usuários
app.get('/usuario', async (req, res) => {
    try {
        const pool = await sql.connect(config);
        const result = await pool.request().query('SELECT id, nome, email FROM usuarios');
        res.json(result.recordset);
    } catch (err) {
        console.error('Erro ao buscar usuários:', err);
        res.status(500).json({ erro: 'Erro ao buscar usuários' });
    }
});

// Cadastrar novo usuário
app.post('/usuario', async (req, res) => {
    const { nome, email, senha } = req.body;

    if (!nome || !email || !senha) {
        return res.status(400).json({ mensagem: 'Todos os campos são obrigatórios!' });
    }

    try {
        const pool = await sql.connect(config);
        await pool.request()
            .input('nome', sql.NVarChar, nome)
            .input('email', sql.NVarChar, email)
            .input('senha', sql.NVarChar, senha)
            .query('INSERT INTO usuarios (nome, email, senha) VALUES (@nome, @email, @senha)');

        res.status(201).json({ mensagem: 'Usuário cadastrado com sucesso!' });
    } catch (err) {
        if (err.originalError?.info?.number === 2627) {
            return res.status(409).json({ mensagem: 'Este e-mail já está cadastrado!' });
        }
        console.error('Erro ao cadastrar usuário:', err);
        res.status(500).json({ mensagem: 'Erro ao cadastrar usuário' });
    }
});

// Login
app.post('/api/login', async (req, res) => {
    const { email, senha } = req.body;

    if (!email || !senha) {
        return res.status(400).json({ mensagem: 'E-mail e senha são obrigatórios!' });
    }

    try {
        const pool = await sql.connect(config);
        const result = await pool.request()
            .input('email', sql.NVarChar, email)
            .input('senha', sql.NVarChar, senha)
            .query('SELECT id, nome, email FROM usuarios WHERE email = @email AND senha = @senha');

        const usuario = result.recordset[0];

        if (usuario) {
            res.status(200).json({ mensagem: 'Login realizado com sucesso!', usuario });
        } else {
            res.status(401).json({ mensagem: 'Credenciais inválidas!' });
        }
    } catch (err) {
        console.error('Erro ao fazer login:', err);
        res.status(500).json({ mensagem: 'Erro ao fazer login' });
    }
});

// Iniciar o servidor
app.listen(port, () => {
    console.log(`Servidor rodando na porta ${port}`);
});

// Inserir treino
app.post('/treino', async (req, res) => {
    const { usuario_id, nome_exercicio, repeticoes, peso } = req.body;

    if (!usuario_id || !nome_exercicio || !repeticoes || !peso) {
        return res.status(400).json({ mensagem: 'Todos os campos são obrigatórios!' });
    }

    try {
        const pool = await sql.connect(config);

        // Contar quantas séries já foram feitas hoje para este exercício por este usuário
        const hoje = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
        const countResult = await pool.request()
            .input('usuario_id', sql.Int, usuario_id)
            .input('nome_exercicio', sql.NVarChar, nome_exercicio)
            .input('hoje', sql.Date, hoje)
            .query(`
                SELECT COUNT(*) AS total_series 
                FROM treinos 
                WHERE usuario_id = @usuario_id 
                AND nome_exercicio = @nome_exercicio 
                AND CAST(data AS DATE) = @hoje
            `);

        const numeroSerie = countResult.recordset[0].total_series + 1;

        // Inserir o treino
        await pool.request()
            .input('usuario_id', sql.Int, usuario_id)
            .input('nome_exercicio', sql.NVarChar, nome_exercicio)
            .input('repeticoes', sql.Int, repeticoes)
            .input('peso', sql.Decimal(10, 2), peso)
            .input('serie_numero', sql.Int, numeroSerie)
            .query(`
                INSERT INTO treinos (usuario_id, nome_exercicio, repeticoes, peso, serie_numero)
                VALUES (@usuario_id, @nome_exercicio, @repeticoes, @peso, @serie_numero)
            `);

        res.status(201).json({ mensagem: 'Treino inserido com sucesso!', serie: numeroSerie });
    } catch (err) {
        console.error('Erro ao inserir treino:', err);
        res.status(500).json({ mensagem: 'Erro ao inserir treino' });
    }
});
