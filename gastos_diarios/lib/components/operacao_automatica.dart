import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OperacoesAutomaticasDialog extends StatefulWidget {
  const OperacoesAutomaticasDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return MediaQuery.removeViewInsets(
          context: dialogContext,
          removeBottom: true,
          child: const OperacoesAutomaticasDialog(),
        );
      },
    );
  }

  @override
  State<OperacoesAutomaticasDialog> createState() =>
      _OperacoesAutomaticasDialogState();
}

class _OperacoesAutomaticasDialogState
    extends State<OperacoesAutomaticasDialog> {
  final _supabase = Supabase.instance.client;

  bool _loading = false;
  String? _error;
  List<_OperacaoAuto> _ops = const [];

  User? get _user => _supabase.auth.currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarOps();
    });
  }

  Future<void> _carregarOps() async {
    final user = _user;
    if (user == null) {
      setState(() => _error = 'Usuário não autenticado.');
      return;
    }

    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final rows = await _supabase
          .from('operacoes_automaticas')
          .select('id, titulo, tipo, valor, dia_do_mes, ativa')
          .eq('user_id', user.id)
          .order('dia_do_mes', ascending: true);

      final list = (rows as List).cast<Map<String, dynamic>>();

      setState(() {
        _ops = list.map(_OperacaoAuto.fromMap).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _deletar(String id) async {
    try {
      await _supabase.from('operacoes_automaticas').delete().eq('id', id);
      await _carregarOps();
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF020617) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogHeader(
                title: 'Operações Automáticas',
                color: const Color(0xFFCC8B00),
                onClose: () => Navigator.of(context).pop(),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _mostrarNovaOperacaoDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD79706),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text(
                          'Nova Operação Automática',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (_error != null) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    if (_loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CircularProgressIndicator(),
                      )
                    else if (_ops.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Nenhuma operação automática cadastrada.',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      for (final op in _ops) ...[
                        _OperacaoItem(
                          data: op,
                          onDelete: () => _deletar(op.id),
                        ),
                        const SizedBox(height: 8),
                      ],

                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2B1B00)
                            : const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF5D3A00)
                              : const Color(0xFFFFECB3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Dica: O banco roda um job diário (cron) e lança automaticamente no dia configurado.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFFFFF3C4)
                              : const Color(0xFF8D6E63),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD79706),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Fechar',
                          style: TextStyle(
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

  void _mostrarNovaOperacaoDialog(BuildContext context) {
    final tituloController = TextEditingController();
    final diaController = TextEditingController();
    final valorController = TextEditingController();
    String tipoSelecionado = 'Receita';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        final isDark = theme.brightness == Brightness.dark;

        return MediaQuery.removeViewInsets(
          context: dialogContext,
          removeBottom: true,
          child: Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 440,
                maxHeight: 520,
              ),
              child: Material(
                color: isDark ? const Color(0xFF020617) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _DialogHeader(
                      title: 'Nova Operação Automática',
                      color: const Color(0xFFD79706),
                      onClose: () => Navigator.of(dialogContext).pop(),
                    ),

                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _label('Descrição', isDark),
                            const SizedBox(height: 6),
                            TextField(
                              controller: tituloController,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              decoration: _novaOpInputDecoration(
                                dialogContext,
                                'Ex: Salário Mensal',
                              ),
                            ),
                            const SizedBox(height: 12),

                            _label('Dia do mês', isDark),
                            const SizedBox(height: 6),
                            TextField(
                              controller: diaController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              decoration:
                                  _novaOpInputDecoration(dialogContext, '1 a 31'),
                            ),
                            const SizedBox(height: 12),

                            _label('Valor', isDark),
                            const SizedBox(height: 6),
                            TextField(
                              controller: valorController,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              decoration: _novaOpInputDecoration(
                                dialogContext,
                                'Ex: 1200.50',
                              ),
                            ),
                            const SizedBox(height: 12),

                            _label('Tipo', isDark),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: tipoSelecionado,
                              isExpanded: true,
                              dropdownColor:
                                  isDark ? const Color(0xFF020617) : Colors.white,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              decoration:
                                  _novaOpInputDecoration(dialogContext, null),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Receita',
                                  child: Text('Receita'),
                                ),
                                DropdownMenuItem(
                                  value: 'Despesa',
                                  child: Text('Despesa'),
                                ),
                              ],
                              onChanged: (v) {
                                if (v != null) tipoSelecionado = v;
                              },
                            ),
                            const SizedBox(height: 18),

                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        Navigator.of(dialogContext).pop(),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                    ),
                                    child: const Text('Cancelar'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD79706),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final user = _user;
                                      if (user == null) return;

                                      final titulo = tituloController.text.trim();
                                      final dia =
                                          int.tryParse(diaController.text.trim());
                                      final valor = double.tryParse(
                                        valorController.text
                                            .trim()
                                            .replaceAll(',', '.'),
                                      );

                                      if (titulo.isEmpty ||
                                          dia == null ||
                                          dia < 1 ||
                                          dia > 31 ||
                                          valor == null) {
                                        return;
                                      }

                                      final tipo = (tipoSelecionado == 'Receita')
                                          ? 'receita'
                                          : 'despesa';

                                      await _supabase
                                          .from('operacoes_automaticas')
                                          .insert({
                                        'user_id': user.id,
                                        'titulo': titulo,
                                        'tipo': tipo,
                                        'valor': valor,
                                        'dia_do_mes': dia,
                                        'ativa': true,
                                      });

                                      if (mounted) {
                                        Navigator.of(dialogContext).pop();
                                      }
                                      await _carregarOps();
                                    },
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _label(String text, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onClose;

  const _DialogHeader({
    required this.title,
    required this.color,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onClose,
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

InputDecoration _novaOpInputDecoration(BuildContext context, String? hint) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return InputDecoration(
    hintText: hint,
    isDense: true,
    filled: true,
    fillColor: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFF),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: isDark ? const Color(0xFF4B5563) : const Color(0xFFCBD5E1),
        width: 1,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFFD79706), width: 1.4),
    ),
  );
}

