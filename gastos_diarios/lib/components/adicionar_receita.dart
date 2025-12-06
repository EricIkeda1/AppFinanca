import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AdicionarReceitaDialog extends StatefulWidget {
  const AdicionarReceitaDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return MediaQuery.removeViewInsets(
          context: dialogContext,
          removeBottom: true,
          child: const AdicionarReceitaDialog(),
        );
      },
    );
  }

  @override
  State<AdicionarReceitaDialog> createState() =>
      _AdicionarReceitaDialogState();
}

class CurrencyPtBrInputFormatter extends TextInputFormatter {
  CurrencyPtBrInputFormatter({this.maxDigits = 12});

  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return const TextEditingValue(text: '');
    }

    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }

    final value = double.parse(digits) / 100;

    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$ ',
    );
    final newText = formatter.format(value);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class _AdicionarReceitaDialogState extends State<AdicionarReceitaDialog> {
  final _valorController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _dataController = TextEditingController();
  String _categoriaSelecionada = 'Salário';

  final _currencyFormatter = CurrencyPtBrInputFormatter(maxDigits: 12);

  static const double _baseFontSize = 18;

  @override
  void initState() {
    super.initState();
    final hoje = DateTime.now();
    _dataController.text =
        '${hoje.day.toString().padLeft(2, '0')}/${hoje.month.toString().padLeft(2, '0')}/${hoje.year}';
  }

  @override
  void dispose() {
    _valorController.dispose();
    _descricaoController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textFieldStyle = TextStyle(
      color: isDark ? Colors.white : Colors.black,
      fontSize: _baseFontSize,
    );

    return Dialog(
      backgroundColor: theme.cardColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFF00A86B),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Adicionar Receita',
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
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _label('Valor', isDark),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _valorController,
                    style: textFieldStyle,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _currencyFormatter,
                    ],
                    decoration: _inputDecoration(
                      context,
                      hintText: 'R\$ 0,00',
                    ),
                  ),
                  const SizedBox(height: 12),

                  _label('Descrição', isDark),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _descricaoController,
                    style: textFieldStyle,
                    decoration: _inputDecoration(
                      context,
                      hintText: 'Ex: Salário do mês',
                    ),
                  ),
                  const SizedBox(height: 12),

                  _label('Categoria', isDark),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF020617) : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF4B5563)
                            : const Color(0xFFCBD5E1),
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _categoriaSelecionada,
                        isExpanded: true,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: _baseFontSize,
                        ),
                        dropdownColor:
                            isDark ? const Color(0xFF020617) : Colors.white,
                        items: const [
                          DropdownMenuItem(
                            value: 'Salário',
                            child: Text(
                              'Salário',
                              style: TextStyle(fontSize: _baseFontSize),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Freelancer',
                            child: Text(
                              'Freelancer',
                              style: TextStyle(fontSize: _baseFontSize),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Outros',
                            child: Text(
                              'Outros',
                              style: TextStyle(fontSize: _baseFontSize),
                            ),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => _categoriaSelecionada = v);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _label('Data', isDark),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _dataController,
                    readOnly: true,
                    style: textFieldStyle,
                    decoration: _inputDecoration(
                      context,
                      hintText: 'DD/MM/AAAA',
                    ),
                    onTap: () async {
                      final hoje = DateTime.now();
                      final escolhida = await showDatePicker(
                        context: context,
                        initialDate: hoje,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          final theme = Theme.of(context);
                          final isDark =
                              theme.brightness == Brightness.dark;
                          return Theme(
                            data: theme.copyWith(
                              colorScheme: isDark
                                  ? const ColorScheme.dark(
                                      primary: Color(0xFF00A86B),
                                      onPrimary: Colors.white,
                                      surface: Color(0xFF020617),
                                      onSurface: Colors.white,
                                    )
                                  : const ColorScheme.light(
                                      primary: Color(0xFF00A86B),
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
                        _dataController.text =
                            '${escolhida.day.toString().padLeft(2, '0')}/${escolhida.month.toString().padLeft(2, '0')}/${escolhida.year}';
                      }
                    },
                  ),
                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                              color: isDark
                                  ? const Color(0xFF4B5563)
                                  : const Color(0xFFCED4DA),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
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
                            backgroundColor: const Color(0xFF00A86B),
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Adicionar',
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
    );
  }

  Widget _label(String text, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: _baseFontSize - 2,
          color: isDark ? Colors.white70 : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, {String? hintText}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InputDecoration(
      hintText: hintText,
      isDense: true,
      filled: true,
      fillColor: isDark ? const Color(0xFF020617) : Colors.white,
      hintStyle: TextStyle(
        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF9CA3AF),
        fontSize: _baseFontSize - 2,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF4B5563) : const Color(0xFFCBD5E1),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF4B5563) : const Color(0xFFCBD5E1),
          width: 1,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          color: Color(0xFF00A86B),
          width: 1.4,
        ),
      ),
    );
  }
}
