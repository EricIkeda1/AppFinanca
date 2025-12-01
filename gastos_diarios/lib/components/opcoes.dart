import 'package:flutter/material.dart';

class OpcoesDialog extends StatefulWidget {
  const OpcoesDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (dialogContext) {
        return MediaQuery.removeViewInsets(
          context: dialogContext,
          removeBottom: true,
          child: const OpcoesDialog(),
        );
      },
    );
  }

  @override
  State<OpcoesDialog> createState() => _OpcoesDialogState();
}

class _OpcoesDialogState extends State<OpcoesDialog> {
  bool _modoEscuro = false;
  bool _notificacoes = true;
  bool _backupAutomatico = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 10,
        child: Container(
          width: 430,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(18)),
                  color: Color(0xFF3F4A5A),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Opções',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _OpcaoCard(
                      icon: Icons.brightness_5_outlined,
                      title: 'Modo Escuro',
                      subtitle: 'Ativar tema escuro',
                      value: _modoEscuro,
                      onChanged: (v) {
                        setState(() => _modoEscuro = v);
                      },
                    ),
                    const SizedBox(height: 10),
                    _OpcaoCard(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notificações',
                      subtitle: 'Receber alertas',
                      value: _notificacoes,
                      onChanged: (v) {
                        setState(() => _notificacoes = v);
                      },
                    ),
                    const SizedBox(height: 10),
                    _OpcaoCard(
                      icon: Icons.backup_outlined,
                      title: 'Backup Automático',
                      subtitle: 'Salvar dados diariamente',
                      value: _backupAutomatico,
                      onChanged: (v) {
                        setState(() => _backupAutomatico = v);
                      },
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFE5E9F0)),
                    const SizedBox(height: 14),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _OpcaoTexto(
                            text: 'Exportar Dados',
                            color: Colors.black87,
                          ),
                          SizedBox(height: 8),
                          _OpcaoTexto(
                            text: 'Importar Dados',
                            color: Colors.black87,
                          ),
                          SizedBox(height: 8),
                          _OpcaoTexto(
                            text: 'Limpar Todos os Dados',
                            color: Color(0xFFE53935),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F4A5A),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Fechar',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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
      ),
    );
  }
}

class _OpcaoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _OpcaoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFE5EBF5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: const Color(0xFF4B5563),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF111827),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD1D5DB),
          ),
        ],
      ),
    );
  }
}

class _OpcaoTexto extends StatelessWidget {
  final String text;
  final Color color;

  const _OpcaoTexto({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
