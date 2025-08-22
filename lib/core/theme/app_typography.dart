import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Tipografia do design system da aplicação Rick and Morty
/// 
/// Define os estilos de texto consistentes para toda a aplicação
class AppTypography {
  // Configurações base de fonte
  static const String _fontFamily = 'Roboto';
  
  // Headlines
  static const TextStyle headline1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static const TextStyle headline2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
    letterSpacing: -0.25,
    height: 1.2,
  );
  
  // Subtítulos
  static const TextStyle subtitle1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    letterSpacing: 0,
    height: 1.3,
  );
  
  static const TextStyle subtitle2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    letterSpacing: 0.1,
    height: 1.4,
  );
  
  // Corpo de texto
  static const TextStyle body1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDark,
    letterSpacing: 0.15,
    height: 1.5,
  );
  
  static const TextStyle body2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDark,
    letterSpacing: 0.25,
    height: 1.4,
  );
  
  // Legendas
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryOnDark,
    letterSpacing: 0.4,
    height: 1.3,
  );
  
  static const TextStyle overline = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryOnDark,
    letterSpacing: 1.5,
    height: 1.6,
  );
  
  // Estilos específicos para botões
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
    height: 1.4,
  );
  
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
    height: 1.4,
  );
  
  // Estilos específicos da aplicação
  static const TextStyle characterName = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
    letterSpacing: 0.1,
    height: 1.3,
  );
  
  static const TextStyle characterStatus = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.2,
  );
  
  static const TextStyle characterSpecies = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryOnDark,
    letterSpacing: 0.25,
    height: 1.4,
  );
  
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0,
    height: 1.2,
  );
  // Estilos específicos para inputs com contraste adequado
  static const TextStyle inputText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary, // Cor escura para fundos claros
    letterSpacing: 0.15,
    height: 1.5,
  );
  
  static const TextStyle inputHint = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint, // Cinza médio para hint
    letterSpacing: 0.25,
    height: 1.4,
  );
  
  // Construtor privado para evitar instanciação
  AppTypography._();
}