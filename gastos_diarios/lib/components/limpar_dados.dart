import 'package:flutter/material.dart';

class LimparDadosDialog extends StatefulWidget {
  const LimparDadosDialog({super.key});

  @override
  State<LimparDadosDialog> createState() => _LimparDadosDialogState();
}

class _LimparDadosDialogState extends State<LimparDadosDialog> {
  bool receitas = true;
  bool despesas = true;
  bool operacoesAuto = true;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final podeConfirmar = controller.text.toUpperCase() == 'LIMPAR';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFE00000),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Text(
              'Limpar Dados',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5E5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Atenção!\nEsta ação é irreversível. Todos os dados selecionados serão permanentemente excluídos.',
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),

                const Text('O que deseja limpar?', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                CheckboxListTile(
                  value: receitas,
                  onChanged: (v) => setState(() => receitas = v ?? false),
                  title: const Text('Todas as Receitas'),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  value: despesas,
                  onChanged: (v) => setState(() => despesas = v ?? false),
                  title: const Text('Todas as Despesas'),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  value: operacoesAuto,
                  onChanged: (v) => setState(() => operacoesAuto = v ?? false),
                  title: const Text('Operações Automáticas'),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                const SizedBox(height: 12),
                const Text('Digite LIMPAR para confirmar'),
                const SizedBox(height: 6),
                TextField(
                  controller: controller,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Digite aqui...',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: podeConfirmar
                            ? () {
                                Navigator.pop(context, {
                                  'receitas': receitas,
                                  'despesas': despesas,
                                  'operacoesAuto': operacoesAuto,
                                });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          disabledBackgroundColor: Colors.red.shade100,
                        ),
                        child: const Text('Limpar Dados'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
