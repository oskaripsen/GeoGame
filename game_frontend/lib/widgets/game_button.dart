import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GameButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;
  final bool showGlow;
  final double width;
  
  const GameButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.showGlow = false,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  _GameButtonState createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.isPrimary 
                ? AppTheme.primaryMint 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: widget.isPrimary 
                ? null 
                : Border.all(color: AppTheme.primaryMint, width: 2),
            boxShadow: widget.showGlow && widget.isPrimary
                ? [
                    BoxShadow(
                      color: AppTheme.primaryMint.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ]
                : widget.isPrimary
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryDarkMint.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        )
                      ]
                    : null,
          ),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: widget.isPrimary 
                      ? Colors.white 
                      : AppTheme.primaryMint,
                  size: 20,
                ),
                SizedBox(width: 8),
              ],
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.isPrimary 
                      ? Colors.white 
                      : AppTheme.primaryMint,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
