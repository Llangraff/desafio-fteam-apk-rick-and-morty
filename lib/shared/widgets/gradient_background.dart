import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Widget para backgrounds com gradientes elegantes
class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final bool animate;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = colors ?? _getDefaultGradient();

    if (animate) {
      return AnimatedGradientBackground(
        colors: gradientColors,
        begin: begin,
        end: end,
        child: child,
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: gradientColors,
        ),
      ),
      child: child,
    );
  }

  List<Color> _getDefaultGradient() {
    return AppColors.cosmicGradient; // Agora usa gradiente mais sutil da nova paleta
  }
}

/// Background com gradiente animado
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    required this.colors,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: widget.begin,
              end: widget.end,
              colors: widget.colors.map((color) {
                return Color.lerp(
                  color,
                  color.withValues(alpha:0.7),
                  _animation.value,
                )!;
              }).toList(),
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Background Rick and Morty temático espacial
/// Background Rick and Morty "Espaço Sideral" - Simplificado e elegante
class RickMortyBackground extends StatelessWidget {
  final Widget child;
  final bool useAppBar;

  const RickMortyBackground({
    super.key,
    required this.child,
    this.useAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Fundo sólido da nova paleta - mais limpo e profissional
      color: AppColors.background,
      child: child,
    );
  }
}
/// Background para cards com efeito glassmorphism espacial
class GlassmorphismCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double opacity;
  final double blur;

  const GlassmorphismCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.opacity = 0.1,
    this.blur = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: AppColors.surface.withValues(alpha:opacity),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha:0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha:0.2),
            blurRadius: blur,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}

/// Background com efeito de partículas espaciais
class ParticleBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final Color particleColor;

  const ParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 15,
    this.particleColor = AppColors.secondary,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.particleCount,
      (index) => AnimationController(
        duration: Duration(seconds: 2 + (index % 3)),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: Offset(
          (controller.hashCode % 100) / 100.0,
          1.2,
        ),
        end: Offset(
          (controller.hashCode % 100) / 100.0,
          -0.2,
        ),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ));
    }).toList();

    for (var controller in _controllers) {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        ...List.generate(widget.particleCount, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              final offset = _animations[index].value;
              return Positioned(
                left: offset.dx * MediaQuery.of(context).size.width,
                top: offset.dy * MediaQuery.of(context).size.height,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: widget.particleColor.withValues(alpha:0.6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.particleColor.withValues(alpha:0.3),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}

/// Background com ondas decorativas espaciais
class WaveBackground extends StatelessWidget {
  final Widget child;
  final Color waveColor;
  final double height;

  const WaveBackground({
    super.key,
    required this.child,
    this.waveColor = AppColors.secondary,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                waveColor.withValues(alpha:0.1),
                AppColors.background,
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, height),
            painter: WavePainter(color: waveColor),
          ),
        ),
        child,
      ],
    );
  }
}

/// Painter para criar ondas decorativas espaciais
class WavePainter extends CustomPainter {
  final Color color;

  WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha:0.3)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.5,
      size.width * 0.5,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.7,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}