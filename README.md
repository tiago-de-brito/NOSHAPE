# App Flutter com Backend Node.js e SQLite

Este é um aplicativo Flutter com backend em Node.js e banco de dados SQLite, implementando um sistema de autenticação completo.

## 🚀 Tecnologias

- Frontend: Flutter
- Backend: Node.js + Express
- Banco de dados: SQLite
- Autenticação: Local (email/senha)

## 📋 Pré-requisitos

- Node.js (v20.x ou superior)
- Flutter (última versão estável)
- Android Studio ou VS Code
- Emulador Android ou dispositivo físico

## 🔧 Instalação e Execução

### Backend

1. Entre na pasta do backend:
```bash
cd backend-noshape
```

2. Instale as dependências:
```bash
npm install
```

3. Inicie o servidor:
```bash
node index.js
```

O servidor estará rodando em `http://localhost:3000`

### Frontend (Flutter)

1. Na pasta raiz do projeto, instale as dependências:
```bash
flutter pub get
```

2. Execute o aplicativo:
```bash
flutter run
```

## 📱 Funcionalidades

- Login de usuários
- Cadastro de novos usuários
- Recuperação de senha
- Persistência de dados com SQLite

## 🗄️ Estrutura do Banco de Dados

O banco de dados SQLite possui uma tabela `usuarios` com os seguintes campos:
- id (INTEGER PRIMARY KEY AUTOINCREMENT)
- nome (TEXT NOT NULL)
- email (TEXT UNIQUE NOT NULL)
- senha (TEXT NOT NULL)

## 🔌 Endpoints da API

- POST `/api/login` - Login de usuário
- POST `/usuario` - Cadastro de usuário
- GET `/usuario` - Lista todos os usuários

## 👨‍💻 Desenvolvimento

Para contribuir com o projeto:

1. Faça um fork do repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## ⚠️ Observações

- O backend usa SQLite para facilitar o desenvolvimento local
- O endereço `10.0.2.2:3000` é usado para acessar o localhost a partir do emulador Android
- Para dispositivos físicos, altere o IP no arquivo `lib/main.dart` para o IP da sua máquina

## 📝 Licença

Este projeto está sob a licença MIT.
