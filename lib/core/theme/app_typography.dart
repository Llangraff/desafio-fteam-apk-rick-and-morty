import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Tipografia do design system da aplicação Rick and Morty
///
/// Atualizada com a nova paleta "Espaço Sideral" para máximo contraste e legibilidade
/// Todas as cores seguem padrões WCAG AA para acessibilidade
class AppTypography {
  // === CONFIGURAÇÕES BASE ===
  static const String _fontFamily = 'Roboto';
  
  // === HEADLINES - TÍTULOS PRINCIPAIS ===
  
  static const TextStyle headline1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28, // Aumentado para melhor hierarquia
    fontWeight: FontWeight.w700, // Mais bold para destaque
    color: AppColors.textPrimary, // Branco puro
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static const TextStyle headline2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22, // Ligeiramente maior
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary, // Branco puro
    letterSpacing: -0.25,
    height: 1.2,
  );
  
  // === SUBTÍTULOS ===
  
  static const TextStyle subtitle1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600, // Mais peso para melhor contraste
    color: AppColors.textPrimary, // Branco puro
    letterSpacing: 0,
    height: 1.3,
  );
  
  static const TextStyle subtitle2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary, // Branco puro
    letterSpacing: 0.1,
    height: 1.4,
  );
  
  // === CORPO DE TEXTO ===
  
  static const TextStyle body1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary, // Branco puro
    letterSpacing: 0.15,
    height: 1.5,
  );
  
  static const TextStyle body2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary, // Cinza claro para hierarquia
    letterSpacing: 0.25,
    height: 1.4,
  );
  
  // === LEGENDAS E TEXTOS PEQUENOS ===
  
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary, // Cinza claro consistente
    letterSpacing: 0.4,
    height: 1.3,
  );
  
  static const TextStyle overline = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500, // Mais peso para legibilidade
    color: AppColors.textTertiary, // Cinza médio
    letterSpacing: 1.5,
    height: 1.6,
  );
  
  // === ESTILOS ESPECÍFICOS PARA BOTÕES ===
  
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600, // Mais peso para botões
    letterSpacing: 0.5, // Reduzido para melhor legibilidade
    height: 1.4,
    color: AppColors.textPrimary, // Será sobrescrito pelo tema do botão
  );
  
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.4,
    color: AppColors.textPrimary,
  );
  
  // === ESTILOS ESPECÍFICOS DA APLICAÇÃO RICK & MORTY ===
  
  // Estilos para cards de personagens
  static const TextStyle characterName = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700, // Mais bold para destaque
    color: AppColors.textPrimary, // Branco puro
    letterSpacing: 0.1,
    height: 1.3,
  );
  
  static const TextStyle characterStatus = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600, // Mais peso para legibilidade
    letterSpacing: 0.3, // Reduzido
    height: 1.2,
    color: AppColors.textPrimary, // Será sobrescrito pela cor do status
  );
  
  static const TextStyle characterSpecies = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary, // Cinza claro consistente
    letterSpacing: 0.25,
    height: 1.4,
  );
  
  // Estilo para AppBar
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700, // Mais bold
    color: AppColors.textPrimary, // Consistente
    letterSpacing: 0,
    height: 1.2,
  );
  // === ESTILOS PARA INPUTS E FORMULÁRIOS ===
  
  static const TextStyle inputText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary, // Branco para fundos escuros
    letterSpacing: 0.15,
    height: 1.5,
  );
  
  static const TextStyle inputHint = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint, // Cinza médio consistente
    letterSpacing: 0.25,
    height: 1.4,
  );
  
  // === ESTILOS ADICIONAIS PARA MELHOR UX ===
  
  // Texto para informações importantes
  static const TextStyle important = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary, // Verde Portal Gun para destaque
    letterSpacing: 0.25,
    height: 1.4,
  );
  
  // Texto para detalhes técnicos
  static const TextStyle technical = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary, // Cinza médio
    letterSpacing: 0.2,
    height: 1.3,
  );
  
  // Texto para badges e chips
  static const TextStyle badge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
  );
  
  // Construtor privado para evitar instanciação
  AppTypography._();
}