class _OperacaoAuto {
  final String id;
  final String titulo;
  final String tipo; 
  final double valor;
  final int diaDoMes;
  final bool ativa;

  _OperacaoAuto({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.valor,
    required this.diaDoMes,
    required this.ativa,
  });

  bool get isReceita => tipo == 'receita';

  String get descricaoUi =>
      'Todo dia $diaDoMes • ${isReceita ? 'Receita' : 'Despesa'}';

  String get valorUi => _money(valor);

  static _OperacaoAuto fromMap(Map<String, dynamic> m) => _OperacaoAuto(
        id: m['id'].toString(),
        titulo: (m['titulo'] ?? '').toString(),
        tipo: (m['tipo'] ?? '').toString(),
        valor: (m['valor'] as num).toDouble(),
        diaDoMes: (m['dia_do_mes'] as num).toInt(),
        ativa: (m['ativa'] ?? true) as bool,
      );
}

class _OperacaoItem extends StatelessWidget {
  final _OperacaoAuto data;
  final VoidCallback onDelete;

  const _OperacaoItem({
    required this.data,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final corValor =
        data.isReceita ? const Color(0xFF00A86B) : const Color(0xFFE53935);

    final cardColor = isDark ? const Color(0xFF0B1120) : const Color(0xFFF8F5FF);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.titulo,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.descricaoUi,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            data.valorUi,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: corValor,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline,
              size: 20,
              color: Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }
}

String _money(double v) {
  final sign = v < 0 ? '-' : '';
  final abs = v.abs();
  final fixed = abs.toStringAsFixed(2);
  final parts = fixed.split('.');
  final inteiro = parts[0];
  final dec = parts[1];

  final buf = StringBuffer();
  for (int i = 0; i < inteiro.length; i++) {
    final posFromEnd = inteiro.length - i;
    buf.write(inteiro[i]);
    if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write('.');
  }
  return '${sign}R\$ ${buf.toString()},$dec';
}
