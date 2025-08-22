import 'package:flutter/material.dart';

/// Transições personalizadas para navegação entre telas
class CustomPageRoutes {
  
  /// Transição slide da direita para esquerda (padrão iOS)
  static PageRouteBuilder slideFromRight<T>({
    required Widget page,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  /// Transição fade com escala (moderna e elegante)
  static PageRouteBuilder fadeScale<T>({
    required Widget page,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        
        var fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        
        var scaleAnimation = Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).animate(fadeAnimation);

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Transição hero-style com fade e slight scale
  static PageRouteBuilder heroTransition<T>({
    required Widget page,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;
        
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        // Animação de slide sutil combinada com fade
        var slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.1),
          end: Offset.zero,
        ).animate(curvedAnimation);

        var fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(curvedAnimation);

        var scaleAnimation = Tween<double>(
          begin: 0.97,
          end: 1.0,
        ).animate(curvedAnimation);

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Transição com rotação sutil (para elementos especiais)
  static PageRouteBuilder rotationFade<T>({
    required Widget page,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        var rotationAnimation = Tween<double>(
          begin: 0.02, // Rotação muito sutil
          end: 0.0,
        ).animate(curvedAnimation);

        var fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(curvedAnimation);

        var scaleAnimation = Tween<double>(
          begin: 0.9,
          end: 1.0,
        ).animate(curvedAnimation);

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Transform.rotate(
              angle: rotationAnimation.value,
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Transição personalizada para detalhes de personagem
  static PageRouteBuilder characterDetailTransition<T>({
    required Widget page,
    RouteSettings? settings,
  }) {
    return heroTransition<T>(
      page: page,
      settings: settings,
      duration: const Duration(milliseconds: 400),
    );
  }
}
