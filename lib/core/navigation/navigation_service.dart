import 'package:flutter/material.dart';

/// Serviço centralizado para navegação seguindo princípios MVVM
/// 
/// Remove a responsabilidade de navegação das Views, permitindo que
/// ViewModels controlem o fluxo de navegação sem conhecer contexto
class NavigationService {
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  
  /// Chave global do navigator para acesso sem contexto
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  
  /// Contexto atual do navigator (null-safe)
  BuildContext? get currentContext => _navigatorKey.currentContext;
  
  /// Navega para uma rota específica
  /// 
  /// [routeName] - Nome da rota registrada
  /// [arguments] - Argumentos opcionais para a rota
  /// 
  /// Retorna Future<T?> para permitir aguardar resultado da navegação
  Future<T?> navigateTo<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) {
      throw NavigationException('Navigator não está disponível');
    }
    
    return await navigator.pushNamed<T>(routeName, arguments: arguments);
  }
  
  /// Navega para uma rota substituindo a atual
  /// 
  /// [routeName] - Nome da rota registrada
  /// [arguments] - Argumentos opcionais para a rota
  Future<T?> navigateAndReplace<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) async {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) {
      throw NavigationException('Navigator não está disponível');
    }
    
    return await navigator.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }
  
  /// Navega para uma rota removendo todas as anteriores
  /// 
  /// [routeName] - Nome da rota registrada
  /// [arguments] - Argumentos opcionais para a rota
  Future<T?> navigateAndClearStack<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) {
      throw NavigationException('Navigator não está disponível');
    }
    
    return await navigator.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
  
  /// Volta para a tela anterior
  /// 
  /// [result] - Resultado opcional para retornar à tela anterior
  void goBack<T extends Object?>([T? result]) {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) {
      throw NavigationException('Navigator não está disponível');
    }
    
    if (navigator.canPop()) {
      navigator.pop<T>(result);
    }
  }
  
  /// Verifica se é possível voltar
  bool canGoBack() {
    final navigator = _navigatorKey.currentState;
    return navigator?.canPop() ?? false;
  }
  
  /// Volta até uma rota específica
  /// 
  /// [routeName] - Nome da rota para voltar até ela
  void popUntil(String routeName) {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) {
      throw NavigationException('Navigator não está disponível');
    }
    
    navigator.popUntil(ModalRoute.withName(routeName));
  }
  
  /// Navega para personagem específico
  /// 
  /// Método de conveniência para navegação frequente no app
  Future<void> navigateToCharacterDetail(int characterId) async {
    await navigateTo('/character-detail', arguments: characterId);
  }
  
  /// Volta para a lista de personagens
  /// 
  /// Método de conveniência para navegação frequente no app
  void backToCharacterList() {
    goBack();
  }
}

/// Exceção específica para erros de navegação
class NavigationException implements Exception {
  final String message;
  
  const NavigationException(this.message);
  
  @override
  String toString() => 'NavigationException: $message';
}