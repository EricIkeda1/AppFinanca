import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MovimentosDialog {
  static Future<void> show(BuildContext context) {
    return ExportarDadosDialog.show(context);
  }
}

class ExportarDadosDialog extends StatefulWidget {
  const ExportarDadosDialog({super.key});

  static const double _baseFontSize = 18;

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
  final _supabase = Supabase.instance.client;

  bool _loading = true;
  String? _error;
  List<Movimento> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  User? get _user => _supabase.auth.currentUser;

  Future<void> _load() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final user = _user;
      if (user == null) {
        setState(() {
          _items = const [];
          _loading = false;
          _error = 'Usuário não autenticado.';
        });
        return;
      }

      final rows = await _supabase
          .from('movimentos')
          .select('id, usuario_id, tipo, valor, descricao, data, categoria')
          .eq('usuario_id', user.id)
          .order('data', ascending: false);

      final list = (rows as List)
          .map((e) => Movimento.fromMap(e as Map<String, dynamic>))
          .toList();

      setState(() {
        _items = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _createMovimento() async {
    final user = _user;
    if (user == null) return;

    final res = await showDialog<_NovoMovimentoResult>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _NovoMovimentoDialog(),
    );
    if (res == null) return;

    try {
      await _supabase.from('movimentos').insert({
        'usuario_id': user.id,
        'tipo': res.tipo,
        'valor': res.valor,
        'descricao': res.descricao,
        'categoria': res.categoria,
        'data': res.data.toIso8601String(),
      });

      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  Future<void> _deleteMovimento(String id) async {
    await _supabase.from('movimentos').delete().eq('id', id);
  }

  void _showUndoSnackBar({
    required Movimento deleted,
    required int deletedIndex,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Movimento apagado: ${deleted.descricao.isNotEmpty ? deleted.descricao : '(Sem descrição)'}',
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              final safeIndex = deletedIndex.clamp(0, _items.length);
              final copy = List<Movimento>.from(_items);
              copy.insert(safeIndex, deleted);
              _items = copy;
            });
          },
        ),
      ),
    );
  }

  Future<void> _handleSwipeDelete(Movimento m, int index) async {
    setState(() {
      final copy = List<Movimento>.from(_items);
      copy.removeAt(index);
      _items = copy;
    });

    _showUndoSnackBar(deleted: m, deletedIndex: index);

    try {
      await _deleteMovimento(m.id);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        final copy = List<Movimento>.from(_items);
        copy.insert(index.clamp(0, copy.length), m);
        _items = copy;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir: $e')),
      );
    }
  }

  Widget _swipeHint({
    required bool isDark,
    required double scale,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 18 * scale,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Dica: arraste um item para a esquerda para excluir.',
              style: TextStyle(
                fontSize: (ExportarDadosDialog._baseFontSize - 6) * scale,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final scale = MediaQuery.textScalerOf(context).scale(1.0);

    final maxDialogHeight = size.height * 0.8;

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
              _Header(
                scale: scale,
                onAdd: _createMovimento,
                onClose: () => Navigator.of(context).pop(),
                title: 'Movimentos',
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(
                              child: Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:
                                      (ExportarDadosDialog._baseFontSize - 4) *
                                          scale,
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            )
                          : _items.isEmpty
                              ? Center(
                                  child: Text(
                                    'Nenhum movimento ainda.',
                                    style: TextStyle(
                                      fontSize:
                                          (ExportarDadosDialog._baseFontSize -
                                                  2) *
                                              scale,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    _swipeHint(isDark: isDark, scale: scale),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: RefreshIndicator(
                                        onRefresh: _load,
                                        child: ListView.separated(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemCount: _items.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 10),
                                          itemBuilder: (context, i) {
                                            final m = _items[i];
                                            return Dismissible(
                                              key: ValueKey(m.id),
                                              direction:
                                                  DismissDirection.endToStart,
                                              background: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                padding: const EdgeInsets.only(
                                                    right: 16),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFE53935),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: const Icon(Icons.delete,
                                                    color: Colors.white),
                                              ),
                                              onDismissed: (_) =>
                                                  _handleSwipeDelete(m, i),
                                              child: _MovimentoItem(data: m),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
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
                    child: Text(
                      'Fechar',
                      style: TextStyle(
                        fontSize: ExportarDadosDialog._baseFontSize * scale,
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

class _Header extends StatelessWidget {
  final double scale;
  final VoidCallback onAdd;
  final VoidCallback onClose;
  final String title;

  const _Header({
    required this.scale,
    required this.onAdd,
    required this.onClose,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF1565C0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: (ExportarDadosDialog._baseFontSize + 2) * scale,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Adicionar',
            onPressed: onAdd,
            icon: const Icon(Icons.add, color: Colors.white),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onClose,
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(Icons.close, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class Movimento {
  final String id;
  final String usuarioId;
  final String tipo;
  final double valor;
  final String descricao;
  final DateTime data;
  final String categoria;

  bool get isReceita => tipo.toLowerCase() == 'receita';

  Movimento({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.valor,
    required this.descricao,
    required this.data,
    required this.categoria,
  });

  factory Movimento.fromMap(Map<String, dynamic> m) {
    return Movimento(
      id: m['id'] as String,
      usuarioId: m['usuario_id'] as String,
      tipo: (m['tipo'] ?? '').toString(),
      valor: (m['valor'] as num).toDouble(),
      descricao: (m['descricao'] ?? '').toString(),
      data: DateTime.parse(m['data'].toString()),
      categoria: (m['categoria'] ?? '').toString(),
    );
  }
}

class _MovimentoItem extends StatelessWidget {
  final Movimento data;
  const _MovimentoItem({required this.data});

  static const double _baseFontSize = 18;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scale = MediaQuery.textScalerOf(context).scale(1.0);

    final corIcone =
        data.isReceita ? const Color(0xFF00A86B) : const Color(0xFFE53935);
    final cardColor =
        isDark ? const Color(0xFF0B1120) : const Color(0xFFF3F4F6);

    final valorStr = _formatMoneyPtBr(
      data.valor,
      prefix: data.isReceita ? '+R\$ ' : '-R\$ ',
    );

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
              color: corIcone.withValues(alpha: 0.12),
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
                  data.descricao.isNotEmpty ? data.descricao : '(Sem descrição)',
                  style: TextStyle(
                    fontSize: (_baseFontSize - 2) * scale,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.categoria} • ${_formatDateBr(data.data)} • ${data.tipo}',
                  style: TextStyle(
                    fontSize: (_baseFontSize - 6) * scale,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            valorStr,
            style: TextStyle(
              fontSize: (_baseFontSize - 2) * scale,
              fontWeight: FontWeight.w700,
              color: corIcone,
            ),
          ),
        ],
      ),
    );
  }
}

class _NovoMovimentoDialog extends StatefulWidget {
  const _NovoMovimentoDialog();

  @override
  State<_NovoMovimentoDialog> createState() => _NovoMovimentoDialogState();
}

class _NovoMovimentoDialogState extends State<_NovoMovimentoDialog> {
  final _formKey = GlobalKey<FormState>();

  final _descricaoCtrl = TextEditingController();
  final _categoriaCtrl = TextEditingController();
  final _valorCtrl = TextEditingController();

  String _tipo = 'despesa';
  DateTime _data = DateTime.now();

  @override
  void dispose() {
    _descricaoCtrl.dispose();
    _categoriaCtrl.dispose();
    _valorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Novo movimento'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _tipo,
                items: const [
                  DropdownMenuItem(value: 'receita', child: Text('Receita')),
                  DropdownMenuItem(value: 'despesa', child: Text('Despesa')),
                ],
                onChanged: (v) => setState(() => _tipo = v ?? 'despesa'),
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              TextFormField(
                controller: _descricaoCtrl,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe a descrição' : null,
              ),
              TextFormField(
                controller: _categoriaCtrl,
                decoration: const InputDecoration(labelText: 'Categoria'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe a categoria' : null,
              ),
              TextFormField(
                controller: _valorCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Valor (ex: 12.50)'),
                validator: (v) {
                  final n = double.tryParse((v ?? '').replaceAll(',', '.'));
                  if (n == null || n <= 0) return 'Informe um valor válido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text('Data: ${_formatDateBr(_data)}')),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _data,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _data = picked);
                    },
                    child: const Text('Escolher'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final valor = double.parse(_valorCtrl.text.replaceAll(',', '.'));
            Navigator.of(context).pop(
              _NovoMovimentoResult(
                tipo: _tipo,
                valor: valor,
                descricao: _descricaoCtrl.text.trim(),
                categoria: _categoriaCtrl.text.trim(),
                data: _data,
              ),
            );
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}

class _NovoMovimentoResult {
  final String tipo;
  final double valor;
  final String descricao;
  final String categoria;
  final DateTime data;

  _NovoMovimentoResult({
    required this.tipo,
    required this.valor,
    required this.descricao,
    required this.categoria,
    required this.data,
  });
}

String _formatDateBr(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  final yyyy = d.year.toString();
  return '$dd/$mm/$yyyy';
}

String _formatMoneyPtBr(double v, {String prefix = 'R\$ '}) {
  final fixed = v.toStringAsFixed(2);
  final parts = fixed.split('.');
  final inteiro = parts[0];
  final dec = parts[1];

  final buf = StringBuffer();
  for (int i = 0; i < inteiro.length; i++) {
    final posFromEnd = inteiro.length - i;
    buf.write(inteiro[i]);
    if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write('.');
  }
  return '$prefix${buf.toString()},$dec';
}
