import 'package:flutter/material.dart';

class SimpleProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final Color filledColor;
  final Color emptyColor;
  final bool showPercentage;

  const SimpleProgressBar({
    super.key,
    required this.progress,
    this.height = 12,
    required this.filledColor,
    required this.emptyColor,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        color: emptyColor,
      ),
      child: Stack(
        children: [
          // Parte preenchida
          FractionallySizedBox(
            widthFactor: clampedProgress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height / 2),
                color: filledColor,
              ),
            ),
          ),
          
          // Texto da porcentagem
          if (showPercentage)
            Center(
              child: Text(
                '$percentage%',
                style: TextStyle(
                  color: _getTextColor(clampedProgress, filledColor, emptyColor),
                  fontSize: height * 0.7,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: const Offset(0.5, 0.5),
                      blurRadius: 1,
                      color: _getShadowColor(clampedProgress, filledColor, emptyColor),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getTextColor(double progress, Color filledColor, Color emptyColor) {
    // Se a barra está mais de 50% preenchida, usar cor que contrasta com a parte preenchida
    if (progress > 0.5) {
      return _getContrastColor(filledColor);
    } else {
      // Se está menos de 50%, usar cor que contrasta com a parte vazia
      return _getContrastColor(emptyColor);
    }
  }

  Color _getShadowColor(double progress, Color filledColor, Color emptyColor) {
    final textColor = _getTextColor(progress, filledColor, emptyColor);
    return textColor == Colors.white ? Colors.black26 : Colors.white24;
  }

  Color _getContrastColor(Color backgroundColor) {
    // Calcular a luminância da cor de fundo
    final luminance = backgroundColor.computeLuminance();
    
    // Se o fundo é claro, usar texto escuro; se escuro, usar texto claro
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}