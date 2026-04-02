import 'package:flutter/material.dart';
import 'package:the_oracle/l10n/app_localizations.dart';
import 'package:the_oracle/screens/choice/coin_choice_screen.dart';
import 'package:the_oracle/screens/choice/dice_choice_screen.dart';
// import 'package:the_oracle/screens/choice/fortune_stick_screen.dart';
import 'package:the_oracle/screens/oracle/oracle_pick_screen.dart';

class ChoiceScreen extends StatelessWidget {
  const ChoiceScreen({super.key});

  void _showIntroductionDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.appIntroductionTitle),
          content: Text(l10n.appIntroductionContent),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.choiceScreenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showIntroductionDialog(context),
            tooltip: l10n.appIntroductionTitle,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildToolCard(
              context,
              icon: Icons.monetization_on_outlined,
              label: l10n.quickPickCoinFlip,
              color: theme.colorScheme.primaryContainer,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CoinFlipScreen()));
              },
            ),
            _buildToolCard(
              context,
              icon: Icons.casino_outlined,
              label: l10n.quickPickDiceRoll,
              color: theme.colorScheme.secondaryContainer,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DiceRollScreen()));
              },
            ),
            _buildToolCard(
              context,
              icon: Icons.filter_vintage_outlined,
              label: l10n.quickPickFortuneSticks,
              color: theme.colorScheme.tertiaryContainer,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DiceRollScreen()));
              },
            ),
            _buildToolCard(
              context,
              icon: Icons.style_outlined,
              label: l10n.bottomNavOracle,
              color: theme.colorScheme.surfaceVariant,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const OraclePickScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.onPrimaryContainer),
            const SizedBox(height: 12),
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
