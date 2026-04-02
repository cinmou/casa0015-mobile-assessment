import 'package:flutter/material.dart';
import 'package:the_oracle/l10n/app_localizations.dart'; // 确保路径正确

class DecisionMapScreen extends StatelessWidget {
  const DecisionMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bottomNavMap), // 使用本地化字符串
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.decisionMapScreenTitle, // 使用本地化字符串
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // TODO: 未来这里将是水平抉择地图的实现
          ],
        ),
      ),
    );
  }
}
