import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/tarot_provider.dart';
import '../../../providers/history_provider.dart';
import '../../../models/tarot_card.dart';
import '../../../models/history_item.dart';
import '../../../widgets/tarot_card_widget.dart';

class OracleRandomSingleDrawScreen extends StatefulWidget {
  const OracleRandomSingleDrawScreen({super.key});

  @override
  State<OracleRandomSingleDrawScreen> createState() => _OracleRandomSingleDrawScreenState();
}

class _OracleRandomSingleDrawScreenState extends State<OracleRandomSingleDrawScreen> with SingleTickerProviderStateMixin {
  TarotCard? _drawnCard;
  bool? _isReversed;
  bool _isFaceUp = false;
  bool _hasFlippedOnce = false;
  bool _hasSaved = false;
  late AnimationController _feedbackController;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _drawRandomCard();
    });
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _drawRandomCard() {
    final provider = context.read<TarotProvider>();
    if (provider.cards.isEmpty) return;
    setState(() {
      final random = Random();
      _drawnCard = provider.cards[random.nextInt(provider.cards.length)];
      _isReversed = random.nextBool();
    });
  }

  void _onCardFlipped() {
    if (!_hasFlippedOnce) {
      HapticFeedback.mediumImpact();
      setState(() {
        _isFaceUp = true;
        _hasFlippedOnce = true;
      });
      if (!_hasSaved) {
        _saveToHistory();
      }
    } else {
      setState(() {
        _isFaceUp = !_isFaceUp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD4AF37);
    const bgColor = Color(0xFF1A1221);
    final l10n = AppLocalizations.of(context)!;

    if (_drawnCard == null) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(child: CircularProgressIndicator(color: goldColor)),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: _buildAppBar(context, goldColor, l10n),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          SizedBox(
            height: 480,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: _isFaceUp ? [
                    BoxShadow(
                      color: goldColor.withAlpha(100),
                      blurRadius: 25,
                      spreadRadius: 2,
                    )
                  ] : [],
                ),
                child: TarotCardWidget(
                  card: _drawnCard!,
                  isFaceUp: _isFaceUp,
                  isReversed: _isReversed!,
                  animateOnTap: !_hasFlippedOnce,
                  enableTilt: true,
                  onFlip: _onCardFlipped,
                ),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!_hasFlippedOnce)
                  Text(
                    l10n.singleDrawTapToReveal,
                    style: const TextStyle(color: Colors.white24, letterSpacing: 2, fontSize: 14),
                  ),
                const SizedBox(height: 5),
                AnimatedOpacity(
                  opacity: _hasFlippedOnce ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: _hasFlippedOnce
                      ? Column(
                          children: [
                            _buildBottomInfo(),
                            ElevatedButton(
                              onPressed: () => _showMeaningSheet(context, _drawnCard!, _isReversed!, l10n),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: goldColor,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                shape: const StadiumBorder(),
                                // elevation: 8,
                                // shadowColor: goldColor.withAlpha(128),
                              ),
                              child: Text(
                                l10n.singleDrawShowMeaning,
                                style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Color goldColor, AppLocalizations l10n) {
    return AppBar(
      title: Text(l10n.oraclePickDailyDraw, style: TextStyle(color: goldColor, letterSpacing: 1.5)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFD4AF37)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        AnimatedBuilder(
          animation: _feedbackController,
          builder: (context, child) {
            double glowScale = 0.5 + (_feedbackController.value * 1.5);
            double glowOpacity = (1.0 - _feedbackController.value).clamp(0.0, 0.6);
            return Stack(
              alignment: Alignment.center,
              children: [
                if (_feedbackController.isAnimating)
                  Transform.scale(
                    scale: glowScale,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [goldColor.withAlpha((glowOpacity * 255).toInt()), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                IconButton(
                  icon: Icon(Icons.history, color: _feedbackController.isAnimating ? Colors.white : goldColor),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OracleSingleCardHistoryScreen())),
                )
              ],
            );
          },
        ),
      ],
    );
  }

  void _showMeaningSheet(BuildContext context, TarotCard card, bool isRev, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withAlpha(51),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          card.name,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (isRev)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l10n.readingSummaryReversedAbbr,
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: (isRev ? card.reversedKeywords : card.uprightKeywords).map((keyword) {
                        return Chip(
                          label: Text(keyword),
                          labelStyle: textTheme.bodySmall,
                          backgroundColor: colorScheme.surfaceContainer,
                          side: BorderSide.none,
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      isRev ? card.reversedMeaning : card.uprightMeaning,
                      style: textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 底部信息 (抽牌后 - 永久显示)
  Widget _buildBottomInfo() {
    return Column(
      children: [
        Text(
          _drawnCard!.name.toUpperCase(),
          style: const TextStyle(fontSize: 26, color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (_isReversed == true)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.redAccent.withAlpha(128)),
                borderRadius: BorderRadius.circular(4)
            ),
            child: const Text("REVERSED", style: TextStyle(color: Colors.redAccent, fontSize: 10, letterSpacing: 1.2)),
          ),
        const SizedBox(height: 10),
        Text(
          (_isReversed! ? _drawnCard!.reversedKeywords : _drawnCard!.uprightKeywords).join(" • "),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _saveToHistory() {
    if (_drawnCard == null) return;
    final l10n = AppLocalizations.of(context)!;
    final newItem = HistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: HistoryType.singleTarot,
      timestamp: DateTime.now(),
      payload: {
        'name': _drawnCard!.name,
        'img': _drawnCard!.img,
        'isReversed': _isReversed,
        'arcana': _drawnCard!.arcana,
        'keywords': _isReversed! ? _drawnCard!.reversedKeywords : _drawnCard!.uprightKeywords,
      },
      question: l10n.oraclePickDailyDraw,
      isFavorite: false,
    );
    context.read<HistoryProvider>().addRecord(newItem);
    _feedbackController.forward(from: 0.0);
    setState(() => _hasSaved = true);
  }
}
