import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Tema principal da aplicação Rick and Morty
///
/// Tema "Espaço Sideral" - Escuro, elegante e com excelente legibilidade
/// Otimizado para acessibilidade WCAG AA e experiência premium
class AppTheme {
  /// Tema escuro "Espaço Sideral" da aplicação
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // === CORES PRINCIPAIS ===
      primarySwatch: AppColors.primarySwatch,
      primaryColor: AppColors.primary,
      
      // ColorScheme otimizado para tema escuro
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.primary,          // Verde Portal Gun
        onPrimary: Colors.black,             // Texto sobre primary (preto para contraste)
        secondary: AppColors.secondary,      // Roxo suave
        onSecondary: Colors.white,           // Texto sobre secondary
        tertiary: AppColors.info,            // Azul informativo
        onTertiary: Colors.white,
        error: AppColors.error,              // Vermelho vibrante
        onError: Colors.white,
        surface: AppColors.surface,          // Azul-acinzentado escuro
        onSurface: AppColors.textPrimary,    // Branco puro
        surfaceVariant: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.textSecondary,
        background: AppColors.background,    // Azul espacial profundo
        onBackground: AppColors.textPrimary, // Branco puro
        outline: AppColors.border,           // Bordas sutis
        outlineVariant: AppColors.divider,
      ),
      
      // === BACKGROUND ===
      scaffoldBackgroundColor: AppColors.background,
      
      // === APPBAR ===
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background, // Fundo consistente
        foregroundColor: AppColors.textPrimary,
        elevation: 0, // Flat design moderno
        shadowColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: AppTypography.appBarTitle,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        actionsIconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      
      // === CARDS ===
      cardTheme: const CardThemeData(
        color: AppColors.surface,            // Azul-acinzentado escuro
        elevation: 4,                        // Elevação sutil
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)), // Mais arredondado
        ),
        margin: EdgeInsets.all(8),
      ),
      // === BOTÕES ===
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,    // Verde Portal Gun
          foregroundColor: Colors.black,         // Preto para contraste no verde
          textStyle: AppTypography.button,
          elevation: 2,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Mais arredondado
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.button,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.button,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        elevation: 6,
        shape: CircleBorder(),
      ),
      
      // === INPUT FIELDS ===
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        labelStyle: AppTypography.inputText.copyWith(color: AppColors.textSecondary),
        hintStyle: AppTypography.inputHint,
        
        // Bordas arredondadas e consistentes
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderFocus, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        
        // Ícones com cor apropriada
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
      ),
      
      // === TIPOGRAFIA ===
      textTheme: const TextTheme(
        // Display styles
        displayLarge: AppTypography.headline1,
        displayMedium: AppTypography.headline2,
        displaySmall: AppTypography.subtitle1,
        
        // Headline styles
        headlineLarge: AppTypography.headline1,
        headlineMedium: AppTypography.headline2,
        headlineSmall: AppTypography.subtitle1,
        
        // Title styles
        titleLarge: AppTypography.subtitle1,
        titleMedium: AppTypography.subtitle2,
        titleSmall: AppTypography.body1,
        
        // Body styles
        bodyLarge: AppTypography.body1,
        bodyMedium: AppTypography.body2,
        bodySmall: AppTypography.caption,
        
        // Label styles
        labelLarge: AppTypography.button,
        labelMedium: AppTypography.badge,
        labelSmall: AppTypography.overline,
      ),
      
      // === DIVISORES ===
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 16,
      ),
      
      // === BOTTOM NAVIGATION ===
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // === PROGRESS INDICATORS ===
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.border,
        circularTrackColor: AppColors.border,
      ),
      
      // === SNACK BAR ===
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: AppTypography.body2,
        actionTextColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      
      // === CHIPS ===
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        labelStyle: AppTypography.badge,
        secondaryLabelStyle: AppTypography.badge,
        brightness: Brightness.dark,
        elevation: 2,
        pressElevation: 4,
      ),
    );
  }
  
  /// Getter para manter compatibilidade com código existente
  static ThemeData get lightTheme => darkTheme;

  // Construtor privado para evitar instanciação
  AppTheme._();
}