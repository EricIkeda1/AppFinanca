import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/adicionar_receita.dart';
import '../components/adicionar_despesa.dart';
import '../components/movimentos.dart';
import '../components/relatorio.dart';
import '../components/operacao_automatica.dart';
import '../components/perfil.dart';
import '../components/configuracoes.dart';
import '../components/opcoes.dart';
import '../login/login.dart';

final supabase = Supabase.instance.client;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String _getUserDisplayName() {
    final user = supabase.auth.currentUser; 
    if (user == null) return 'usuário';

    final meta = user.userMetadata ?? {};
    final nome = meta['nome'] as String?;
    if (nome != null && nome.trim().isNotEmpty) {
      return nome.trim();
    }

    return user.email ?? 'usuário';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = _getUserDisplayName();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _DashboardAppBar(displayName: displayName),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: _HomeBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _SummaryCard(
          title: 'Receitas',
          amount: 'R\$ 5.420,00',
          subtitle: '+12,5% vs mês anterior',
          amountColor: Color(0xFF00A86B),
          iconBg: Color(0xFFE5F8EE),
          icon: Icons.trending_up,
        ),
        SizedBox(height: 6),
        _SummaryCard(
          title: 'Despesas',
          amount: 'R\$ 3.180,50',
          subtitle: '+8,3% vs mês anterior',
          amountColor: Color(0xFFE53935),
          iconBg: Color(0xFFFDECEC),
          icon: Icons.trending_down,
        ),
        SizedBox(height: 8),
        _BalanceCard(),
        SizedBox(height: 12),
        _ActionsGrid(),
        SizedBox(height: 16),
        _LastTransactionsCard(),
        SizedBox(height: 14),
      ],
    );
  }
}

class _DashboardAppBar extends StatelessWidget {
  const _DashboardAppBar({required this.displayName});

  final String displayName;

  static final GlobalKey _profileBlockKey = GlobalKey();

  void _showProfileMenu(BuildContext context) async {
    final RenderBox block =
        _profileBlockKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset blockPosition = block.localToGlobal(Offset.zero);
    final Size blockSize = block.size;

    const double menuWidth = 220;

    final double left =
        blockPosition.dx + blockSize.width / 2 - menuWidth / 2;
    final double top = blockPosition.dy + blockSize.height + 6;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        left,
        top,
        overlay.size.width - left - menuWidth,
        overlay.size.height - top,
      ),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF020617) : Colors.white,
      items: [
        PopupMenuItem<String>(
          value: 'perfil',
          child: Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 18,
                color: isDark ? Colors.white70 : const Color(0xFF455A64),
              ),
              const SizedBox(width: 8),
              Text(
                'Meu Perfil',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'config',
          child: Row(
            children: [
              Icon(
                Icons.settings_outlined,
                size: 18,
                color: isDark ? Colors.white70 : const Color(0xFF455A64),
              ),
              const SizedBox(width: 8),
              Text(
                'Configurações',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'sair',
          child: Row(
            children: const [
              Icon(Icons.logout, size: 18, color: Color(0xFFE53935)),
              SizedBox(width: 8),
              Text(
                'Sair',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE53935),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    switch (selected) {
      case 'perfil':
        await PerfilDialog.show(context);
        break;
      case 'config':
        ConfiguracoesDialog.show(context);
        break;
      case 'sair':
        await supabase.auth.signOut(); 
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(isDark ? 0.7 : 0.15),
      child: Container(
        color: isDark ? const Color(0xFF020617) : const Color(0xFFE0E4EC),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isDark ? const Color(0xFF38BDF8) : const Color(0xFF00C853),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.attach_money,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Gerenciar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            GestureDetector(
              key: _profileBlockKey,
              behavior: HitTestBehavior.opaque,
              onTap: () => _showProfileMenu(context),
              child: Row(
                children: [
                  Text(
                    'Olá, $displayName',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFB0BEC5),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.white,
                    ),
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

class _SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final String subtitle;
  final Color amountColor;
  final Color iconBg;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.amountColor,
    required this.iconBg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.6 : 0.12),
            blurRadius: 24,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: amountColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 18, color: amountColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0066FF), Color(0xFF0061E0)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withOpacity(0.55),
            blurRadius: 28,
            spreadRadius: 3,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Expanded(
            child: _BalanceText(),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.24),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceText extends StatelessWidget {
  const _BalanceText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Saldo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'R\$ 2.239,50',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Disponível no mês',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ActionsGrid extends StatelessWidget {
  const _ActionsGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      _ActionItemData(
        label: 'Receita',
        icon: Icons.add,
        color: const Color(0xFF00A86B),
        onTap: () {
          AdicionarReceitaDialog.show(context);
        },
      ),
      _ActionItemData(
        label: 'Despesa',
        icon: Icons.remove,
        color: const Color(0xFFE53935),
        onTap: () {
          AdicionarDespesaDialog.show(context);
        },
      ),
      _ActionItemData(
        label: 'Movimentos',
        icon: Icons.table_rows_rounded,
        color: const Color(0xFF1565C0),
        onTap: () {
          MovimentosDialog.show(context);
        },
      ),
      _ActionItemData(
        label: 'Relatório',
        icon: Icons.calendar_today_rounded,
        color: const Color(0xFF8E24AA),
        onTap: () {
          RelatorioDialog.show(context);
        },
      ),
      _ActionItemData(
        label: 'Automática',
        icon: Icons.autorenew_rounded,
        color: const Color(0xFFEF6C00),
        onTap: () {
          OperacoesAutomaticasDialog.show(context);
        },
      ),
      _ActionItemData(
        label: 'Opções',
        icon: Icons.settings_rounded,
        color: const Color(0xFF455A64),
        onTap: () {
          OpcoesDialog.show(context);
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 10,
        childAspectRatio: 2.4,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _ActionCard(item: item);
      },
    );
  }
}

class _ActionItemData {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _ActionItemData({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _ActionCard extends StatelessWidget {
  final _ActionItemData item;

  const _ActionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: theme.cardColor,
      elevation: 6,
      shadowColor: Colors.black.withOpacity(isDark ? 0.6 : 0.12),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  item.icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
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

class _LastTransactionsCard extends StatelessWidget {
  const _LastTransactionsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.6 : 0.1),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                _LastTransactionsTitle(),
              ],
            ),
            SizedBox(height: 20),
            _LastTransactionsEmpty(),
          ],
        ),
      ),
    );
  }
}

class _LastTransactionsTitle extends StatelessWidget {
  const _LastTransactionsTitle();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      'Últimas Transações',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: isDark ? Colors.white38 : Colors.black26,
      ),
    );
  }
}

class _LastTransactionsEmpty extends StatelessWidget {
  const _LastTransactionsEmpty();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        const _EmptyTransactionsIcon(),
        const SizedBox(height: 12),
        Text(
          'Nenhuma transação registrada',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Comece adicionando uma receita ou despesa',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _EmptyTransactionsIcon extends StatelessWidget {
  const _EmptyTransactionsIcon();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE3EBFF),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Icon(
        Icons.table_rows_rounded,
        size: 24,
        color: isDark ? Colors.white70 : const Color(0xFF455A64),
      ),
    );
  }
}
