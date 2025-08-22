import 'package:flutter/material.dart';

/// Cores do design system da aplicação Rick and Morty
///
/// Nova paleta "Espaço Sideral" - focada em legibilidade e profissionalismo
/// Baseada na temática espacial com alto contraste para acessibilidade WCAG AA
class AppColors {
  // === PALETA PRINCIPAL "ESPAÇO SIDERAL" ===
  
  // Cor primária - Verde Portal Gun (destaque/accent)
  static const Color primary = Color(0xFF00F0C4); // Verde-azulado Portal Gun
  static const Color primaryVariant = Color(0xFF00D4AA); // Verde mais escuro para hover
  
  // Cor secundária - Complementar ao verde
  static const Color secondary = Color(0xFF7C4DFF); // Roxo suave para elementos secundários
  static const Color secondaryVariant = Color(0xFF651FFF); // Roxo mais intenso
  
  // === BACKGROUNDS E SUPERFÍCIES ===
  
  // Fundo principal - Azul espacial profundo
  static const Color background = Color(0xFF101423); // Azul quase preto espacial
  
  // Superfícies e cards - Azul-acinzentado para hierarquia
  static const Color surface = Color(0xFF1E233A); // Azul-acinzentado escuro
  static const Color surfaceVariant = Color(0xFF252B42); // Variação mais clara
  static const Color card = Color(0xFF1E233A); // Mesmo que surface para consistência
  
  // === CORES DE TEXTO - MÁXIMA LEGIBILIDADE ===
  
  // Texto principal - Branco puro para máximo contraste
  static const Color textPrimary = Color(0xFFFFFFFF); // Branco puro
  static const Color textSecondary = Color(0xFFA0A3B1); // Cinza claro azulado
  static const Color textTertiary = Color(0xFF6B7280); // Cinza médio
  static const Color textDisabled = Color(0xFF4B5563); // Cinza escuro
  
  // Cores de texto específicas (mantidas para compatibilidade)
  static const Color textOnDark = Color(0xFFFFFFFF); // CORRIGIDO: era preto!
  static const Color textSecondaryOnDark = Color(0xFFA0A3B1); // Consistente
  static const Color textHint = Color(0xFF6B7280); // Para hints e placeholders
  
  // === CORES DE ESTADO ===
  
  // Estados semânticos com boa visibilidade no tema escuro
  static const Color success = Color(0xFF00F0C4); // Verde Portal Gun
  static const Color error = Color(0xFFFF4757); // Vermelho vibrante mas legível
  static const Color warning = Color(0xFFFFA726); // Laranja dourado
  static const Color info = Color(0xFF42A5F5); // Azul informativo
  
  // === BORDAS E DIVISÕES ===
  
  // Divisores e bordas - Sutil mas visível
  static const Color divider = Color(0xFF374151); // Cinza azulado sutil
  static const Color border = Color(0xFF374151); // Consistente com divider
  static const Color borderFocus = Color(0xFF00F0C4); // Primary para foco
  
  // === CORES SEMÂNTICAS PARA STATUS DOS PERSONAGENS ===
  
  // Status dos personagens com cores bem definidas
  static const Color statusAlive = Color(0xFF00F0C4); // Verde Portal Gun
  static const Color statusDead = Color(0xFFFF4757); // Vermelho vibrante
  static const Color statusUnknown = Color(0xFF6B7280); // Cinza neutro
  
  // === OVERLAYS E EFEITOS ===
  
  // Sobreposições e efeitos visuais
  static const Color overlay = Color(0x80000000); // Preto 50% transparência
  static const Color overlayLight = Color(0x40000000); // Preto 25% transparência
  static const Color shimmer = Color(0xFF374151); // Cinza para shimmer no tema escuro
  static const Color shimmerHighlight = Color(0xFF4B5563); // Highlight do shimmer
  
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
  // === CORES ESPECÍFICAS PARA ELEMENTOS UI ===
  
  // Cards com melhor contraste e legibilidade
  static const Color cardBackground = Color(0xFF1E233A); // Mesmo que surface
  static const Color cardBorder = Color(0xFF374151); // Borda sutil
  static const Color cardElevated = Color(0xFF252B42); // Cards elevados
  
  // Compatibilidade com código existente (será removido gradualmente)
  static const Color cardLight = Color(0xFF1E233A); // Agora usa surface escuro
  static const Color cardAccent = Color(0x1000F0C4); // Verde Portal Gun com opacidade
  
  // === GRADIENTES SUTIS E ELEGANTES ===
  
  // Gradiente principal - Espaço sideral sutil
  static const List<Color> cosmicGradient = [
    Color(0xFF101423), // Background principal
    Color(0xFF1E233A), // Surface
    Color(0xFF252B42), // Surface variant
  ];
  
  // Gradiente para elementos de destaque
  static const List<Color> accentGradient = [
    Color(0xFF00F0C4), // Primary
    Color(0xFF00D4AA), // Primary variant
    Color(0xFF00B894), // Verde mais escuro
  ];
  
  // Gradiente sutil para backgrounds especiais
  static const List<Color> subtleGradient = [
    Color(0xFF1E233A), // Surface
    Color(0xFF252B42), // Surface variant
    Color(0xFF2A3142), // Ligeiramente mais claro
  ];
  
  // Compatibilidade com código existente (será removido gradualmente)
  static const List<Color> cardGradient = [
    Color(0xFF1E233A), // Surface escuro
    Color(0xFF252B42), // Surface variant
    Color(0xFF2A3142), // Mais claro para sutileza
  ];
  // === MATERIAL COLOR SWATCH ===
  
  /// Material Color atualizado para nova paleta "Espaço Sideral"
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF00F0C4, // Verde Portal Gun como cor base
    <int, Color>{
      50: Color(0xFFE0FDF8),  // Verde muito claro
      100: Color(0xFFB3FAF0),  // Verde claro
      200: Color(0xFF80F6E8),  // Verde médio-claro
      300: Color(0xFF4DF2DF),  // Verde médio
      400: Color(0xFF26F1D8),  // Verde médio-escuro
      500: Color(0xFF00F0C4),  // Primary color - Verde Portal Gun
      600: Color(0xFF00D4AA),  // Verde escuro
      700: Color(0xFF00B894),  // Verde mais escuro
      800: Color(0xFF009C7E),  // Verde escuro intenso
      900: Color(0xFF008068),  // Verde mais escuro
    },
  );

  // Construtor privado para evitar instanciação
  AppColors._();
}