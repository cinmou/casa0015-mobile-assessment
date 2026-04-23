import 'package:flutter/material.dart';
import 'package:the_oracle/l10n/app_localizations.dart';

class IntroSplashScreen extends StatelessWidget {
  final VoidCallback? onContinue;

  const IntroSplashScreen({super.key, this.onContinue});

  void _continue(BuildContext context) {
    if (onContinue != null) {
      onContinue!();
      return;
    }
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isChinese = Localizations.localeOf(context).languageCode == 'zh';
    final introTitle = isChinese
        ? '一个用于微小选择的助手'
        : 'A companion for small choices';
    final introBody = isChinese
        ? [
            '现代生活里，我们每天都会面对许多看似很小、却不断消耗精力的选择：早餐吃什么，晚上是否休息，今天该社交还是陪伴家人。',
            'Oracle Map 是一个非侵入式的小工具。它不会替你直接给出人生答案，而是通过硬币、塔罗、骰子和抽签这些熟悉的物理交互，帮助你暂停一下，听见自己真正倾向的方向。',
            '记录功能是可选的。你可以保存当下的问题、心情、最终决定、工具结果，以及天气和位置等环境线索。久而久之，这些节点会形成一张属于你的抉择地图。',
            '这张地图帮助你回看日常选择的模式，在下一次遇到相似问题时，有一个更贴近自己的参考。',
          ]
        : [
            'Modern life is full of small choices that quietly consume time and attention: what to eat, whether to rest, whether to meet people, or whether to go home.',
            'Oracle Map is a non-intrusive decision tool. It does not choose for you. Instead, it uses familiar physical interactions such as coins, tarot cards, dice, and fortune sticks to help you pause and notice what you may already want.',
            'Saving a decision is optional. When you do, the app records your question, mood, final decision, tool result, and environmental context such as weather and location.',
            'Over time, these records become a personal Decision Map: a way to review daily choices, recognise patterns, and build a more grounded reference for future moments.',
          ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Icon(
                Icons.explore_outlined,
                size: 72,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                introTitle,
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final paragraph in introBody) ...[
                        Text(
                          paragraph,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _continue(context),
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(l10n.ok),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
