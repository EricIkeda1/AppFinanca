import 'package:flutter/material.dart';

class ConfiguracoesDialog extends StatefulWidget {
  const ConfiguracoesDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (dialogContext) {
        return MediaQuery.removeViewInsets(
          context: dialogContext,
          removeBottom: true,
          child: const ConfiguracoesDialog(),
        );
      },
    );
  }

  @override
  State<ConfiguracoesDialog> createState() => _ConfiguracoesDialogState();
}

class _ConfiguracoesDialogState extends State<ConfiguracoesDialog> {
  String _moeda = 'Real (R\$)';
  String _idioma = 'Português (Brasil)';
  String _inicioMes = 'Dia 1';

  static const double _baseFontSize = 18;

  @override
  Widget build(BuildContext context) {
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
            color: isDark ? const Color(0xFF020617) : theme.cardColor,
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                  color: Color(0xFF1E6CF9),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Configurações',
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

              Container(
                height: 1,
                color: isDark
                    ? const Color(0xFF1F2937)
                    : const Color(0xFFE5E9F0),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ConfigLabel(
                      icon: Icons.attach_money,
                      text: 'Moeda',
                      fontSize: _baseFontSize - 2,
                    ),
                    const SizedBox(height: 4),
                    _ConfigDropdown<String>(
                      value: _moeda,
                      items: const [
                        'Real (R\$)',
                        'Dólar (US\$)',
                        'Euro (€)',
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => _moeda = v);
                        }
                      },
                      fontSize: _baseFontSize,
                    ),
                    const SizedBox(height: 12),

                    _ConfigLabel(
                      icon: Icons.language,
                      text: 'Idioma',
                      fontSize: _baseFontSize - 2,
                    ),
                    const SizedBox(height: 4),
                    _ConfigDropdown<String>(
                      value: _idioma,
                      items: const [
                        'Português (Brasil)',
                        'Inglês (EUA)',
                        'Espanhol',
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => _idioma = v);
                        }
                      },
                      fontSize: _baseFontSize,
                    ),
                    const SizedBox(height: 12),

                    _ConfigLabel(
                      icon: Icons.calendar_today_outlined,
                      text: 'Início do Mês',
                      fontSize: _baseFontSize - 2,
                    ),
                    const SizedBox(height: 4),
                    _ConfigDropdown<String>(
                      value: _inicioMes,
                      items: const [
                        'Dia 1',
                        'Dia 5',
                        'Dia 10',
                        'Dia 15',
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => _inicioMes = v);
                        }
                      },
                      fontSize: _baseFontSize,
                    ),
                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0B1220)
                            : const Color(0xFFE8F1FF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF1D3A70)
                              : const Color(0xFFD0E0FF),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Info: Estas configurações afetam como os dados são exibidos e calculados no aplicativo.',
                        style: TextStyle(
                          fontSize: _baseFontSize - 4,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFF9FB4DD)
                              : const Color(0xFF456185),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              side: BorderSide(
                                color: isDark
                                    ? const Color(0xFF4B5563)
                                    : const Color(0xFFCED4DA),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor:
                                  isDark ? const Color(0xFF020617) : Colors.white,
                            ),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: _baseFontSize,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : Colors.black87,
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
                              backgroundColor: const Color(0xFF1E6CF9),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Salvar',
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

class _ConfigLabel extends StatelessWidget {
  final IconData icon;
  final String text;
  final double fontSize;

  const _ConfigLabel({
    super.key,
    required this.icon,
    required this.text,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(
          icon,
          size: fontSize,
          color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _ConfigDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final double fontSize;

  const _ConfigDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      dropdownColor: isDark ? const Color(0xFF020617) : Colors.white,
      decoration: _dropdownDecoration(context),
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
      onChanged: onChanged,
      items: items
          .map(
            (e) => DropdownMenuItem<T>(
              value: e,
              child: Text(
                e.toString(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          )
          .toList(),
    );
  }

  InputDecoration _dropdownDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: isDark ? const Color(0xFF020617) : Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color:
              isDark ? const Color(0xFF4B5563) : const Color(0xFFCCD3E0),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color:
              isDark ? const Color(0xFF4B5563) : const Color(0xFFCCD3E0),
          width: 1,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Color(0xFF1E6CF9),
          width: 1.4,
        ),
      ),
    );
  }
}
