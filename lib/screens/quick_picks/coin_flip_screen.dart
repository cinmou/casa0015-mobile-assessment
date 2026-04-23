import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CoinResult { heads, tails, edge }

class CoinFlipScreen extends StatefulWidget {
  const CoinFlipScreen({super.key});

  @override
  State<CoinFlipScreen> createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  late Animation<double> _heightAnimation;

  final double coinSize = 120.0;
  final double coinThickness = 12.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _heightAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.8,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.8,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _flipAnimation = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  void _flipCoin() {
    if (_controller.isAnimating) return;

    int randomVal = Random().nextInt(200);
    double endAngle;

    if (randomVal == 0) {
      endAngle = (pi * 10) + (pi / 2);
    } else {
      bool isHeads = Random().nextBool();
      endAngle = isHeads ? (pi * 12) : (pi * 11);
    }

    _flipAnimation =
        Tween<double>(
          begin: _flipAnimation.value % (2 * pi),
          end: endAngle,
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart),
        );

    HapticFeedback.heavyImpact();
    _controller.forward(from: 0).then((_) {
      HapticFeedback.mediumImpact();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authentic 3D Coin")),
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
    );
  }

  Widget _build3DCoin(double rotation) {
    double normAngle = rotation % (2 * pi);

    bool isBackVisible = normAngle > pi / 2 && normAngle < 3 * pi / 2;
    bool isEdgeVisible =
        (normAngle > pi * 0.2 && normAngle < pi * 0.8) ||
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

    return Stack(alignment: Alignment.center, children: stackChildren);
  }

  Widget _buildCoinFace({required bool isBack}) {
    return Container(
      width: coinSize,
      height: coinSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade200,
            Colors.amber.shade600,
            Colors.amber.shade800,
          ],
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
          colors: [
            Colors.amber.shade900,
            Colors.amber.shade700,
            Colors.amber.shade900,
          ],
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
