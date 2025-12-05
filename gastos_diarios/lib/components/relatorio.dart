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
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8E24AA),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textTheme: Theme.of(context)
                .textTheme
                .apply(fontSizeFactor: 1.1),
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
    const labelStyle = TextStyle(
      fontSize: _baseFontSize - 4, 
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Data Inicial', style: labelStyle),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _dataInicialController,
                      readOnly: true,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: _baseFontSize - 2, 
                      ),
                      onTap: () => _selecionarData(_dataInicialController),
                      decoration: _inputDecoration(),
                    ),
                    const SizedBox(height: 14),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Data Final', style: labelStyle),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _dataFinalController,
                      readOnly: true,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: _baseFontSize - 2,
                      ),
                      onTap: () => _selecionarData(_dataFinalController),
                      decoration: _inputDecoration(),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F5FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE0D7FF),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Resumo do Período',
                            style: TextStyle(
                              fontSize: _baseFontSize - 4, 
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7B1FA2),
                            ),
                          ),
                          SizedBox(height: 10),
                          _ResumoRow(
                            label: 'Total de Receitas:',
                            value: 'R\$ 5.420,00',
                            color: Color(0xFF00A86B),
                          ),
                          _ResumoRow(
                            label: 'Total de Despesas:',
                            value: 'R\$ 3.180,50',
                            color: Color(0xFFE53935),
                          ),
                          _ResumoRow(
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
                              side: const BorderSide(
                                color: Color(0xFFCED4DA),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Fechar',
                              style: TextStyle(
                                fontSize: _baseFontSize,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
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

  InputDecoration _inputDecoration() {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      hintStyle: const TextStyle(
        color: Color(0xFF9CA3AF),
        fontSize: _baseFontSize - 2, // 16
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
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
