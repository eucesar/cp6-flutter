import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:gerador_de_senha/widgets/password_result_widget.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen>
    with TickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String _generatedPassword = '';
  bool _isLoading = false;
  bool _showOptions = false;
  bool _isPasswordVisible = false;
  
  // Configurações da senha
  int _passwordLength = 12;
  bool _includeLowercase = true;
  bool _includeUppercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _generatePassword() async {
    setState(() => _isLoading = true);
    
    try {
      // Tenta usar a API externa primeiro
      final url = Uri.parse('https://safekey-api-a1bd9aa7953.herokuapp.com/generate');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'length': _passwordLength,
          'include_lowercase': _includeLowercase,
          'include_uppercase': _includeUppercase,
          'include_numbers': _includeNumbers,
          'include_symbols': _includeSymbols,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _generatedPassword = data['password'] ?? '';
        });
      } else {
        // Se a API falhar, usa gerador local
        _generatePasswordLocally();
      }
    } catch (e) {
      // Se houver erro na API, usa gerador local
      _generatePasswordLocally();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _generatePasswordLocally() {
    const String lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const String uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String numbers = '0123456789';
    const String symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
    
    String charset = '';
    if (_includeLowercase) charset += lowercase;
    if (_includeUppercase) charset += uppercase;
    if (_includeNumbers) charset += numbers;
    if (_includeSymbols) charset += symbols;
    
    if (charset.isEmpty) {
      setState(() {
        _generatedPassword = '';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione pelo menos um tipo de caractere!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }
    
    final random = DateTime.now().millisecondsSinceEpoch;
    String password = '';
    for (int i = 0; i < _passwordLength; i++) {
      final index = (random + i * 7) % charset.length;
      password += charset[index];
    }
    
    setState(() {
      _generatedPassword = password;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha gerada localmente!'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    }
  }

  Future<void> _savePassword() async {
    if (_generatedPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gere uma senha primeiro!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final TextEditingController labelController = TextEditingController();
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Salvar senha'),
        content: TextField(
          controller: labelController,
          decoration: const InputDecoration(
            labelText: 'Tipo da senha',
            hintText: 'Ex: Senha do email',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, labelController.text),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          await _firestore.collection('passwords').add({
            'userId': user.uid,
            'password': _generatedPassword,
            'label': result,
            'createdAt': FieldValue.serverTimestamp(),
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Senha salva com sucesso!'),
                backgroundColor: Color(0xFF4CAF50),
              ),
            );
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar senha: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _toggleOptions() {
    setState(() {
      _showOptions = !_showOptions;
    });
    
    if (_showOptions) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.lock, color: Colors.white),
            const SizedBox(width: 8),
            const Text(
              'Gerador de Senhas',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2196F3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sobre o App'),
                  content: const Text(
                    'Gerador de Senhas Seguro\n\n'
                    'Este aplicativo gera senhas seguras usando uma API externa. '
                    'Suas senhas são salvas de forma segura no Firebase.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de resultado da senha
            if (_generatedPassword.isNotEmpty)
              PasswordResultWidget(
                password: _generatedPassword,
                isVisible: _isPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock,
                      color: Color(0xFF2196F3),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Senha não informada',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _generatedPassword.isNotEmpty
                          ? () {
                              Clipboard.setData(ClipboardData(text: _generatedPassword));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Senha copiada!'),
                                  backgroundColor: Color(0xFF4CAF50),
                                ),
                              );
                            }
                          : null,
                      icon: const Icon(
                        Icons.copy,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Botão para mostrar/ocultar opções
            TextButton(
              onPressed: _toggleOptions,
              child: Text(
                _showOptions ? 'Ocultar opções' : 'Mostrar opções',
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                  fontSize: 16,
                ),
              ),
            ),
            
            // Opções de geração (com animação)
            SizeTransition(
              sizeFactor: _animation,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tamanho da senha
                    Text(
                      'Tamanho da senha: $_passwordLength',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Slider(
                      value: _passwordLength.toDouble(),
                      min: 4,
                      max: 50,
                      divisions: 46,
                      activeColor: const Color(0xFF2196F3),
                      onChanged: (value) {
                        setState(() {
                          _passwordLength = value.round();
                        });
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Opções de caracteres
                    _buildOptionSwitch(
                      'Incluir letras minúsculas',
                      _includeLowercase,
                      (value) => setState(() => _includeLowercase = value),
                    ),
                    _buildOptionSwitch(
                      'Incluir letras maiúsculas',
                      _includeUppercase,
                      (value) => setState(() => _includeUppercase = value),
                    ),
                    _buildOptionSwitch(
                      'Incluir números',
                      _includeNumbers,
                      (value) => setState(() => _includeNumbers = value),
                    ),
                    _buildOptionSwitch(
                      'Incluir símbolos',
                      _includeSymbols,
                      (value) => setState(() => _includeSymbols = value),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botão gerar senha
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _generatePassword,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Gerar Senha',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _savePassword,
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildOptionSwitch(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2196F3),
          ),
        ],
      ),
    );
  }
}