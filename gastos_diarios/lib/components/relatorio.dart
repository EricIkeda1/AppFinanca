import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final _supabase = Supabase.instance.client;

  DateTime _mes = DateTime(DateTime.now().year, DateTime.now().month, 1);
  late final _mesController = TextEditingController(text: _formatMonthBr(_mes));

  static const double _baseFontSize = 18;

  bool _loading = false;
  String? _error;

  List<_MesSerie> _serie = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gerarRelatorio();
    });
  }

  @override
  void dispose() {
    _mesController.dispose();
    super.dispose();
  }

  User? get _user => _supabase.auth.currentUser;

  Future<void> _selecionarMes() async {
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _mes,
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

    if (escolhida == null) return;

    setState(() {
      _mes = DateTime(escolhida.year, escolhida.month, 1);
      _mesController.text = _formatMonthBr(_mes);
    });

    await _gerarRelatorio();
  }

  Future<void> _gerarRelatorio() async {
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

      final inicio = DateTime(_mes.year, _mes.month, 1);
      final fim = DateTime(_mes.year, _mes.month + 1, 0); 

      final inicioIso = inicio.toIso8601String();
      final fimIso = DateTime(fim.year, fim.month, fim.day, 23, 59, 59).toIso8601String();

      final rows = await _supabase
          .from('movimentos')
          .select('tipo, valor, data')
          .eq('usuario_id', user.id)
          .gte('data', inicioIso)
          .lte('data', fimIso)
          .order('data', ascending: true);

      final list = (rows as List).cast<Map<String, dynamic>>();

      double receitas = 0;
      double despesas = 0;

      for (final r in list) {
        final tipo = (r['tipo'] ?? '').toString().toLowerCase();
        final valor = (r['valor'] as num).toDouble();
        if (tipo == 'receita') {
          receitas += valor;
        } else {
          despesas += valor;
        }
      }

      setState(() {
        _serie = [_MesSerie(ym: _YM(_mes.year, _mes.month), receitas: receitas, despesas: despesas)];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scale = MediaQuery.textScalerOf(context).scale(1.0);

    final labelStyle = TextStyle(
      fontSize: (_baseFontSize - 4) * scale,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white70 : Colors.black87,
    );

    final totalReceitas = _serie.fold<double>(0, (s, e) => s + e.receitas);
    final totalDespesas = _serie.fold<double>(0, (s, e) => s + e.despesas);
    final saldo = totalReceitas - totalDespesas;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF020617) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: const BoxDecoration(
                  color: Color(0xFF8E24AA),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Relatório por Mês',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _baseFontSize * scale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close, color: Colors.white, size: 22),
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
                      child: Text('Mês', style: labelStyle),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _mesController,
                      readOnly: true,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: (_baseFontSize - 2) * scale,
                      ),
                      onTap: _selecionarMes,
                      decoration: _inputDecoration(context, scale),
                    ),
                    const SizedBox(height: 16),

                    if (_error != null) ...[
                      Text(
                        _error!,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: (_baseFontSize - 6) * scale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    Container(
                      width: double.infinity,
                      height: 220,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2B2B2B) : const Color(0xFFF8F5FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.white.withValues(alpha: 0.12) : const Color(0xFFE0D7FF),
                          width: 1,
                        ),
                      ),
                      child: _loading
                          ? const Center(child: CircularProgressIndicator())
                          : _LineChartMensal(serie: _serie, isDark: isDark),
                    ),

                    const SizedBox(height: 14),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF140B24) : const Color(0xFFF8F5FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? const Color(0xFF3B2A60) : const Color(0xFFE0D7FF),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resumo do Período',
                            style: TextStyle(
                              fontSize: (_baseFontSize - 4) * scale,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF7B1FA2),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _ResumoRow(
                            label: 'Total de Receitas:',
                            value: _money(totalReceitas),
                            color: const Color(0xFF00A86B),
                            scale: scale,
                          ),
                          _ResumoRow(
                            label: 'Total de Despesas:',
                            value: _money(totalDespesas),
                            color: const Color(0xFFE53935),
                            scale: scale,
                          ),
                          _ResumoRow(
                            label: 'Saldo:',
                            value: _money(saldo),
                            color: const Color(0xFF1565C0),
                            scale: scale,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                color: isDark ? const Color(0xFF4B5563) : const Color(0xFFCED4DA),
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              'Fechar',
                              style: TextStyle(
                                fontSize: _baseFontSize * scale,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _loading ? null : _gerarRelatorio,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBA2FFF),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              'Gerar Relatório',
                              style: TextStyle(
                                fontSize: _baseFontSize * scale,
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

  InputDecoration _inputDecoration(BuildContext context, double scale) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: isDark ? const Color(0xFF020617) : Colors.white,
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
        borderSide: BorderSide(color: Color(0xFF8E24AA), width: 1.4),
      ),
    );
  }
}

