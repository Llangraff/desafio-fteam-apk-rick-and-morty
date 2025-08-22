import 'package:flutter/material.dart';

/// Cores do design system da aplicação Rick and Morty
/// 
/// Define a paleta de cores consistente para toda a aplicação
class AppColors {
  // Cores principais - Paleta Espacial Rick & Morty
  static const Color primary = Color(0xFF1A0B3D); // Roxo espacial profundo
  static const Color secondary = Color(0xFF00FF88); // Verde neon Portal Gun
  
  // Cores espaciais complementares
  static const Color cosmic = Color(0xFF2D1B69); // Roxo cósmico
  static const Color nebula = Color(0xFF0F3460); // Azul nebulosa
  static const Color starlight = Color(0xFF00E5FF); // Azul ciano estelar
  static const Color plasma = Color(0xFF39FF14); // Verde plasma
  
  // Cores de estado - Temática espacial
  static const Color success = Color(0xFF00FF88); // Verde Portal Gun
  static const Color error = Color(0xFFFF1744); // Vermelho laser
  static const Color warning = Color(0xFFFFD600); // Amarelo energia
  static const Color info = Color(0xFF00E5FF); // Azul holográfico
  
  // Cores de texto - Adaptadas para cards claros
  static const Color textPrimary = Color(0xFF1A1A1A); // Preto suave para cards claros
  static const Color textSecondary = Color(0xFF4A4A4A); // Cinza escuro para cards claros
  static const Color textHint = Color(0xFF757575); // Cinza médio
  static const Color textDisabled = Color(0xFF9E9E9E); // Cinza claro
  
  // Cores de texto para background espacial (quando necessário)
  static const Color textOnDark = Color.fromARGB(255, 0, 0, 0); // Branco azulado para fundos escuros
  static const Color textSecondaryOnDark = Color(0xFFB39DDB); // Roxo claro para fundos escuros
  
  // Cores de superfície - Tema espacial
  static const Color surface = Color(0xFF0D1B2A); // Azul noturno
  static const Color background = Color(0xFF0F0F23); // Quase preto espacial
  static const Color card = Color(0xFF1B263B); // Azul ardósia escuro

  // Cores de divisão e borda - Espacial
  static const Color divider = Color(0xFF415A77); // Azul metálico
  static const Color border = Color(0xFF415A77); // Azul metálico
  
  // Cores semânticas para status dos personagens
  static const Color statusAlive = success;
  static const Color statusDead = error;
  static const Color statusUnknown = Color(0xFF9E9E9E);
  
  // Cores de sobreposição
  static const Color overlay = Color(0x80000000);
  static const Color shimmer = Color(0xFFE0E0E0);
  
  /// Retorna a cor apropriada baseada no status do personagem
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return statusAlive;
      case 'dead':
        return statusDead;
      default:
        return statusUnknown;
    }
  }
  
  // Cores específicas para cards (legibilidade otimizada)
  static const Color cardLight = Color(0xFFFAFAFA); // Fundo claro para cards
  static const Color cardAccent = Color(0x1000FF88); // Verde neon 6% opacidade
  static const Color cardBorder = Color(0x3000FF88); // Verde neon 18% opacidade para bordas
  
  // Gradientes cósmicos temáticos
  static const List<Color> cosmicGradient = [
    Color(0xFF1A0B3D), // Roxo profundo
    Color(0xFF2D1B69), // Roxo cósmico
    Color(0xFF0F3460), // Azul nebulosa
  ];
  
  static const List<Color> portalGradient = [
    Color(0xFF00FF88), // Verde Portal Gun
    Color(0xFF39FF14), // Verde plasma
    Color(0xFF00E5FF), // Azul ciano
  ];
  
  static const List<Color> nebulaGradient = [
    Color(0xFF2D1B69), // Roxo cósmico
    Color(0xFF0F3460), // Azul nebulosa
    Color(0xFF1A0B3D), // Roxo profundo
  ];
  
  // Gradiente específico para cards com boa legibilidade
  static const List<Color> cardGradient = [
    Color(0xFFFFFFFF), // Branco puro
    Color(0xFFFAFAFA), // Branco suave
    Color(0x0800FF88), // Verde neon muito sutil (3% opacidade)
  ];

  /// Material Color para uso em temas - Paleta Espacial
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF1A0B3D,
    <int, Color>{
      50: Color(0xFFE8EAF6),
      100: Color(0xFFC5CAE9),
      200: Color(0xFF9FA8DA),
      300: Color(0xFF7986CB),
      400: Color(0xFF5C6BC0),
      500: Color(0xFF1A0B3D), // Primary color
      600: Color(0xFF3F51B5),
      700: Color(0xFF303F9F),
      800: Color(0xFF283593),
      900: Color(0xFF1A237E),
    },
  );

  // Construtor privado para evitar instanciação
  AppColors._();
}