import 'package:flutter/material.dart';

/// Tipos de notificação disponíveis
enum NotificationType {
  success,
  error,
  warning,
  info,
}

/// Dados de uma notificação
class NotificationData {
  final String message;
  final NotificationType type;
  final IconData? icon;
  final Duration duration;
  final VoidCallback? onTap;

  const NotificationData({
    required this.message,
    required this.type,
    this.icon,
    this.duration = const Duration(seconds: 3),
    this.onTap,
  });
}

/// Serviço centralizado para notificações seguindo princípios MVVM
/// 
/// Remove a responsabilidade de gerenciar SnackBars das Views,
/// permitindo que ViewModels enviem notificações sem conhecer widgets
class NotificationService {
  static final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = 
      GlobalKey<ScaffoldMessengerState>();
  
  /// Chave global do ScaffoldMessenger para acesso sem contexto
  static GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey => _scaffoldMessengerKey;
  
  /// ScaffoldMessenger atual (null-safe)
  ScaffoldMessengerState? get _currentMessenger => _scaffoldMessengerKey.currentState;
  
  /// Mostra uma notificação de sucesso
  void showSuccess(String message, {Duration? duration, VoidCallback? onTap}) {
    _showNotification(NotificationData(
      message: message,
      type: NotificationType.success,
      icon: Icons.check_circle,
      duration: duration ?? const Duration(seconds: 3),
      onTap: onTap,
    ));
  }
  
  /// Mostra uma notificação de erro
  void showError(String message, {Duration? duration, VoidCallback? onTap}) {
    _showNotification(NotificationData(
      message: message,
      type: NotificationType.error,
      icon: Icons.warning,
      duration: duration ?? const Duration(seconds: 4),
      onTap: onTap,
    ));
  }
  
  /// Mostra uma notificação de aviso
  void showWarning(String message, {Duration? duration, VoidCallback? onTap}) {
    _showNotification(NotificationData(
      message: message,
      type: NotificationType.warning,
      icon: Icons.warning_amber,
      duration: duration ?? const Duration(seconds: 3),
      onTap: onTap,
    ));
  }
  
  /// Mostra uma notificação informativa
  void showInfo(String message, {Duration? duration, VoidCallback? onTap}) {
    _showNotification(NotificationData(
      message: message,
      type: NotificationType.info,
      icon: Icons.info,
      duration: duration ?? const Duration(seconds: 3),
      onTap: onTap,
    ));
  }
  
  /// Mostra uma notificação personalizada
  void showCustom(NotificationData notification) {
    _showNotification(notification);
  }
  
  /// Implementação interna para mostrar notificação
  void _showNotification(NotificationData notification) {
    final messenger = _currentMessenger;
    if (messenger == null) {
      throw NotificationException('ScaffoldMessenger não está disponível');
    }
    
    // Remove SnackBar anterior se existir
    messenger.clearSnackBars();
    
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (notification.icon != null) ...[
            Icon(
              notification.icon,
              color: _getIconColor(notification.type),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              notification.message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: _getBackgroundColor(notification.type),
      duration: notification.duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
      action: notification.onTap != null
          ? SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: notification.onTap!,
            )
          : null,
    );
    
    messenger.showSnackBar(snackBar);
  }
  
  /// Remove todas as notificações ativas
  void clearAll() {
    _currentMessenger?.clearSnackBars();
  }
  
  /// Obtém cor de fundo baseada no tipo
  Color _getBackgroundColor(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Colors.green[700]!;
      case NotificationType.error:
        return Colors.red[700]!;
      case NotificationType.warning:
        return Colors.orange[700]!;
      case NotificationType.info:
        return Colors.blue[700]!;
    }
  }
  
  /// Obtém cor do ícone baseada no tipo
  Color _getIconColor(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Colors.green[100]!;
      case NotificationType.error:
        return Colors.red[100]!;
      case NotificationType.warning:
        return Colors.orange[100]!;
      case NotificationType.info:
        return Colors.blue[100]!;
    }
  }
}

/// Exceção específica para erros de notificação
class NotificationException implements Exception {
  final String message;
  
  const NotificationException(this.message);
  
  @override
  String toString() => 'NotificationException: $message';
}