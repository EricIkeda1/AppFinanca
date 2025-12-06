import 'package:flutter/material.dart';

class ExportarDadosDialog extends StatefulWidget {
  const ExportarDadosDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return MediaQuery.removeViewInsets(
          context: dialogContext,
          removeBottom: true,
          child: const ExportarDadosDialog(),
        );
      },
    );
  }

  @override
  State<ExportarDadosDialog> createState() => _ExportarDadosDialogState();
}

class _ExportarDadosDialogState extends State<ExportarDadosDialog> {
  String _formato = 'json';
  bool _receitas = true;
  bool _despesas = true;
  bool _operacoesAutomaticas = true;

  static const double _baseFontSize = 18;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 440,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF020617) : Colors.white,
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
                color: Color(0xFF049154),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Exportar Dados',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Formato de Exportação',
                    style: TextStyle(
                      fontSize: _baseFontSize - 4,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _FormatoCard(
                    selected: _formato == 'json',
                    titulo: 'JSON',
                    subtitulo: 'Formato completo de dados',
                    onTap: () => setState(() => _formato = 'json'),
                  ),
                  const SizedBox(height: 8),

                  _FormatoCard(
                    selected: _formato == 'csv',
                    titulo: 'CSV',
                    subtitulo: 'Compatível com Excel',
                    onTap: () => setState(() => _formato = 'csv'),
                  ),
                  const SizedBox(height: 8),

                  _FormatoCard(
                    selected: _formato == 'pdf',
                    titulo: 'PDF',
                    subtitulo: 'Relatório formatado',
                    onTap: () => setState(() => _formato = 'pdf'),
                  ),

                  const SizedBox(height: 18),
                  Text(
                    'Incluir nos Dados',
                    style: TextStyle(
                      fontSize: _baseFontSize - 4,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _CheckboxRow(
                    value: _receitas,
                    onChanged: (v) =>
                        setState(() => _receitas = v ?? _receitas),
                    label: 'Receitas',
                  ),
                  const SizedBox(height: 8),
                  _CheckboxRow(
                    value: _despesas,
                    onChanged: (v) =>
                        setState(() => _despesas = v ?? _despesas),
                    label: 'Despesas',
                  ),
                  const SizedBox(height: 8),
                  _CheckboxRow(
                    value: _operacoesAutomaticas,
                    onChanged: (v) => setState(
                        () => _operacoesAutomaticas = v ?? _operacoesAutomaticas),
                    label: 'Operações Automáticas',
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
                            'Cancelar',
                            style: TextStyle(
                              fontSize: _baseFontSize - 2,
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
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF049154),
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.download_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: const Text(
                            'Exportar',
                            style: TextStyle(
                              fontSize: _baseFontSize - 2,
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
}

class _FormatoCard extends StatelessWidget {
  final bool selected;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _FormatoCard({
    required this.selected,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderColor = selected
        ? const Color(0xFF049154)
        : (isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB));

    final bgColor = selected
        ? (isDark ? const Color(0xFF064E3B) : const Color(0xFFE6F4EC))
        : (isDark ? const Color(0xFF020617) : Colors.white);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          children: [
            Icon(
              Icons.description_outlined,
              size: 22,
              color: selected
                  ? const Color(0xFF049154)
                  : (isDark ? Colors.white70 : const Color(0xFF6B7280)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitulo,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? Colors.white60
                        : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckboxRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;

  const _CheckboxRow({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF020617) : const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF049154),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
