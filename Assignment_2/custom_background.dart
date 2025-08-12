import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;

  const CustomBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2E3A59),
            Color(0xFF4A5B8C),
            Color(0xFF5B4A96),
            Color(0xFF8E4EC6),
          ],
          stops: [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: child,
    );
  }
}

class WeatherCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const WeatherCard({Key? key, required this.child, this.padding, this.margin})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
