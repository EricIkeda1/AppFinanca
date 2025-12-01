import 'package:flutter/material.dart';

class TermosDeUsoDialog {
  const TermosDeUsoDialog._();

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _TermosDeUsoContent(),
    );
  }
}

class _TermosDeUsoContent extends StatelessWidget {
  const _TermosDeUsoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 700,
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF1D4ED8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Termos de Uso',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFE5E7EB)),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _SectionTitle('Termos de Uso'),
                    SizedBox(height: 14),

                    _SectionTitle('1. Aceitação dos Termos'),
                    SizedBox(height: 6),
                    _SectionText(
                      'Ao acessar e usar o FinanceControl, você concorda em cumprir e '
                      'estar vinculado aos seguintes termos e condições de uso. Se '
                      'você não concordar com alguma parte destes termos, não deverá '
                      'usar este aplicativo.',
                    ),

                    SizedBox(height: 18),
                    _SectionTitle('2. Uso do Serviço'),
                    SizedBox(height: 6),
                    _SectionText(
                      'O FinanceControl é um aplicativo de gerenciamento financeiro '
                      'pessoal. Você se compromete a usar o serviço apenas para fins '
                      'legais e de acordo com estes Termos de Uso. Você é responsável '
                      'por manter a confidencialidade de sua conta e senha.',
                    ),

                    SizedBox(height: 18),
                    _SectionTitle('3. Privacidade e Dados Pessoais'),
                    SizedBox(height: 6),
                    _SectionText(
                      'Levamos sua privacidade a sério. Coletamos e armazenamos apenas '
                      'as informações necessárias para fornecer nossos serviços. Seus '
                      'dados financeiros são armazenados de forma segura e não serão '
                      'compartilhados com terceiros sem seu consentimento explícito.',
                    ),

                    SizedBox(height: 18),
                    _SectionTitle('4. Conteúdo do Usuário'),
                    SizedBox(height: 6),
                    _SectionText(
                      'Você mantém todos os direitos sobre os dados financeiros e '
                      'informações que você insere no aplicativo. Somos apenas '
                      'responsáveis por fornecer a plataforma para gerenciar essas '
                      'informações.',
                    ),

                    SizedBox(height: 18),
                    _SectionTitle('5. Responsabilidades'),
                    SizedBox(height: 6),
                    _SectionText(
                      'O FinanceControl é fornecido "como está" e "conforme disponível". '
                      'Não garantimos que o serviço será ininterrupto ou livre de erros. '
                      'Você é responsável por verificar a precisão de suas informações '
                      'financeiras e decisões baseadas nos dados do aplicativo.',
                    ),

                    SizedBox(height: 18),
                    _SectionTitle('6. Limitação de Responsabilidade'),
                    SizedBox(height: 6),
                    _SectionText(
                      'Em nenhuma circunstância seremos responsáveis por quaisquer '
                      'danos diretos, indiretos, incidentais, especiais ou '
                      'consequenciais resultantes do uso ou incapacidade de usar o '
                      'serviço.',
                    ),

                    SizedBox(height: 18),
                    _SectionTitle('7. Modificações dos Termos'),
                    SizedBox(height: 6),
                    _SectionText(
                      'Reservamos o direito de modificar estes termos a qualquer '
                      'momento. Notificaremos você sobre alterações significativas '
                      'através do aplicativo ou por e-mail. O uso continuado do '
                      'serviço após tais modificações constitui aceitação dos novos '
                      'termos.',
                    ),

                    SizedBox(height: 18),
                    _SectionTitle('8. Cancelamento'),
                    SizedBox(height: 6),
                    _SectionText(
                      'Você pode cancelar sua conta a qualquer momento através das '
                      'configurações do aplicativo. Reservamos o direito de suspender '
                      'ou encerrar sua conta se houver violação destes Termos de Uso.',
                    ),
                    
                    SizedBox(height: 18),
                    _SectionText(
                      'Última atualização: 1 de dezembro de 2025',
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, color: Color(0xFFE5E7EB)),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Fechar',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Color(0xFF111827),
      ),
    );
  }
}

class _SectionText extends StatelessWidget {
  final String text;
  const _SectionText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        height: 1.4,
        color: Color(0xFF4B5563),
      ),
    );
  }
}