class _LineChartMensal extends StatelessWidget {
  final List<_MesSerie> serie;
  final bool isDark;

  const _LineChartMensal({required this.serie, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final safeSerie = serie.isEmpty
        ? [_MesSerie(ym: const _YM(2000, 1), receitas: 0, despesas: 0)]
        : serie;

    final receitaSpots = <FlSpot>[];
    final despesaSpots = <FlSpot>[];

    double maxY = 0;
    for (int i = 0; i < safeSerie.length; i++) {
      receitaSpots.add(FlSpot(i.toDouble(), safeSerie[i].receitas));
      despesaSpots.add(FlSpot(i.toDouble(), safeSerie[i].despesas));
      maxY = [maxY, safeSerie[i].receitas, safeSerie[i].despesas].reduce((a, b) => a > b ? a : b);
    }
    if (maxY <= 0) maxY = 1;

    if (receitaSpots.length == 1) {
      receitaSpots.add(FlSpot(1, receitaSpots.first.y));
      despesaSpots.add(FlSpot(1, despesaSpots.first.y));
    }

    final receitaColor = const Color(0xFF26C6DA);
    final despesaColor = const Color(0xFFFFEB3B);

    return LineChart(
      LineChartData(
        backgroundColor: isDark ? const Color(0xFF2B2B2B) : null,
        minX: 0,
        maxX: (receitaSpots.length - 1).toDouble(),
        minY: 0,
        maxY: maxY * 1.2,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          getDrawingVerticalLine: (_) => FlLine(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.18),
            strokeWidth: 1,
            dashArray: const [6, 6],
          ),
          getDrawingHorizontalLine: (_) => FlLine(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.12),
            strokeWidth: 1,
            dashArray: const [6, 6],
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              getTitlesWidget: (value, meta) => Text(
                value >= 1000 ? '${(value / 1000).toStringAsFixed(0)}k' : value.toStringAsFixed(0),
                style: TextStyle(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: serie.isNotEmpty,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (serie.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    serie.first.ym.label,
                    style: TextStyle(
                      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(enabled: true),
        lineBarsData: [
          LineChartBarData(
            spots: receitaSpots,
            isCurved: true,
            curveSmoothness: 0.35,
            barWidth: 2.5,
            color: receitaColor,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 3.2,
                color: receitaColor,
                strokeWidth: 1.2,
                strokeColor: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: receitaColor.withValues(alpha: 0.10),
            ),
          ),
          LineChartBarData(
            spots: despesaSpots,
            isCurved: true,
            curveSmoothness: 0.35,
            barWidth: 2.5,
            color: despesaColor,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 3.2,
                color: despesaColor,
                strokeWidth: 1.2,
                strokeColor: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: despesaColor.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}

class _YM {
  final int year;
  final int month;
  const _YM(this.year, this.month);

  String get label => '${month.toString().padLeft(2, '0')}/$year';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is _YM && other.year == year && other.month == month);

  @override
  int get hashCode => Object.hash(year, month);
}

class _MesSerie {
  final _YM ym;
  final double receitas;
  final double despesas;

  const _MesSerie({
    required this.ym,
    required this.receitas,
    required this.despesas,
  });

  _MesSerie copyWith({double? receitas, double? despesas}) => _MesSerie(
        ym: ym,
        receitas: receitas ?? this.receitas,
        despesas: despesas ?? this.despesas,
      );
}

class _ResumoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final double scale;

  const _ResumoRow({
    required this.label,
    required this.value,
    required this.color,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14 * scale,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16 * scale,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatMonthBr(DateTime d) {
  final mm = d.month.toString().padLeft(2, '0');
  return '$mm/${d.year}';
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
