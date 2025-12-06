import 'package:flutter/material.dart';

class RelatorioDialog extends StatefulWidget {
  const RelatorioDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return MediaQuery.removeViewInsets(
          context: dialogContext,
          removeBottom: true,
          child: const RelatorioDialog(),
        );
      },
    );
  }

  @override
  State<RelatorioDialog> createState() => _RelatorioDialogState();
}

class _RelatorioDialogState extends State<RelatorioDialog> {
  final _dataInicialController = TextEditingController(text: '01/11/2025');
  final _dataFinalController = TextEditingController(text: '30/11/2025');

  static const double _baseFontSize = 18;

  @override
  void dispose() {
    _dataInicialController.dispose();
    _dataFinalController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData(TextEditingController controller) async {
    final hoje = DateTime.now();
    final escolhida = await showDatePicker(
      context: context,
      initialDate: hoje,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Theme(
          data: theme.copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: Color(0xFF8E24AA),
                    onPrimary: Colors.white,
                    surface: Color(0xFF020617),
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Color(0xFF8E24AA),
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
          ),
          child: child!,
        );
      },
    );
    if (escolhida != null) {
      controller.text =
          '${escolhida.day.toString().padLeft(2, '0')}/${escolhida.month.toString().padLeft(2, '0')}/${escolhida.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final labelStyle = TextStyle(
      fontSize: _baseFontSize - 4,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white70 : Colors.black87,
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF020617) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: const BoxDecoration(
                  color: Color(0xFF8E24AA),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Relatório por Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _baseFontSize,
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
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Data Inicial', style: labelStyle),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _dataInicialController,
                      readOnly: true,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: _baseFontSize - 2,
                      ),
                      onTap: () => _selecionarData(_dataInicialController),
                      decoration: _inputDecoration(context),
                    ),
                    const SizedBox(height: 14),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Data Final', style: labelStyle),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _dataFinalController,
                      readOnly: true,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: _baseFontSize - 2,
                      ),
                      onTap: () => _selecionarData(_dataFinalController),
                      decoration: _inputDecoration(context),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF140B24)
                            : const Color(0xFFF8F5FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF3B2A60)
                              : const Color(0xFFE0D7FF),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resumo do Período',
                            style: TextStyle(
                              fontSize: _baseFontSize - 4,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF7B1FA2),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const _ResumoRow(
                            label: 'Total de Receitas:',
                            value: 'R\$ 5.420,00',
                            color: Color(0xFF00A86B),
                          ),
                          const _ResumoRow(
                            label: 'Total de Despesas:',
                            value: 'R\$ 3.180,50',
                            color: Color(0xFFE53935),
                          ),
                          const _ResumoRow(
                            label: 'Saldo:',
                            value: 'R\$ 2.239,50',
                            color: Color(0xFF1565C0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

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
                            ),
                            child: Text(
                              'Fechar',
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
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBA2FFF),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Gerar Relatório',
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

  InputDecoration _inputDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: isDark ? const Color(0xFF020617) : Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      hintStyle: TextStyle(
        color: const Color(0xFF9CA3AF),
        fontSize: _baseFontSize - 2,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF4B5563) : const Color(0xFFCBD5E1),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF4B5563) : const Color(0xFFCBD5E1),
          width: 1,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Color(0xFF8E24AA),
          width: 1.4,
        ),
      ),
    );
  }
}

class _ResumoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ResumoRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    const double labelFontSize = 14;
    const double valueFontSize = 16;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
