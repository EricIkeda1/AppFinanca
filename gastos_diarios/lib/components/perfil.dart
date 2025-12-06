import 'package:flutter/material.dart';

class PerfilDialog extends StatefulWidget {
  const PerfilDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (dialogContext) {
        return MediaQuery.removeViewInsets(
          context: dialogContext,
          removeBottom: true,
          child: const PerfilDialog(),
        );
      },
    );
  }

  @override
  State<PerfilDialog> createState() => _PerfilDialogState();
}

class _PerfilDialogState extends State<PerfilDialog> {
  final _nomeController = TextEditingController(text: 'João Silva');
  final _emailController =
      TextEditingController(text: 'joao.silva@email.com');
  final _telefoneController =
      TextEditingController(text: '(11) 98765-4321');
  final _cidadeController = TextEditingController(text: 'São Paulo, SP');

  static const double _baseFontSize = 18;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      child: Container(
        width: 520,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(26)),
                gradient: LinearGradient(
                  colors: [Color(0xFF059669), Color(0xFF16A34A)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Meu Perfil',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _baseFontSize - 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(32, 22, 32, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 62,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 26),

                  _labelWithIcon(
                    icon: Icons.person_outline,
                    text: 'Nome Completo',
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _nomeController,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Color(0xFF111827),
                    ),
                    cursorColor: const Color(0xFF16A34A),
                    decoration: _inputDecoration('João Silva'),
                  ),
                  const SizedBox(height: 12),

                  _labelWithIcon(
                    icon: Icons.email_outlined,
                    text: 'E-mail',
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Color(0xFF111827),
                    ),
                    cursorColor: const Color(0xFF16A34A),
                    decoration:
                        _inputDecoration('joao.silva@email.com'),
                  ),
                  const SizedBox(height: 12),

                  _labelWithIcon(
                    icon: Icons.phone_outlined,
                    text: 'Telefone',
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _telefoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Color(0xFF111827),
                    ),
                    cursorColor: const Color(0xFF16A34A),
                    decoration: _inputDecoration('(11) 98765-4321'),
                  ),
                  const SizedBox(height: 12),

                  _labelWithIcon(
                    icon: Icons.location_on_outlined,
                    text: 'Cidade',
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _cidadeController,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Color(0xFF111827),
                    ),
                    cursorColor: const Color(0xFF16A34A),
                    decoration: _inputDecoration('São Paulo, SP'),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12),
                            side: const BorderSide(
                              color: Color(0xFFFCA5A5), 
                            ),
                            backgroundColor:
                                const Color(0xFFFFE4E6), 
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(999),
                            ),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFB91C1C),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _salvarPerfil,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(999),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Salvar',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE5E7EB),
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _deletarConta,
                      icon: const Icon(
                        Icons.person_remove_outlined,
                        color: Color(0xFFB91C1C),
                        size: 18,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(
                          color: Color(0xFFB91C1C),
                          width: 1.2,
                        ),
                        backgroundColor:
                            const Color(0xFFFFE4E6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      label: const Text(
                        'Deletar Conta Permanentemente',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFB91C1C),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelWithIcon({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF9CA3AF),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      hintStyle: const TextStyle(
        fontSize: 14,
        color: Color(0xFF6B7280),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFF22C55E),
          width: 1.4,
        ),
      ),
    );
  }

  void _salvarPerfil() {
    Navigator.of(context).pop();
  }

  void _deletarConta() {
  }
}
