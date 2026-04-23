import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../../providers/tarot_provider.dart';
import '../../../providers/history_provider.dart';
import '../../../models/tarot_card.dart';
import '../../../models/history_item.dart';
import '../../../widgets/tarot_card_widget.dart';
import 'oracle_single_card_history_screen.dart';

class SingleCardDrawScreen extends StatefulWidget {
  const SingleCardDrawScreen({super.key});

  @override
  State<SingleCardDrawScreen> createState() => _SingleCardDrawScreenState();
}

class _SingleCardDrawScreenState extends State<SingleCardDrawScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _feedbackController;

  double _currentPage = 0.0;
  int _lastSnappedPage = 0;

  bool _hasRevealed = false;
  bool _isResultFaceUp = false;

  List<TarotCard> _shuffledPool = [];
  List<bool> _isReversedPool = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.7);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
      int roundedPage = _currentPage.round();
      if (roundedPage != _lastSnappedPage) {
        HapticFeedback.selectionClick();
        _lastSnappedPage = roundedPage;
      }
    });

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _prepareCards(List<TarotCard> allCards) {
    if (allCards.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _shuffledPool = List.from(allCards)..shuffle();
        _isReversedPool = List.generate(
          _shuffledPool.length,
          (_) => Random().nextBool(),
        );
      });
    });
  }

  void _confirmSelection() {
    if (_hasRevealed) return;

    HapticFeedback.mediumImpact();
    _saveToHistory();

    setState(() {
      _hasRevealed = true;
      _isResultFaceUp = false;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _isResultFaceUp = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TarotProvider>();
    const Color goldColor = Color(0xFFD4AF37);
    const Color bgColor = Color(0xFF1A1221);

    if (provider.isLoading || provider.cards.isEmpty || _shuffledPool.isEmpty) {
      if (!provider.isLoading &&
          provider.cards.isNotEmpty &&
          _shuffledPool.isEmpty) {
        _prepareCards(provider.cards);
      }
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(child: CircularProgressIndicator(color: goldColor)),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "Reveal Fate",
          style: TextStyle(color: goldColor, letterSpacing: 2),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: goldColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          AnimatedBuilder(
            animation: _feedbackController,
            builder: (context, child) {
              double glowScale = 0.5 + (_feedbackController.value * 1.5);
              double glowOpacity = (1.0 - _feedbackController.value).clamp(
                0.0,
                0.6,
              );
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
                            colors: [
                              goldColor.withValues(alpha: glowOpacity),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  IconButton(
                    icon: Icon(
                      Icons.history,
                      color: _feedbackController.isAnimating
                          ? Colors.white
                          : goldColor,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OracleSingleCardHistoryScreen(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Spacer(),

          SizedBox(
            height: 480,
            child: _hasRevealed ? _buildRevealedResult() : _buildSwipeDeck(),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(
              left: 40,
              right: 40,
              top: 20,
              bottom: 80,
            ),
            child: _hasRevealed
                ? _buildBottomInfo()
                : _buildControlPanel(goldColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeDeck() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _shuffledPool.length,
      itemBuilder: (context, index) {
        double delta = index - _currentPage;
        double absDelta = delta.abs();
        double scale = (1.0 - (absDelta * 0.3)).clamp(0.8, 1.2);

        bool isCentered = absDelta < 0.1;

        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (isCentered) _confirmSelection();
            },
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isCentered
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFFD4AF37,
                            ).withValues(alpha: 0.6),
                            blurRadius: 25,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                // Keep the deck card visual-only so the outer tap selects it.
                child: IgnorePointer(
                  ignoring: true,
                  child: TarotCardWidget(
                    card: _shuffledPool[index],
                    isFaceUp: false,
                    animateOnTap: false,
                    enableTilt: false,
                    isReversed: _isReversedPool[index],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRevealedResult() {
    int idx = _currentPage.round();

    return Center(
      child: TarotCardWidget(
        card: _shuffledPool[idx],
        isFaceUp: _isResultFaceUp,
        isReversed: _isReversedPool[idx],
        animateOnTap: true,
        enableTilt: true,
        allowReversed: true,
        onFlip: () {
          setState(() => _isResultFaceUp = !_isResultFaceUp);
        },
      ),
    );
  }

  Widget _buildControlPanel(Color goldColor) {
    int currentNum = _currentPage.round() + 1;
    return Column(
      children: [
        Text(
          "$currentNum / ${_shuffledPool.length}",
          style: TextStyle(
            color: goldColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          value: (_currentPage / (_shuffledPool.length - 1)).clamp(0.0, 1.0),
          activeColor: goldColor,
          onChanged: (val) {
            int targetPage = (val * (_shuffledPool.length - 1)).round();
            _pageController.animateToPage(
              targetPage,
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
            );
          },
        ),
        const SizedBox(height: 79),
      ],
    );
  }

  Widget _buildBottomInfo() {
    int idx = _currentPage.round();
    final card = _shuffledPool[idx];
    final isRev = _isReversedPool[idx];

    return Column(
      children: [
        Text(
          card.name.toUpperCase(),
          style: const TextStyle(
            fontSize: 26,
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (isRev)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.redAccent.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              "REVERSED",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
          ),
        const SizedBox(height: 15),
        Text(
          (isRev ? card.reversedKeywords : card.uprightKeywords).join(" • "),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  void _saveToHistory() {
    int idx = _currentPage.round();
    final card = _shuffledPool[idx];
    final isRev = _isReversedPool[idx];

    final newItem = HistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: HistoryType.singleTarot,
      timestamp: DateTime.now(),
      payload: {
        'name': card.name,
        'img': card.img,
        'isReversed': isRev,
        'arcana': card.arcana,
        'keywords': isRev ? card.reversedKeywords : card.uprightKeywords,
      },
      question: "Myriad Truths",
      isFavorite: false,
    );

    context.read<HistoryProvider>().addRecord(newItem);
    _feedbackController.forward(from: 0.0);
  }
}
