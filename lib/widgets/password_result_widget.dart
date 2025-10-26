import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordResultWidget extends StatelessWidget {
  final String password;
  final VoidCallback? onCopy;
  final bool isVisible;
  final VoidCallback? onToggleVisibility;

  const PasswordResultWidget({
    super.key,
    required this.password,
    this.onCopy,
    this.isVisible = false,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lock,
                color: Color(0xFF2196F3),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Senha Gerada',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const Spacer(),
              if (onToggleVisibility != null)
                IconButton(
                  onPressed: onToggleVisibility,
                  icon: Icon(
                    isVisible ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF2196F3),
                  ),
                ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: password));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Senha copiada para a área de transferência!'),
                      backgroundColor: Color(0xFF4CAF50),
                    ),
                  );
                  onCopy?.call();
                },
                icon: const Icon(
                  Icons.copy,
                  color: Color(0xFF2196F3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Text(
              isVisible ? password : '•' * password.length,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'monospace',
                color: const Color(0xFF333333),
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

