import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Widget de splash screen personalizada para o app Rick and Morty
class SplashScreenWidget extends StatefulWidget {
  final VoidCallback? onAnimationComplete;

  const SplashScreenWidget({
    super.key,
    this.onAnimationComplete,
  });

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _backgroundOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Animação de escala do logo
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    // Animação de opacidade do logo
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    ));

    // Animação de opacidade do texto
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
    ));

    // Animação de opacidade do background
    _backgroundOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
    ));

    // Iniciar animação
    _animationController.forward();

    // Callback quando a animação terminar
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha:_backgroundOpacityAnimation.value),
                AppColors.secondary.withValues(alpha:_backgroundOpacityAnimation.value),
                Colors.black.withValues(alpha:_backgroundOpacityAnimation.value * 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Partículas de fundo animadas
                ..._buildAnimatedParticles(),

                // Conteúdo principal
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo animado
                      Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: FadeTransition(
                          opacity: _logoOpacityAnimation,
                          child: _buildRickMortyLogo(),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Texto animado
                      FadeTransition(
                        opacity: _textOpacityAnimation,
                        child: _buildAppText(),
                      ),

                      const SizedBox(height: 60),

                      // Indicador de progresso
                      FadeTransition(
                        opacity: _textOpacityAnimation,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRickMortyLogo() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white.withValues(alpha:0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha:0.5),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'R&M',
          style: AppTypography.headline1.copyWith(
            color: AppColors.primary,
            fontSize: 80,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.white.withValues(alpha:0.8),
                blurRadius: 10,
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppText() {
    return Column(
      children: [
        Text(
          'Rick and Morty',
          style: AppTypography.headline2.copyWith(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: AppColors.primary.withValues(alpha:0.5),
                blurRadius: 10,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Personagens',
          style: AppTypography.subtitle1.copyWith(
            color: Colors.white.withValues(alpha:0.9),
            fontSize: 18,
            shadows: [
              Shadow(
                color: AppColors.secondary.withValues(alpha:0.5),
                blurRadius: 8,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAnimatedParticles() {
    return List.generate(20, (index) {
      final delay = index * 0.1;
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(delay.clamp(0.0, 1.0), (delay + 0.3).clamp(0.0, 1.0),
            curve: Curves.easeOut),
      ));

      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Positioned(
            left: MediaQuery.of(context).size.width * (0.1 + (index * 0.04)),
            top: MediaQuery.of(context).size.height * (0.2 + (index * 0.03)),
            child: Opacity(
              opacity: animation.value,
              child: Container(
                width: 4 + (index % 3) * 2.0,
                height: 4 + (index % 3) * 2.0,
                decoration: BoxDecoration(
                  color: [AppColors.primary, AppColors.secondary, Colors.white][index % 3]
                      .withValues(alpha:0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        },
      );
    });
  }
}