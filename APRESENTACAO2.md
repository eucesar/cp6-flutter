# 🔐 Gerador de Senhas Seguro - Apresentação Técnica

## 📋 Visão Geral do Projeto

Este é um aplicativo Flutter desenvolvido para geração e gerenciamento seguro de senhas, integrado com Firebase para autenticação e armazenamento de dados. O projeto implementa uma arquitetura robusta com separação de responsabilidades e segurança em múltiplas camadas.

## 🏗️ Arquitetura do Sistema

### Estrutura de Pastas
```
lib/
├── core/                    # Lógica central e guardas de autenticação
│   └── auth_guard.dart     # Middleware de autenticação
├── screens/                # Telas da aplicação
│   ├── SplashScreen.dart   # Tela de carregamento inicial
│   ├── IntroScreen.dart    # Tela de introdução/onboarding
│   ├── LoginERegistro.dart # Tela de login e registro
│   ├── HomeScreen.dart     # Tela principal com lista de senhas
│   └── NewPasswordScreen.dart # Tela de geração de senhas
├── widgets/                # Componentes reutilizáveis
│   ├── custom_text_field.dart      # Campo de texto customizado
│   └── password_result_widget.dart # Widget para exibir senhas
├── main.dart              # Ponto de entrada da aplicação
├── routes.dart            # Configuração de rotas
└── firebase_options.dart  # Configuração do Firebase
```

## 🔥 Integração com Firebase

### Configuração Multiplataforma
O projeto utiliza uma configuração dinâmica do Firebase que se adapta à plataforma de execução:

```dart
// main.dart - Configuração por plataforma
FirebaseOptions _firebaseOptionsFromEnv() {
  if(Platform.isAndroid){
    return FirebaseOptions(
      apiKey: dotenv.env['API_KEY_AND']!,
      appId: dotenv.env['APP_ID_AND']!,
      messagingSenderId: '1054039258694',
      projectId: 'checkpoint6-e87bd',
      storageBucket: 'checkpoint6-e87bd.firebasestorage.app',
    );
  }
  // ... configurações para iOS e Windows
}
```

### Serviços Firebase Utilizados

#### 1. **Firebase Authentication**
- **Arquivo principal**: `lib/screens/LoginERegistro.dart`
- **Funcionalidades**:
  - Login com email e senha
  - Registro de novos usuários
  - Gerenciamento de estado de autenticação
  - Logout seguro

```dart
// Exemplo de autenticação
Future<void> _signIn() async {
  await _auth.signInWithEmailAndPassword(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
  );
}
```

#### 2. **Cloud Firestore**
- **Arquivo principal**: `lib/screens/HomeScreen.dart` e `lib/screens/NewPasswordScreen.dart`
- **Funcionalidades**:
  - Armazenamento de senhas geradas
  - Consulta em tempo real
  - Filtragem por usuário
  - Exclusão de registros

```dart
// Estrutura de dados no Firestore
{
  'userId': user.uid,
  'password': 'senha_gerada',
  'label': 'Tipo da senha',
  'createdAt': FieldValue.serverTimestamp()
}
```

### Guard de Autenticação
- **Arquivo**: `lib/core/auth_guard.dart`
- **Funcionalidade**: Middleware que protege rotas sensíveis
- **Implementação**: StreamBuilder que monitora mudanças no estado de autenticação

## 🎨 Interface do Usuário

### Design System
- **Cor primária**: `#2196F3` (Azul Material Design)
- **Tema**: Material Design 3
- **Componentes customizados**: Campos de texto, widgets de senha
- **Animações**: Lottie para splash screen e introdução

### Fluxo de Navegação
1. **Splash Screen** → Verifica autenticação
2. **Intro Screen** → Onboarding (apenas primeira vez)
3. **Login/Registro** → Autenticação do usuário
4. **Home Screen** → Lista de senhas salvas
5. **New Password Screen** → Geração de novas senhas

## 🔐 Geração de Senhas

### API Externa + Fallback Local
O sistema implementa uma estratégia de redundância:

1. **API Externa**: `https://safekey-api-a1bd9aa7953.herokuapp.com/generate`
2. **Gerador Local**: Implementação nativa como fallback

```dart
// Estratégia de geração
Future<void> _generatePassword() async {
  try {
    // Tenta API externa primeiro
    final response = await http.post(url, body: jsonEncode(config));
    if (response.statusCode == 200) {
      // Usa resposta da API
    } else {
      _generatePasswordLocally(); // Fallback
    }
  } catch (e) {
    _generatePasswordLocally(); // Fallback em caso de erro
  }
}
```

### Configurações de Senha
- **Tamanho**: 4-50 caracteres (slider interativo)
- **Tipos de caracteres**:
  - Letras minúsculas (a-z)
  - Letras maiúsculas (A-Z)
  - Números (0-9)
  - Símbolos (!@#$%^&*...)

## 📱 Funcionalidades Principais

### 1. Autenticação Segura
- Login e registro com validação
- Persistência de sessão
- Logout com limpeza de dados

### 2. Geração de Senhas
- Interface intuitiva com opções avançadas
- Visualização/ocultação de senhas
- Cópia para área de transferência
- Salvamento no Firestore

### 3. Gerenciamento de Senhas
- Lista em tempo real
- Exclusão individual
- Organização por tipo/etiqueta
- Interface responsiva

### 4. Experiência do Usuário
- Splash screen com animação
- Onboarding interativo
- Feedback visual (SnackBars)
- Estados de carregamento

## 🛡️ Segurança Implementada

### 1. Autenticação
- Firebase Auth com email/senha
- Validação de formulários
- Guard de rotas protegidas

### 2. Armazenamento
- Dados criptografados no Firestore
- Filtragem por usuário (userId)
- Timestamps para auditoria

### 3. Configuração
- Variáveis de ambiente (.env)
- Chaves API separadas por plataforma
- Configuração dinâmica

## 📦 Dependências Principais

```yaml
dependencies:
  # Firebase
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  
  # UI e Animações
  lottie: ^3.1.2
  
  # Configuração
  flutter_dotenv: ^5.1.0
  shared_preferences: ^2.3.2
  
  # HTTP
  http: ^1.2.2
```

## 🔄 Fluxo de Dados

### 1. Inicialização
```
main.dart → Firebase.initializeApp() → Routes.splash
```

### 2. Autenticação
```
SplashScreen → Verifica currentUser → Intro/Login/Home
```

### 3. Geração de Senha
```
NewPasswordScreen → API Externa/Local → PasswordResultWidget → Firestore
```

### 4. Listagem
```
HomeScreen → StreamBuilder → Firestore Query → ListView
```

## 🚀 Pontos Fortes da Arquitetura

1. **Separação de Responsabilidades**: Cada arquivo tem uma função específica
2. **Reutilização**: Widgets customizados para componentes comuns
3. **Segurança**: Múltiplas camadas de proteção
4. **Escalabilidade**: Estrutura preparada para crescimento
5. **Manutenibilidade**: Código organizado e documentado
6. **UX**: Interface intuitiva com feedback visual

## 📈 Próximos Passos Sugeridos

1. **Testes**: Implementar testes unitários e de widget
2. **Biometria**: Adicionar autenticação biométrica
3. **Backup**: Sincronização com Google Drive/iCloud
4. **Categorias**: Organização avançada de senhas
5. **Importação**: Importar senhas de outros gerenciadores
6. **Notificações**: Alertas de senhas expiradas

---

**Desenvolvido com Flutter e Firebase** | **Arquitetura: Clean Architecture + MVVM**
