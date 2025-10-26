# 🎤 **Apresentação Técnica - Gerador de Senhas**

**Cesar Iglesias (RM: 98007) e Guilherme Luis Engel (RM: 87438)**

---

## 📱 **Análise Técnica das Telas**

### **1. SplashScreen - Inicialização e Roteamento**

**Funcionamento Interno:**
```dart
Future<void> _nextScreen() async {
  await Future.delayed(const Duration(milliseconds: 2000));
  
  // Verifica autenticação sem validação complexa
  final user = FirebaseAuth.instance.currentUser;
  
  // Consulta SharedPreferences para onboarding
  final prefs = await SharedPreferences.getInstance();
  final showIntro = prefs.getBool('show_intro') ?? true;
  
  // Roteamento inteligente baseado no estado
  if (user != null) {
    Navigator.pushReplacementNamed(context, Routes.home);
  } else if (showIntro) {
    Navigator.pushReplacementNamed(context, Routes.intro);
  } else {
    Navigator.pushReplacementNamed(context, Routes.login);
  }
}
```

**Características Técnicas:**
- **Animação Lottie**: `assets/lottie/splash.json` centralizada
- **Lógica de Roteamento**: Decisão baseada em estado de autenticação
- **Persistência Local**: SharedPreferences para controle de onboarding
- **Performance**: Delay de 2 segundos para sincronizar com animação

---

### **2. IntroScreen - Onboarding com PageView**

**Funcionamento Interno:**
```dart
PageView.builder(
  controller: _pageController,
  itemCount: _pages.length,
  onPageChanged: (index) {
    setState(() => _currentPage = index);
  },
  itemBuilder: (context, index) {
    return Lottie.asset(_pages[index]['lottie']!);
  },
)
```

**Estrutura de Dados:**
```dart
final List<Map<String, String>> _pages = [
  {
    'title': 'Bem-vindo ao App',
    'subtitle': 'Aprenda a usar o app passo a passo.',
    'lottie': 'assets/lottie/intro1.json',
  },
  // ... mais páginas
];
```

**Características Técnicas:**
- **PageView**: Navegação horizontal entre páginas
- **Animações Lottie**: 3 animações contextuais diferentes
- **Estado Local**: Controle de página atual e checkbox
- **Persistência**: Salva preferência "não mostrar novamente"
- **Navegação**: Botões "Voltar" e "Avançar/Concluir" com lógica condicional

---

### **3. LoginERegistro - Autenticação com Validação**

**Funcionamento Interno:**
```dart
Future<void> _signIn() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, Routes.home);
    } on FirebaseAuthException catch (e) {
      // Tratamento específico de erros do Firebase
      String message = _getErrorMessage(e.code);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }
}
```

**Validação de Formulário:**
```dart
CustomTextField(
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Digite seu email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Digite um email válido';
    }
    return null;
  },
)
```

**Características Técnicas:**
- **CustomTextField**: Widget reutilizável com validação
- **Tratamento de Erros**: Mapeamento específico de códigos Firebase
- **Validação Regex**: Validação de email com expressão regular
- **Estado de Loading**: Indicador visual durante autenticação
- **Navegação Condicional**: Redirecionamento baseado no sucesso

---

### **4. HomeScreen - Lista de Senhas com StreamBuilder**

**Funcionamento Interno:**
```dart
StreamBuilder<QuerySnapshot>(
  stream: _firestore
      .collection('passwords')
      .where('userId', isEqualTo: user?.uid)
      .orderBy('createdAt', descending: true)
      .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        return _buildPasswordCard(snapshot.data!.docs[index]);
      },
    );
  },
)
```

**Operações CRUD:**
```dart
Future<void> _deletePassword(String passwordId) async {
  await _firestore.collection('passwords').doc(passwordId).delete();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Senha excluída com sucesso!')),
  );
}

void _copyToClipboard(String password) {
  Clipboard.setData(ClipboardData(text: password));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Senha copiada!')),
  );
}
```

**Características Técnicas:**
- **StreamBuilder**: Dados em tempo real do Firestore
- **Filtros**: Senhas isoladas por usuário (userId)
- **Estados**: Loading, erro, vazio e com dados
- **CRUD**: Create, Read, Update, Delete de senhas
- **Clipboard**: Integração com área de transferência
- **Toggle de Visibilidade**: Estado local para mostrar/ocultar senhas

---

### **5. NewPasswordScreen - Gerador com API e Fallback**

