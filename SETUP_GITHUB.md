# 🚀 **Configuração do GitHub - Gerador de Senhas**

## 📋 **Passos para Versionar no GitHub**

### **1. Inicializar Repositório Local**
```bash
# Inicializar Git
git init

# Adicionar todos os arquivos
git add .

# Primeiro commit
git commit -m "Implementação inicial do Gerador de Senhas

- SplashScreen com animação Lottie
- IntroScreen com PageView (3 páginas)
- Sistema de autenticação (Login/Registro)
- HomeScreen com lista de senhas do Firestore
- NewPasswordScreen com gerador de senhas
- AuthGuard para proteção de rotas
- Widgets personalizados (CustomTextField, PasswordResultWidget)
- Tema personalizado com cores azuis
- Integração Firebase (Auth + Firestore)
- Fallback local para geração de senhas"
```

### **2. Criar Repositório no GitHub**
1. Acesse [github.com](https://github.com)
2. Clique em "New repository"
3. Nome: `gerador-senhas-flutter`
4. Descrição: `Aplicativo Flutter com Firebase para geração e gerenciamento de senhas seguras`
5. Marque como **Público**
6. **NÃO** inicialize com README (já temos um)

### **3. Conectar Repositório Local ao GitHub**
```bash
# Adicionar remote origin
git remote add origin https://github.com/SEU_USUARIO/gerador-senhas-flutter.git

# Verificar remote
git remote -v

# Push inicial
git push -u origin main
```

### **4. Adicionar Vídeo Demonstrativo**
1. Grave o vídeo mostrando:
   - SplashScreen com animação
   - IntroScreen (3 páginas)
   - Login/Registro funcionando
   - Geração de senhas
   - Lista de senhas salvas
   - Logout e proteção de rotas

2. Faça upload do vídeo para:
   - YouTube (recomendado)
   - Google Drive
   - Outro serviço de hospedagem

3. Atualize o README.md com o link do vídeo:
```markdown
## 🎥 **Demonstração em Vídeo**

> **📹 [CLIQUE AQUI PARA ASSISTIR AO VÍDEO DEMONSTRATIVO](https://youtube.com/watch?v=SEU_VIDEO_AQUI)**
```

### **5. Estrutura Final do Repositório**
```
gerador-senhas-flutter/
├── lib/
│   ├── core/
│   ├── screens/
│   ├── widgets/
│   ├── main.dart
│   ├── routes.dart
│   └── firebase_options.dart
├── assets/
│   └── lottie/
├── README.md
├── APRESENTACAO.md
├── SETUP_GITHUB.md
├── pubspec.yaml
└── .gitignore
```

---

## 🔒 **Segurança - Chaves do Firebase**

### **✅ Arquivos Seguros (NÃO versionados)**
- `.env` - Contém as chaves do Firebase
- `android/app/google-services.json` - Configuração Android
- `ios/Runner/GoogleService-Info.plist` - Configuração iOS

### **✅ Arquivos Versionados (Seguros)**
- `lib/firebase_options.dart` - Configuração padrão (sem chaves)
- `lib/main.dart` - Carrega chaves do .env

### **Verificação de Segurança**
```bash
# Verificar se .env está sendo ignorado
git status

# Se aparecer .env, adicione ao .gitignore
echo ".env" >> .gitignore
git add .gitignore
git commit -m "Adicionar .env ao .gitignore"
```

---

## 📝 **Commits Sugeridos**

### **Commit Inicial**
```bash
git commit -m "Implementação inicial do Gerador de Senhas

- SplashScreen com animação Lottie
- IntroScreen com PageView (3 páginas)  
- Sistema de autenticação (Login/Registro)
- HomeScreen com lista de senhas do Firestore
- NewPasswordScreen com gerador de senhas
- AuthGuard para proteção de rotas
- Widgets personalizados
- Tema personalizado com cores azuis
- Integração Firebase (Auth + Firestore)
- Fallback local para geração de senhas"
```

### **Commit de Documentação**
```bash
git add README.md APRESENTACAO.md
git commit -m "Adicionar documentação completa

- README.md com guia completo do projeto
- APRESENTACAO.md com roteiro para apresentação
- Instruções de instalação e configuração
- Explicação técnica das funcionalidades"
```

### **Commit do Vídeo**
```bash
git add README.md
git commit -m "Adicionar link do vídeo demonstrativo

- Vídeo mostrando todas as funcionalidades
- Demonstração completa do fluxo do usuário
- Explicação das funcionalidades técnicas"
```

---

## 🎯 **Checklist Final**

- [ ] Repositório criado no GitHub
- [ ] Código versionado e enviado
- [ ] .env adicionado ao .gitignore
- [ ] README.md atualizado
- [ ] Vídeo gravado e link adicionado
- [ ] APRESENTACAO.md para guia da apresentação
- [ ] Teste de clone do repositório

---

## 🚨 **Importante**

1. **NUNCA** commite o arquivo `.env`
2. **SEMPRE** teste o clone do repositório
3. **VERIFIQUE** se as chaves do Firebase não estão expostas
4. **GRAVE** o vídeo demonstrativo
5. **ATUALIZE** o README com o link do vídeo

---

**Boa sorte com o versionamento! 🎉**



