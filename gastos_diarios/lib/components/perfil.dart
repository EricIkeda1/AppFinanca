import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _nomeController = TextEditingController(text: 'João Silva');
  final _emailController = TextEditingController(text: 'joao.silva@email.com');
  final _telefoneController = TextEditingController(text: '(11) 98765-4321');

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E4EC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF00C853),
        title: const Text('Meu Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          children: [
            const SizedBox(height: 40),

            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00C853),
              ),
              child: const Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            const _PerfilLabel('Nome Completo'),
            const SizedBox(height: 4),
            TextField(
              controller: _nomeController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration(),
            ),
            const SizedBox(height: 12),

            const _PerfilLabel('E-mail'),
            const SizedBox(height: 4),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration(),
            ),
            const SizedBox(height: 12),

            const _PerfilLabel('Telefone'),
            const SizedBox(height: 4),
            TextField(
              controller: _telefoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration(),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935), 
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Salvar',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration() {
  return InputDecoration(
    isDense: true,
    filled: true,
    fillColor: const Color(0xFFF8FAFF),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    hintStyle: const TextStyle(
      color: Color(0xFF9CA3AF),
      fontSize: 14,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Color(0xFFCBD5E1),
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Color(0xFFCBD5E1),
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Color(0xFF00C853),
        width: 1.4,
      ),
    ),
  );
}

class _PerfilLabel extends StatelessWidget {
  final String text;

  const _PerfilLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
