import 'package:flutter/material.dart';

class MovimentosDialog extends StatelessWidget {
  const MovimentosDialog({super.key});

  static const double _baseFontSize = 18;

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return MediaQuery.removeViewInsets(
          context: dialogContext,
          removeBottom: true,
          child: const MovimentosDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final maxDialogHeight = size.height * 0.8;

    final movimentos = [
      _MovimentoData(
        titulo: 'Salário Novembro',
        categoria: 'Salário',
        data: '31/10/2025',
        valor: '+R\$ 5.000,00',
        isReceita: true,
      ),
      _MovimentoData(
        titulo: 'Supermercado',
        categoria: 'Alimentação',
        data: '04/11/2025',
        valor: '-R\$ 450,00',
        isReceita: false,
      ),
      _MovimentoData(
        titulo: 'Freelance Design',
        categoria: 'Freelance',
        data: '09/11/2025',
        valor: '+R\$ 420,00',
        isReceita: true,
      ),
      _MovimentoData(
        titulo: 'Conta de Luz',
        categoria: 'Moradia',
        data: '11/11/2025',
        valor: '-R\$ 180,50',
        isReceita: false,
      ),
      _MovimentoData(
        titulo: 'Netflix',
        categoria: 'Lazer',
        data: '14/11/2025',
        valor: '-R\$ 55,00',
        isReceita: false,
      ),
      _MovimentoData(
        titulo: 'Uber',
        categoria: 'Transporte',
        data: '17/11/2025',
        valor: '-R\$ 45,00',
        isReceita: false,
      ),
    ];

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 460,
          maxHeight: maxDialogHeight,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF020617) : const Color(0xFFE0E4EC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: const BoxDecoration(
                  color: Color(0xFF1565C0),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Movimentos',
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

              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final m in movimentos) ...[
                          _MovimentoItem(data: m),
                          const SizedBox(height: 10),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovimentoData {
  final String titulo;
  final String categoria;
  final String data;
  final String valor;
  final bool isReceita;

  _MovimentoData({
    required this.titulo,
    required this.categoria,
    required this.data,
    required this.valor,
    required this.isReceita,
  });
}

class _MovimentoItem extends StatelessWidget {
  final _MovimentoData data;

  const _MovimentoItem({required this.data});

  static const double _baseFontSize = 18;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final corIcone =
        data.isReceita ? const Color(0xFF00A86B) : const Color(0xFFE53935);

    final cardColor =
        isDark ? const Color(0xFF0B1120) : const Color(0xFFF3F4F6);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: corIcone.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              data.isReceita ? Icons.trending_up : Icons.trending_down,
              color: corIcone,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.titulo,
                  style: TextStyle(
                    fontSize: _baseFontSize - 2,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.categoria} • ${data.data}',
                  style: TextStyle(
                    fontSize: _baseFontSize - 6,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            data.valor,
            style: TextStyle(
              fontSize: _baseFontSize - 2,
              fontWeight: FontWeight.w700,
              color: corIcone,
            ),
          ),
        ],
      ),
    );
  }
}
