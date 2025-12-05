import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AdicionarDespesaDialog extends StatefulWidget {
  const AdicionarDespesaDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return MediaQuery.removeViewInsets(
          context: dialogContext,
          removeBottom: true,
          child: const AdicionarDespesaDialog(),
        );
      },
    );
  }

  @override
  State<AdicionarDespesaDialog> createState() =>
      _AdicionarDespesaDialogState();
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

class _AdicionarDespesaDialogState extends State<AdicionarDespesaDialog> {
  final _valorController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _dataController = TextEditingController();
  String _categoriaSelecionada = 'Alimentação';

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
    const textFieldStyle = TextStyle(
      color: Colors.black,
      fontSize: _baseFontSize,
    );

    return Dialog(
      backgroundColor: Colors.white,
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
                color: Color(0xFFE53935),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Adicionar Despesa',
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
                  _label('Valor'),
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
                    decoration: _inputDecoration(hintText: 'R\$ 0,00'),
                  ),
                  const SizedBox(height: 12),

                  _label('Descrição'),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _descricaoController,
                    style: textFieldStyle,
                    decoration: _inputDecoration(
                      hintText: 'Ex: Compras no mercado',
                    ),
                  ),
                  const SizedBox(height: 12),

                  _label('Categoria'),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFFCBD5E1),
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _categoriaSelecionada,
                        isExpanded: true,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: _baseFontSize,
                        ),
                        dropdownColor: Colors.white,
                        items: const [
                          DropdownMenuItem(
                            value: 'Alimentação',
                            child: Text(
                              'Alimentação',
                              style: TextStyle(fontSize: _baseFontSize),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Transporte',
                            child: Text(
                              'Transporte',
                              style: TextStyle(fontSize: _baseFontSize),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Moradia',
                            child: Text(
                              'Moradia',
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

                  _label('Data'),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _dataController,
                    readOnly: true,
                    style: textFieldStyle,
                    decoration: _inputDecoration(hintText: 'DD/MM/AAAA'),
                    onTap: () async {
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
                                primary: Color(0xFFE53935),
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Colors.black,
                              ),
                              textTheme: Theme.of(context)
                                  .textTheme
                                  .apply(fontSizeFactor: 1.2),
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side:
                                const BorderSide(color: Color(0xFFCED4DA)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Cancelar',
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
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53935),
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

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: _baseFontSize - 2,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(
        color: Color(0xFF9CA3AF),
        fontSize: _baseFontSize - 2,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: Color(0xFFCBD5E1),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: Color(0xFFCBD5E1),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: Color(0xFFE53935),
          width: 1.4,
        ),
      ),
    );
  }
}
