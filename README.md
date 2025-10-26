# 🔐 Gerador de Senhas Seguro

**Projeto desenvolvido para o Checkpoint 6 - Flutter com Firebase**

---

## 👥 **Desenvolvedores**
- **Cesar Iglesias** - RM: 98007
- **Guilherme Luis Engel** - RM: 87438

---

## 📱 **Sobre o Projeto**

Aplicativo Flutter integrado ao Firebase Authentication e Cloud Firestore que permite:
- ✅ Login e registro de usuários
- ✅ Geração de senhas seguras via API externa
- ✅ Armazenamento de senhas no Firestore
- ✅ Interface moderna com animações Lottie
- ✅ Proteção de rotas com autenticação

---

## 🎥 **Demonstração em Vídeo**

> **📹 [CLIQUE AQUI PARA ASSISTIR AO VÍDEO DEMONSTRATIVO](https://youtube.com/watch?v=SEU_VIDEO_AQUI)**
> 
> *O vídeo mostra todas as funcionalidades do aplicativo em funcionamento*

---

## 🚀 **Tecnologias Utilizadas**

### **Frontend**
- **Flutter** - Framework de desenvolvimento
- **Dart** - Linguagem de programação
- **Material Design** - Design system

### **Backend & Serviços**
- **Firebase Authentication** - Autenticação de usuários
- **Cloud Firestore** - Banco de dados NoSQL
- **HTTP** - Integração com API externa
- **SharedPreferences** - Armazenamento local

### **UI/UX**
- **Lottie** - Animações vetoriais
- **Flutter Dotenv** - Gerenciamento de variáveis de ambiente

---

## 📁 **Estrutura do Projeto**

```
lib/
├── core/
│   └── auth_guard.dart          # Proteção de rotas
├── screens/
│   ├── SplashScreen.dart        # Tela inicial com animação
│   ├── IntroScreen.dart         # Onboarding com PageView
│   ├── LoginERegistro.dart      # Autenticação
│   ├── HomeScreen.dart          # Lista de senhas
│   └── NewPasswordScreen.dart   # Gerador de senhas
├── widgets/
│   ├── custom_text_field.dart   # Campo personalizado
│   └── password_result_widget.dart # Exibição de senha
├── main.dart                    # Configuração principal
├── routes.dart                  # Sistema de navegação
└── firebase_options.dart        # Configuração Firebase
```

---

## 🔧 **Configuração e Instalação**

### **Pré-requisitos**
- Flutter SDK 3.0+
- Dart 3.0+
- Firebase CLI
- Android Studio / VS Code

### **Instalação**
```bash
# Clone o repositório
git clone https://github.com/seu-usuario/gerador-senhas.git

# Entre no diretório
cd gerador-senhas

# Instale as dependências
flutter pub get

# Configure o arquivo .env (veja seção de configuração)
# Execute o projeto
flutter run
```

### **Configuração do Firebase**
1. Crie um projeto no [Firebase Console](https://console.firebase.google.com)
2. Configure Authentication (Email/Password)
3. Configure Firestore Database
4. Crie o arquivo `.env` na raiz do projeto:

```env
API_KEY_AND=sua_api_key_android
APP_ID_AND=seu_app_id_android
API_KEY_IOS=sua_api_key_ios
APP_ID_IOS=seu_app_id_ios
API_KEY_WIN=sua_api_key_windows
APP_ID_WIN=seu_app_id_windows
```

---

## 🎯 **Funcionalidades Implementadas**

### **1. SplashScreen**
- **Arquivo**: `lib/screens/SplashScreen.dart`
- **Funcionalidade**: Tela inicial com animação Lottie
- **Lógica**: Verifica usuário logado e redireciona adequadamente

```dart
// Verificação de autenticação
final user = FirebaseAuth.instance.currentUser;
if (user != null) {
  Navigator.pushReplacementNamed(context, Routes.home);
} else if (showIntro) {
  Navigator.pushReplacementNamed(context, Routes.intro);
} else {
  Navigator.pushReplacementNamed(context, Routes.login);
}
```

### **2. IntroScreen (Onboarding)**
- **Arquivo**: `lib/screens/IntroScreen.dart`
- **Funcionalidade**: 3 páginas com PageView e animações Lottie
- **Recursos**: Checkbox "Não mostrar novamente" salvo no SharedPreferences

```dart
// PageView com animações
PageView.builder(
  controller: _pageController,
  itemCount: _pages.length,
  itemBuilder: (context, index) {
    return Lottie.asset(_pages[index]['lottie']!);
  },
)
```

### **3. Sistema de Autenticação**
- **Arquivo**: `lib/screens/LoginERegistro.dart`
- **Funcionalidade**: Login e registro com validação
- **Recursos**: CustomTextField, tratamento de erros específicos

```dart
// Validação de email
validator: (value) {
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Digite um email válido';
  }
  return null;
}
```

### **4. Proteção de Rotas (AuthGuard)**
- **Arquivo**: `lib/core/auth_guard.dart`
- **Funcionalidade**: Protege rotas Home e NewPassword
- **Implementação**: StreamBuilder com Firebase Auth

```dart
StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.data == null) {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
    return child; // Widget protegido
  },
)
```

### **5. HomeScreen (Lista de Senhas)**
- **Arquivo**: `lib/screens/HomeScreen.dart`
- **Funcionalidade**: Lista senhas do Firestore com StreamBuilder
- **Recursos**: Mostrar/ocultar senha, copiar, excluir

```dart
// StreamBuilder para dados em tempo real
StreamBuilder<QuerySnapshot>(
  stream: _firestore
      .collection('passwords')
      .where('userId', isEqualTo: user?.uid)
      .snapshots(),
  builder: (context, snapshot) {
    // Renderiza lista de senhas
  },
)
```

### **6. Gerador de Senhas**
- **Arquivo**: `lib/screens/NewPasswordScreen.dart`
- **Funcionalidade**: Geração via API externa com fallback local
- **Recursos**: Configuração de tamanho e tipos de caracteres

```dart
// Fallback inteligente
try {
  // Tenta API externa
  final response = await http.post(url, ...);
  if (response.statusCode == 200) {
    // Usa API
  } else {
    _generatePasswordLocally(); // Fallback
  }
} catch (e) {
  _generatePasswordLocally(); // Fallback
}
```

---

## 🎨 **Design e UX**

### **Tema Personalizado**
- **Cores**: Azul (#2196F3) como cor primária
- **Componentes**: Botões, campos e cards estilizados
- **Responsividade**: Interface adaptável

### **Animações Lottie**
- **Splash**: Animação de carregamento
- **Intro**: 3 animações contextuais para onboarding
- **Transições**: Animações suaves entre telas

### **Widgets Personalizados**
- **CustomTextField**: Campo reutilizável com validação
- **PasswordResultWidget**: Exibição de senha com opções

---

## 🔒 **Segurança**

### **Autenticação**
- Firebase Authentication com email/senha
- Validação de tokens
- Logout automático em caso de erro

### **Dados**
- Senhas isoladas por usuário no Firestore
- Chaves do Firebase em variáveis de ambiente
- Validação de entrada em todos os campos

### **Rotas Protegidas**
- AuthGuard impede acesso não autorizado
- Redirecionamento automático para login
- Verificação contínua de autenticação

---

## 📊 **Estrutura de Dados (Firestore)**

### **Coleção: passwords**
```json
{
  "userId": "string",      // ID do usuário autenticado
  "password": "string",    // Senha gerada
  "label": "string",       // Rótulo da senha
  "createdAt": "timestamp" // Data de criação
}
```

---

## 🚀 **Como Executar**

1. **Configure o Firebase** (veja seção de configuração)
2. **Instale as dependências**: `flutter pub get`
3. **Execute o projeto**: `flutter run`
4. **Teste as funcionalidades**:
   - Registre um usuário
   - Gere senhas
   - Salve e visualize senhas
   - Teste logout e proteção de rotas

---

## 📱 **Telas do Aplicativo**

### **1. SplashScreen**
- Animação Lottie centralizada
- Verificação de autenticação
- Redirecionamento inteligente

### **2. IntroScreen**
- 3 páginas com PageView
- Animações Lottie contextuais
- Checkbox "Não mostrar novamente"

### **3. Login/Registro**
- Formulário com validação
- Tratamento de erros específicos
- CustomTextField personalizado

### **4. HomeScreen**
- Lista de senhas do usuário
- Banner Premium
- Funcionalidades: mostrar/ocultar, copiar, excluir

### **5. NewPasswordScreen**
- Gerador de senhas configurável
- Integração com API externa
- Fallback para geração local

---

## 🎯 **Pontos de Destaque para Apresentação**

### **1. Arquitetura Limpa**
- Separação de responsabilidades
- Widgets reutilizáveis
- Código bem documentado

### **2. Integração Firebase**
- Authentication robusto
- Firestore em tempo real
- Configuração multi-plataforma

### **3. UX/UI Moderna**
- Animações Lottie contextuais
- Tema personalizado
- Interface intuitiva

### **4. Segurança**
- Rotas protegidas
- Dados isolados por usuário
- Validação rigorosa

### **5. Robustez**
- Fallback para API externa
- Tratamento de erros
- Estados de loading

---

## 📈 **Melhorias Futuras**

- [ ] Biometria para autenticação
- [ ] Categorização de senhas
- [ ] Exportação de senhas
- [ ] Modo escuro
- [ ] Notificações de senhas expiradas

---

## 📞 **Contato**

- **Cesar Iglesias** - RM: 98007
- **Guilherme Luis Engel** - RM: 87438

---

## 📄 **Licença**

Este projeto foi desenvolvido para fins acadêmicos no curso de Flutter.

---

*Desenvolvido com ❤️ usando Flutter e Firebase*