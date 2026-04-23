import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/tarot_card.dart';
import '../services/tarot_service.dart';

class TarotCardWidget extends StatefulWidget {
  final TarotCard card;
  final bool isFaceUp;
  final bool isReversed;
  final bool animateOnTap;
  final VoidCallback? onFlip;

  final bool allowReversed;
  final bool enableTilt;

  const TarotCardWidget({
    super.key,
    required this.card,
    this.isFaceUp = false,
    this.isReversed = false,
    this.animateOnTap = true,
    this.onFlip,
    this.allowReversed = true,
    this.enableTilt = true,
  });

  @override
  State<TarotCardWidget> createState() => _TarotCardWidgetState();
}

class _TarotCardWidgetState extends State<TarotCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _reverseController;
  late AnimationController _tiltController;

  double _rawTiltX = 0.0;
  double _rawTiltY = 0.0;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: widget.isFaceUp ? 1.0 : 0.0,
    );

    _reverseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: (widget.isReversed && widget.allowReversed) ? 1.0 : 0.0,
    );

    _tiltController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void didUpdateWidget(TarotCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isFaceUp != oldWidget.isFaceUp) {
      widget.isFaceUp ? _flipController.forward() : _flipController.reverse();
    }

    if (widget.isReversed != oldWidget.isReversed && widget.allowReversed) {
      if (widget.isReversed) {
        _reverseController.forward();
      } else {
        _reverseController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    _reverseController.dispose();
    _tiltController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.animateOnTap || _flipController.isAnimating) return;

    HapticFeedback.mediumImpact();

    if (_flipController.value >= 0.5) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }

    if (widget.onFlip != null) widget.onFlip!();
  }

  void _onPanDown(DragDownDetails details) {
    if (!widget.enableTilt) return;
    _updateTiltValues(details.localPosition);
    _tiltController.forward();
    setState(() => _isPressed = true);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.enableTilt) return;
    _updateTiltValues(details.localPosition);
  }

  void _updateTiltValues(Offset localPosition) {
    const double width = 204.0;
    const double height = 360.0;

    setState(() {
      double dx = (localPosition.dx - (width / 2)) / (width / 2);
      double dy = (localPosition.dy - (height / 2)) / (height / 2);

      _rawTiltX = dy.clamp(-1.2, 1.2) * 0.22;
      _rawTiltY = -dx.clamp(-1.2, 1.2) * 0.22;
    });
  }

  void _deactivate() {
    if (!_isPressed) return;
    _tiltController.reverse().then((_) {
      if (mounted && !_isPressed) {
        setState(() {
          _rawTiltX = 0.0;
          _rawTiltY = 0.0;
        });
      }
    });
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
      onPanEnd: (_) => _deactivate(),
      onPanCancel: () => _deactivate(),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _flipController,
          _reverseController,
          _tiltController,
        ]),
        builder: (context, child) {
          double flipRotation = _flipController.value * pi;

          double reverseVal = Curves.easeInOutBack.transform(
            _reverseController.value,
          );
          double zRotation = reverseVal * pi;

          bool showFront = _flipController.value >= 0.5;

          return TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(
              begin: Offset.zero,
              end: Offset(_rawTiltX, _rawTiltY),
            ),
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            builder: (context, smoothedTilt, child) {
              double finalTiltX = smoothedTilt.dx * _tiltController.value;
              double finalTiltY = smoothedTilt.dy * _tiltController.value;

              double flipScale =
                  1.0 + (sin(_flipController.value * pi).abs() * 0.1);
              double pressScale = 1.0 + (0.05 * _tiltController.value);
              double finalScale = flipScale * pressScale;

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(finalTiltX)
                  ..rotateY(finalTiltY + flipRotation)
                  ..rotateZ(zRotation)
                  ..scale(finalScale),
                child: _buildCardContent(showFront),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCardContent(bool showFront) {
    if (showFront) {
      // The front face needs a second Y rotation so the artwork is not mirrored.
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: _buildFront(),
      );
    } else {
      return _buildBack();
    }
  }

  Widget _buildFront() {
    return _buildCardFrame(
      isFront: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Image.asset(widget.card.fullPath, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildBack() {
    return _buildCardFrame(
      isFront: false,
      child: Image.asset(TarotService.cardBackPath, fit: BoxFit.cover),
    );
  }

  Widget _buildCardFrame({required Widget child, bool isFront = false}) {
    return Container(
      width: 204,
      height: 360,
      decoration: BoxDecoration(
        color: isFront ? Colors.white : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.black87.withOpacity(0.6), width: 1.5),
        boxShadow: isFront ? [] : [],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(6), child: child),
    );
  }
}
