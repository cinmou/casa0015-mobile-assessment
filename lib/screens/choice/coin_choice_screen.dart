import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:the_oracle/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:the_oracle/providers/choice_provider.dart';

enum CoinResult { heads, tails, edge }

class CoinFlipScreen extends StatefulWidget {
  const CoinFlipScreen({super.key});

  @override
  State<CoinFlipScreen> createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  late Animation<double> _heightAnimation;

  final double coinSize = 120.0;
  final double coinThickness = 12.0;

  // Shake-related state variables
  bool _isShakeEnabled = false;
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  DateTime _lastShakeTime = DateTime.now();

  // Saving state
  bool _hasResult = false;
  CoinResult? _currentResult;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _heightAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.8).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.8, end: 1.0).chain(CurveTween(curve: Curves.bounceOut)), weight: 50),
    ]).animate(_controller);

    _flipAnimation = Tween<double>(begin: 0, end: 0).animate(_controller);

    _accelerometerSubscription = userAccelerometerEventStream().listen((UserAccelerometerEvent event) {
      if (!_isShakeEnabled) return;
      double acceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (acceleration > 15.0) {
        final now = DateTime.now();
        if (now.difference(_lastShakeTime).inMilliseconds > 400) {
          _flipCoin();
          _lastShakeTime = now;
        }
      }
    });
  }

  void _flipCoin() {
    setState(() {
      _hasResult = false;
    });
    
    int randomVal = Random().nextInt(200);
    double endAngle;

    if (randomVal == 0) {
      endAngle = (_flipAnimation.value - _flipAnimation.value % (2*pi)) + (pi * 10) + (pi / 2);
      _currentResult = CoinResult.edge;
    } else {
      bool isHeads = Random().nextBool();
      endAngle = (_flipAnimation.value - _flipAnimation.value % (2*pi)) + (isHeads ? (pi * 12) : (pi * 11));
      _currentResult = isHeads ? CoinResult.heads : CoinResult.tails;
    }

    _flipAnimation = Tween<double>(
      begin: _flipAnimation.value,
      end: endAngle,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart));

    HapticFeedback.heavyImpact();
    _controller.forward(from: 0).then((_) {
      HapticFeedback.mediumImpact();
      setState(() {
        _hasResult = true;
      });
    });
  }

  void _showSaveDialog() {
    final l10n = AppLocalizations.of(context)!;
    final questionController = TextEditingController();
    final solutionController = TextEditingController();
    String selectedMood = '🤔'; 
    
    String resultString = '';
    switch(_currentResult) {
      case CoinResult.heads: resultString = "Heads"; break;
      case CoinResult.tails: resultString = "Tails"; break;
      case CoinResult.edge: resultString = "Edge"; break;
      default: resultString = "Unknown";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(l10n.saveToMap),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.saveToMapResult(resultString)),
                    const SizedBox(height: 16),
                    Text(l10n.saveToMapQuestionHint, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    TextField(
                      controller: questionController,
                      decoration: const InputDecoration(
                        hintText: "e.g., Should I ask for a raise?",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.saveToMapMood),
                    DropdownButton<String>(
                      value: selectedMood,
                      isExpanded: true,
                      items: <String>['😃', '😐', '😔', '🤔', '😎', '😠', '😭'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(fontSize: 24)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setStateDialog(() {
                            selectedMood = newValue; 
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Text("My final decision is...", style: Theme.of(context).textTheme.labelLarge), // TODO: Add to l10n
                    const SizedBox(height: 8),
                    TextField(
                      controller: solutionController,
                      decoration: const InputDecoration(
                        hintText: "e.g., Yes, I'll schedule a meeting.",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(l10n.cancel),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text(l10n.save),
                  onPressed: () {
                    final question = questionController.text.trim();
                    final solution = solutionController.text.trim();
                    
                    context.read<ChoiceProvider>().addDecisionNode(
                      tool: 'Coin Flip',
                      result: resultString,
                      question: question,
                      solution: solution, 
                      mood: selectedMood,
                    );

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.savedToMapSuccess)),
                    );
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quickPickCoinFlip),
        actions: [
          if (_hasResult)
            IconButton(
              icon: const Icon(Icons.bookmark_add_outlined),
              tooltip: l10n.saveToMap,
              onPressed: _showSaveDialog,
            ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _flipCoin,
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final double rotation = _flipAnimation.value;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..scale(_heightAnimation.value)
                  ..rotateX(rotation),
                child: _build3DCoin(rotation),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        highlightElevation: 0,
        onPressed: () {
          setState(() {
            _isShakeEnabled = !_isShakeEnabled;
          });
          if (_isShakeEnabled) {
            HapticFeedback.selectionClick();
          }
        },
        shape: const CircleBorder(),
        backgroundColor: _isShakeEnabled ? Colors.amber.shade700 : Colors.grey.shade400,
        child: Icon(
          _isShakeEnabled ? Icons.vibration : Icons.mobile_off,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _build3DCoin(double rotation) {
    double normAngle = rotation % (2 * pi);

    bool isBackVisible = normAngle > pi / 2 && normAngle < 3 * pi / 2;
    bool isEdgeVisible = (normAngle > pi * 0.2 && normAngle < pi * 0.8) ||
        (normAngle > pi * 1.2 && normAngle < pi * 1.8);

    Widget frontFace = Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..translate(0.0, 0.0, -coinThickness / 2),
      child: _buildCoinFace(isBack: false),
    );

    Widget backFace = Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translate(0.0, 0.0, coinThickness / 2)
        ..rotateX(pi),
      child: _buildCoinFace(isBack: true),
    );

    List<Widget> stackChildren = [];

    if (isEdgeVisible) {
      stackChildren.add(
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateX(pi / 2)
            ..rotateZ(pi)
            ..rotateY(pi),
          child: _buildEdgeBand(),
        ),
      );
    }

    if (isBackVisible) {
      stackChildren.add(frontFace);
      stackChildren.add(backFace);
    } else {
      stackChildren.add(backFace);
      stackChildren.add(frontFace);
    }

    return Stack(
      alignment: Alignment.center,
      children: stackChildren,
    );
  }

  Widget _buildCoinFace({required bool isBack}) {
    return Container(
      width: coinSize,
      height: coinSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.amber.shade200, Colors.amber.shade600, Colors.amber.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.amber.shade900, width: 0.5),
      ),
      child: Center(
        child: Icon(
          isBack ? Icons.currency_pound : Icons.face,
          size: 60,
          color: Colors.amber.shade100.withValues(alpha: 0.9),
        ),
      ),
    );
  }

  Widget _buildEdgeBand() {
    return Container(
      width: coinSize,
      height: coinThickness,
      decoration: BoxDecoration(
        color: Colors.amber.shade900,
        gradient: LinearGradient(
          colors: [Colors.amber.shade900, Colors.amber.shade700, Colors.amber.shade900],
        ),
      ),
      child: const Center(
        child: Text(
          "The Oracle 2026",
          style: TextStyle(
            color: Colors.white60,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
