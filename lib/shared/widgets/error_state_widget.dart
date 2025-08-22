import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Widget para estados de erro com ilustrações customizadas
class ErrorStateWidget extends StatefulWidget {
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final ErrorType errorType;

  const ErrorStateWidget({
    super.key,
    this.title = 'Ops! Algo deu errado',
    this.message = 'Ocorreu um erro inesperado. Tente novamente.',
    this.actionText = 'Tentar novamente',
    this.onAction,
    this.errorType = ErrorType.general,
  });

  @override
  State<ErrorStateWidget> createState() => _ErrorStateWidgetState();
}

class _ErrorStateWidgetState extends State<ErrorStateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
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
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ilustração do erro
                  _buildErrorIllustration(),

                  const SizedBox(height: 24),

                  // Título
                  Text(
                    widget.title,
                    style: AppTypography.headline2.copyWith(
                      color: AppColors.textOnDark,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // Mensagem
                  Text(
                    widget.message,
                    style: AppTypography.body1.copyWith(
                      color: AppColors.textSecondaryOnDark,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  if (widget.onAction != null) ...[
                    const SizedBox(height: 32),
                    _buildActionButton(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorIllustration() {
    switch (widget.errorType) {
      case ErrorType.network:
        return _NetworkErrorIllustration();
      case ErrorType.notFound:
        return _NotFoundErrorIllustration();
      case ErrorType.server:
        return _ServerErrorIllustration();
      case ErrorType.general:
        return _GeneralErrorIllustration();
    }
  }

  Widget _buildActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha:0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: widget.onAction,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          widget.actionText!,
          style: AppTypography.button.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Tipos de erro para diferentes ilustrações
enum ErrorType {
  general,
  network,
  notFound,
  server,
}

/// Ilustração para erro geral
class _GeneralErrorIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha:0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.error_outline,
        size: 60,
        color: AppColors.error,
      ),
    );
  }
}

/// Ilustração para erro de rede
class _NetworkErrorIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha:0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.wifi_off,
        size: 60,
        color: AppColors.warning,
      ),
    );
  }
}

/// Ilustração para erro 404 - não encontrado
class _NotFoundErrorIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha:0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.search_off,
        size: 60,
        color: AppColors.info,
      ),
    );
  }
}

/// Ilustração para erro de servidor
class _ServerErrorIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha:0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.cloud_off,
        size: 60,
        color: AppColors.error,
      ),
    );
  }
}