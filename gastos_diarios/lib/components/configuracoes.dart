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
                  color: Color(0xFF1E6CF9),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Configurações',
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

              Container(
                height: 1,
                color: const Color(0xFFE5E9F0),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _ConfigLabel(
                      icon: Icons.attach_money,
                      text: 'Moeda',
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
                    ),
                    const SizedBox(height: 12),

                    const _ConfigLabel(
                      icon: Icons.language,
                      text: 'Idioma',
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
                    ),
                    const SizedBox(height: 12),

                    const _ConfigLabel(
                      icon: Icons.calendar_today_outlined,
                      text: 'Início do Mês',
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
                    ),
                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F1FF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFD0E0FF),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Info: Estas configurações afetam como os dados são exibidos e calculados no aplicativo.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF456185),
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
                                  vertical: 12),
                              side: const BorderSide(
                                  color: Color(0xFFCED4DA)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
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
                                  vertical: 12),
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

  const _ConfigLabel({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6B7280)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
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

  const _ConfigDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      dropdownColor: Colors.white,
      decoration: _dropdownDecoration(),
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 14,
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
              ),
            ),
          )
          .toList(),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: Colors.white, 
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFCCD3E0),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFCCD3E0),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFF1E6CF9),
          width: 1.4,
        ),
      ),
    );
  }
}
