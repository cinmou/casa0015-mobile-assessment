import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:the_oracle/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:the_oracle/providers/choice_provider.dart';

class DiceRollScreen extends StatefulWidget {
  const DiceRollScreen({super.key});

  @override
  State<DiceRollScreen> createState() => _DiceRollScreenState();
}

class _DiceRollScreenState extends State<DiceRollScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotXAnimation;
  late Animation<double> _rotYAnimation;

  final double diceSize = 130.0;

  double _currentRotX = 0.0;
  double _currentRotY = 0.0;
  double _lastVibrateAngle = 0.0;

  // Shake state
  bool _isShakeEnabled = false;
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  DateTime _lastShakeTime = DateTime.now();
  
  // Result state
  int _currentFace = 1;
  bool _hasResult = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _rotXAnimation = Tween<double>(begin: 0, end: 0).animate(_controller);
    _rotYAnimation = Tween<double>(begin: 0, end: 0).animate(_controller);

    _controller.addListener(() {
      double currentAngleSum = _rotXAnimation.value.abs() + _rotYAnimation.value.abs();
      if ((currentAngleSum - _lastVibrateAngle).abs() > pi / 3) {
        HapticFeedback.selectionClick();
        _lastVibrateAngle = currentAngleSum;
      }
    });

    _accelerometerSubscription = userAccelerometerEventStream().listen((UserAccelerometerEvent event) {
      if (!_isShakeEnabled) return;
      double acceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (acceleration > 15.0) {
        final now = DateTime.now();
        if (now.difference(_lastShakeTime).inMilliseconds > 400) {
          _rollDice();
          _lastShakeTime = now;
        }
      }
    });
  }

  void _rollDice() {
    setState(() {
      _hasResult = false;
    });

    if (_controller.isAnimating) {
      _currentRotX = _rotXAnimation.value;
      _currentRotY = _rotYAnimation.value;
      _controller.stop();
    }

    _currentFace = Random().nextInt(6) + 1;
    double targetRotX = 0;
    double targetRotY = 0;

    switch (_currentFace) {
      case 1: targetRotX = 0; targetRotY = 0; break;
      case 6: targetRotX = 0; targetRotY = pi; break;
      case 2: targetRotX = 0; targetRotY = pi / 2; break;
      case 5: targetRotX = 0; targetRotY = -pi / 2; break;
      case 3: targetRotX = pi / 2; targetRotY = 0; break;
      case 4: targetRotX = -pi / 2; targetRotY = 0; break;
    }

    targetRotX += (Random().nextBool() ? 1 : -1) * (2 * pi * 2);
    targetRotY += (Random().nextBool() ? 1 : -1) * (2 * pi * 2);

    _rotXAnimation = Tween<double>(
      begin: _currentRotX,
      end: targetRotX,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _rotYAnimation = Tween<double>(
      begin: _currentRotY,
      end: targetRotY,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _lastVibrateAngle = _currentRotX.abs() + _currentRotY.abs();
    HapticFeedback.mediumImpact();

    _controller.forward(from: 0).then((_) {
      _currentRotX = _rotXAnimation.value % (2 * pi);
      _currentRotY = _rotYAnimation.value % (2 * pi);
      HapticFeedback.heavyImpact();
      setState(() {
        _hasResult = true;
      });
    });
  }

  void _showSaveDialog() {
    final l10n = AppLocalizations.of(context)!;
    final questionController = TextEditingController();
    final solutionController = TextEditingController(); // Controller for the solution
    String selectedMood = '🤔'; 

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
                    Text(l10n.saveToMapResult(_currentFace.toString())), 
                    const SizedBox(height: 16),
                    Text(l10n.saveToMapQuestionHint, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    TextField(
                      controller: questionController,
                      decoration: const InputDecoration(
                        hintText: "e.g., Should I apply for that job?",
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
                        hintText: "e.g., I will go for it!",
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
                      tool: 'Dice Roll',
                      result: _currentFace.toString(),
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
        title: Text(l10n.quickPickDiceRoll),
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
        onTap: _rollDice,
        child: SizedBox.expand(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return IgnorePointer(
                  child: _build3DDice(),
                );
              },
            ),
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

  Widget _build3DDice() {
    double halfSize = diceSize / 2;

    Matrix4 rotationMatrix = Matrix4.identity()
      ..setEntry(3, 2, 0.002)
      ..rotateX(_rotXAnimation.value)
      ..rotateY(_rotYAnimation.value);

    List<_DiceFaceData> faces = [
      _DiceFaceData(1, 0, 0, -halfSize, Matrix4.identity()..translate(0.0, 0.0, -halfSize)),
      _DiceFaceData(6, 0, 0, halfSize, Matrix4.identity()..translate(0.0, 0.0, halfSize)..rotateY(pi)),
      _DiceFaceData(2, halfSize, 0, 0, Matrix4.identity()..translate(halfSize, 0.0, 0.0)..rotateY(pi / 2)),
      _DiceFaceData(5, -halfSize, 0, 0, Matrix4.identity()..translate(-halfSize, 0.0, 0.0)..rotateY(-pi / 2)),
      _DiceFaceData(3, 0, -halfSize, 0, Matrix4.identity()..translate(0.0, -halfSize, 0.0)..rotateX(-pi / 2)),
      _DiceFaceData(4, 0, halfSize, 0, Matrix4.identity()..translate(0.0, halfSize, 0.0)..rotateX(pi / 2)),
    ];

    for (var face in faces) {
      var m = rotationMatrix.storage;
      face.transformedZ = m[2] * face.cx + m[6] * face.cy + m[10] * face.cz + m[14];
    }

    faces.sort((a, b) => b.transformedZ.compareTo(a.transformedZ));

    return Transform(
      alignment: Alignment.center,
      transform: rotationMatrix,
      child: Stack(
        alignment: Alignment.center,
        children: faces.map((face) {
          return Transform(
            alignment: Alignment.center,
            transform: face.transform,
            child: _buildFaceWidget(face.number),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFaceWidget(int number) {
    return Container(
      width: diceSize,
      height: diceSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 1)
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: _buildDots(number),
    );
  }

  Widget _buildDots(int number) {
    Widget dot = Container(
      width: diceSize * 0.18,
      height: diceSize * 0.18,
      decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
    );

    switch (number) {
      case 1:
        return Center(child: Container(width: diceSize * 0.3, height: diceSize * 0.3, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)));
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Align(alignment: Alignment.topRight, child: dot), Align(alignment: Alignment.bottomLeft, child: dot)],
        );
      case 3:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Align(alignment: Alignment.topRight, child: dot), Center(child: dot), Align(alignment: Alignment.bottomLeft, child: dot)],
        );
      case 4:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [dot, dot]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [dot, dot]),
          ],
        );
      case 5:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [dot, dot]),
            Center(child: dot),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [dot, dot]),
          ],
        );
      case 6:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [dot, dot]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [dot, dot]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [dot, dot]),
          ],
        );
      default:
        return const SizedBox();
    }
  }
}

class _DiceFaceData {
  final int number;
  final double cx, cy, cz;
  final Matrix4 transform;
  double transformedZ = 0;

  _DiceFaceData(this.number, this.cx, this.cy, this.cz, this.transform);
}
