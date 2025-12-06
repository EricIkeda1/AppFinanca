import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart'; 
import 'exportar_dados.dart';
import 'importar_dados.dart';

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
  bool _notificacoes = true;
  bool _backupAutomatico = true;

  static const double _baseFontSize = 18;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool _modoEscuro = themeProvider.isDarkMode;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 10,
        child: Container(
          width: 430,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF020617)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                  color: isDark
                      ? const Color(0xFF111827)
                      : const Color(0xFF3F4A5A),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Opções',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _baseFontSize + 2,
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
                        size: 22,
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
                        themeProvider.toggleTheme(v);
                      },
                      baseFontSize: _baseFontSize,
                    ),
                    const SizedBox(height: 12),
                    _OpcaoCard(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notificações',
                      subtitle: 'Receber alertas',
                      value: _notificacoes,
                      onChanged: (v) {
                        setState(() => _notificacoes = v);
                      },
                      baseFontSize: _baseFontSize,
                    ),
                    const SizedBox(height: 12),
                    _OpcaoCard(
                      icon: Icons.backup_outlined,
                      title: 'Backup Automático',
                      subtitle: 'Salvar dados diariamente',
                      value: _backupAutomatico,
                      onChanged: (v) {
                        setState(() => _backupAutomatico = v);
                      },
                      baseFontSize: _baseFontSize,
                    ),

                    const SizedBox(height: 18),
                    Divider(
                      height: 1,
                      color: isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFE5E9F0),
                    ),
                    const SizedBox(height: 16),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              ExportarDadosDialog.show(context);
                            },
                            child: _OpcaoTexto(
                              text: 'Exportar Dados',
                              color:
                                  isDark ? Colors.white70 : Colors.black87,
                              fontSize: _baseFontSize - 2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              ImportarDadosDialog.show(context);
                            },
                            child: _OpcaoTexto(
                              text: 'Importar Dados',
                              color:
                                  isDark ? Colors.white70 : Colors.black87,
                              fontSize: _baseFontSize - 2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const _OpcaoTexto(
                            text: 'Limpar Todos os Dados',
                            color: Color(0xFFE53935),
                            fontSize: _baseFontSize - 2,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? const Color(0xFF111827)
                              : const Color(0xFF3F4A5A),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Fechar',
                          style: TextStyle(
                            fontSize: _baseFontSize,
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
  final double baseFontSize;

  const _OpcaoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.baseFontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF020617)
            : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? const Color(0xFF1F2937)
              : const Color(0xFFE5E7EB),
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
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF111827)
                  : const Color(0xFFE5EBF5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 22,
              color: isDark
                  ? const Color(0xFF38BDF8)
                  : const Color(0xFF4B5563),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: baseFontSize - 2,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: baseFontSize - 6,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: isDark
                ? const Color(0xFF38BDF8)
                : const Color(0xFF111827),
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
  final double fontSize;

  const _OpcaoTexto({
    super.key,
    required this.text,
    required this.color,
    this.fontSize = 16,
  });

  static const double _baseFontSize = 18;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
