# App Flutter com Backend Node.js e SQLite

Este é um aplicativo Flutter com backend em Node.js e banco de dados SQL Server, implementando um sistema de acompanhamento de progressão de treino.

## 🚀 Tecnologias

- Frontend: Flutter  
- Backend: Node.js + Express  
- Banco de dados: SQL Server  
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
   npm install cors
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
- Persistência de dados com SQL Server  
- Inserir dados de treino  
- Acompanhar Progresso  

> O endereço `10.0.2.2:3000` é usado para acessar o localhost a partir do emulador Android  
> Para dispositivos físicos, altere o IP no arquivo `lib/main.dart` para o IP da sua máquina

## 📝 Licença

Este projeto está sob a licença MIT.
