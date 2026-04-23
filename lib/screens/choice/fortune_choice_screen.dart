import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:the_oracle/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:the_oracle/providers/choice_provider.dart';

enum FortuneStickResult { short, medium, long }

class FortuneStickScreen extends StatefulWidget {
  const FortuneStickScreen({super.key});

  @override
  State<FortuneStickScreen> createState() => _FortuneStickScreenState();
}

class _FortuneStickScreenState extends State<FortuneStickScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  FortuneStickResult? _currentResult;
  bool _hasResult = false;
  static const goldColor = Color(0xFFD4AF37);
  static const bgColor = Color(0xFF4E342E); // Deep wood color

  // Shake-related state variables
  bool _isShakeEnabled = false;
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  DateTime _lastShakeTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _accelerometerSubscription = userAccelerometerEventStream().listen((
      UserAccelerometerEvent event,
    ) {
      if (!_isShakeEnabled) return;
      double acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );
      if (acceleration > 15.0) {
        final now = DateTime.now();
        if (now.difference(_lastShakeTime).inMilliseconds > 400) {
          _drawStick();
          _lastShakeTime = now;
        }
      }
    });
  }

  void _drawStick() {
    if (_controller.isAnimating) return;
    setState(() {
      _hasResult = false;
    });

    final random = Random();
    final int resultIndex = random.nextInt(FortuneStickResult.values.length);
    _currentResult = FortuneStickResult.values[resultIndex];

    HapticFeedback.mediumImpact();
    _controller.forward(from: 0).then((_) {
      setState(() {
        _hasResult = true;
      });
    });
  }

  void _showSaveDialog() {
    if (_currentResult == null) return;

    final l10n = AppLocalizations.of(context)!;
    final questionController = TextEditingController();
    final solutionController = TextEditingController();
    String selectedMood = '🤔';

    String resultString = '';
    switch (_currentResult) {
      case FortuneStickResult.short:
        resultString = l10n.fortuneStickShort;
        break;
      case FortuneStickResult.medium:
        resultString = l10n.fortuneStickMedium;
        break;
      case FortuneStickResult.long:
        resultString = l10n.fortuneStickLong;
        break;
      default:
        resultString = "Unknown";
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
                    Text(
                      l10n.saveToMapQuestionHint,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: questionController,
                      decoration: InputDecoration(
                        // hintText: l10n.saveToMapQuestionExample,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.saveToMapMood),
                    DropdownButton<String>(
                      value: selectedMood,
                      isExpanded: true,
                      items: <String>['😃', '😐', '😔', '🤔', '😎', '😠', '😭']
                          .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(fontSize: 24),
                              ),
                            );
                          })
                          .toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setStateDialog(() {
                            selectedMood = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.saveToMapFinalDecision,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: solutionController,
                      decoration: InputDecoration(
                        // hintText: l10n.saveToMapSolutionExample,
                        border: const OutlineInputBorder(),
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
                      tool: l10n.fortuneToolName,
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
          },
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
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          l10n.quickPickFortuneSticks,
          style: const TextStyle(color: goldColor),
        ), // Set title color to gold
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: goldColor,
          ), // Set back button color to gold
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_hasResult)
            IconButton(
              icon: const Icon(Icons.bookmark_add_outlined, color: goldColor),
              tooltip: l10n.saveToMap,
              onPressed: _showSaveDialog,
            ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _drawStick,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              SizedBox(
                height: 550, // Provide enough space for the animation
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    _buildStickCylinder(),
                    if (_currentResult != null) _buildAnimatedStick(),
                  ],
                ),
              ),
              const Spacer(),
              if (_currentResult != null) _buildAnimatedResultText(l10n),
              const Spacer(),
              const SizedBox(height: 40),
            ],
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
        backgroundColor: _isShakeEnabled
            ? Colors.amber.shade700
            : Colors.grey.shade400,
        child: Icon(
          _isShakeEnabled ? Icons.vibration : Icons.mobile_off,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStickCylinder() {
    return Positioned(
      top: 0,
      child: Container(
        width: 150,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.brown.shade700,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.brown.shade900, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            // Sticks inside the cylinder
            ...List.generate(7, (index) {
              final rotation = (index - 3) * 0.1;
              return Transform.rotate(
                angle: rotation,
                child: Container(
                  width: 12,
                  height: 180,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade200.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
            // Bottom rim
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 150,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.brown.shade800,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                  border: Border.all(color: Colors.brown.shade900, width: 3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedStick() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: 170,
          child: Transform.translate(
            offset: Offset(0, 120 * _animation.value),
            child: _buildDrawnStick(_currentResult!),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedResultText(AppLocalizations l10n) {
    return Opacity(
      opacity: _animation.value.clamp(0.0, 1.0),
      child: Text(
        _getStickResultText(l10n),
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: goldColor,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDrawnStick(FortuneStickResult result) {
    double height;
    switch (result) {
      case FortuneStickResult.short:
        height = 150;
        break;
      case FortuneStickResult.medium:
        height = 180;
        break;
      case FortuneStickResult.long:
        height = 210;
        break;
    }

    return Container(
      width: 20,
      height: height,
      decoration: BoxDecoration(
        color: Colors.amber.shade200,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.amber.shade400, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }

  String _getStickResultText(AppLocalizations l10n) {
    switch (_currentResult) {
      case FortuneStickResult.short:
        return l10n.fortuneStickShort;
      case FortuneStickResult.medium:
        return l10n.fortuneStickMedium;
      case FortuneStickResult.long:
        return l10n.fortuneStickLong;
      default:
        return "";
    }
  }
}