**Funcionamento Interno:**
```dart
Future<void> _generatePassword() async {
  setState(() => _isLoading = true);
  
  try {
    // Tentativa de API externa
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() => _generatedPassword = data['password'] ?? '');
    } else {
      _generatePasswordLocally(); // Fallback
    }
  } catch (e) {
    _generatePasswordLocally(); // Fallback
  }
}

void _generatePasswordLocally() {
  String charset = '';
  if (_includeLowercase) charset += 'abcdefghijklmnopqrstuvwxyz';
  if (_includeUppercase) charset += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  if (_includeNumbers) charset += '0123456789';
  if (_includeSymbols) charset += '!@#\$%^&*()_+-=[]{}|;:,.<>?';
  
  String password = '';
  for (int i = 0; i < _passwordLength; i++) {
    final index = (DateTime.now().millisecondsSinceEpoch + i * 7) % charset.length;
    password += charset[index];
  }
  
  setState(() => _generatedPassword = password);
}
```

**Animação de Expansão:**
```dart
late AnimationController _animationController;
late Animation<double> _animation;

void _toggleOptions() {
  setState(() => _showOptions = !_showOptions);
  
  if (_showOptions) {
    _animationController.forward();
  } else {
    _animationController.reverse();
  }
}

SizeTransition(
  sizeFactor: _animation,
  child: Container(/* opções de configuração */),
)
```

**Características Técnicas:**
- **HTTP Client**: Integração com API externa
- **Fallback Inteligente**: Geração local se API falhar
- **Algoritmo de Geração**: Baseado em timestamp para aleatoriedade
- **Animação**: SizeTransition para expansão de opções
- **Validação**: Verificação de parâmetros obrigatórios
- **Persistência**: Salva senha no Firestore com label

---

## 🔒 **Sistema de Proteção de Rotas (AuthGuard)**

**Funcionamento Interno:**
```dart
class AuthGuard extends StatelessWidget {
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        
        if (snapshot.data == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, Routes.login);
          });
          return CircularProgressIndicator();
        }
        
        return child; // Widget protegido
      },
    );
  }
}
```

**Implementação nas Rotas:**
```dart
case home:
  return MaterialPageRoute(
    builder: (_) => const AuthGuard(child: HomeScreen()),
  );
case password:
  return MaterialPageRoute(
    builder: (_) => const AuthGuard(child: NewPasswordScreen()),
  );
```

**Características Técnicas:**
- **StreamBuilder**: Monitora mudanças de autenticação em tempo real
- **Redirecionamento Automático**: Envia para login se não autenticado
- **Wrapper Pattern**: Envolve widgets que precisam de proteção
- **Estado de Loading**: Mostra indicador durante verificação
- **PostFrameCallback**: Evita problemas de contexto durante build

---

## 🎨 **Sistema de Tema Personalizado**

**Configuração no main.dart:**
```dart
theme: ThemeData(
  primaryColor: const Color(0xFF2196F3),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF2196F3),
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2196F3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  // ... mais configurações
)
```

**Características Técnicas:**
- **Cores Consistentes**: Azul (#2196F3) em toda aplicação
- **Componentes Estilizados**: Botões, campos, cards padronizados
- **Responsividade**: Adaptação automática a diferentes telas
- **Manutenibilidade**: Configuração centralizada

---

## 📊 **Estrutura de Dados (Firestore)**

**Coleção: passwords**
```json
{
  "userId": "string",      // ID do usuário autenticado
  "password": "string",    // Senha gerada
  "label": "string",       // Rótulo da senha
  "createdAt": "timestamp" // Data de criação
}
```

**Consultas Otimizadas:**
```dart
// Filtro por usuário
.where('userId', isEqualTo: user?.uid)

// Ordenação por data
.orderBy('createdAt', descending: true)

// Dados em tempo real
.snapshots()
```

**Características Técnicas:**
- **Isolamento de Dados**: Cada usuário vê apenas suas senhas
- **Indexação**: Campos indexados para consultas eficientes
- **Tempo Real**: StreamBuilder atualiza automaticamente
- **Segurança**: Regras do Firestore controlam acesso

---

## 🔧 **Widgets Personalizados**

### **CustomTextField**
```dart
class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(/* estilos */)),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            // ... mais configurações
          ),
        ),
      ],
    );
  }
}
```

### **PasswordResultWidget**
```dart
class PasswordResultWidget extends StatelessWidget {
  final String password;
  final bool isVisible;
  final VoidCallback? onToggleVisibility;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onToggleVisibility,
                icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: password));
                  // Feedback visual
                },
                icon: Icon(Icons.copy),
              ),
            ],
          ),
          Text(isVisible ? password : '•' * password.length),
        ],
      ),
    );
  }
}
```

**Características Técnicas:**
- **Reutilização**: Componentes usados em múltiplas telas
- **Customização**: Parâmetros flexíveis para diferentes contextos
- **Validação**: Integração com sistema de validação do Flutter
- **Acessibilidade**: Suporte a leitores de tela
- **Manutenibilidade**: Código centralizado e fácil de modificar
