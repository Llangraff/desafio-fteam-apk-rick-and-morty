import 'package:flutter/foundation.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../domain/usecases/get_character_by_id_usecase.dart';
import 'character_detail_state.dart';

/// ViewModel para gerenciar o estado dos detalhes de um personagem
/// 
/// Implementa o padrão MVVM usando ChangeNotifier do Provider
class CharacterDetailViewModel extends ChangeNotifier {
  final GetCharacterByIdUseCase _getCharacterByIdUseCase;

  CharacterDetailState _state = CharacterDetailInitial();
  CharacterDetailState get state => _state;

  int? _currentCharacterId;
  int? get currentCharacterId => _currentCharacterId;

  CharacterDetailViewModel(this._getCharacterByIdUseCase);

  /// Carrega os detalhes de um personagem por ID
  Future<void> loadCharacter(int id) async {
    if (_state is CharacterDetailLoading && _currentCharacterId == id) {
      return; // Evita requisições duplicadas
    }

    _currentCharacterId = id;
    _updateState(CharacterDetailLoading());

    try {
      final character = await _getCharacterByIdUseCase.call(id);
      _updateState(CharacterDetailLoaded(character));
    } catch (e) {
      _updateState(_mapExceptionToErrorState(e));
    }
  }

  /// Recarrega o personagem atual
  Future<void> reload() async {
    if (_currentCharacterId != null) {
      await loadCharacter(_currentCharacterId!);
    }
  }

  /// Tenta novamente após um erro
  Future<void> retry() async {
    if (_state is CharacterDetailError && _currentCharacterId != null) {
      await loadCharacter(_currentCharacterId!);
    }
  }

  /// Limpa o estado atual
  void clear() {
    _currentCharacterId = null;
    _updateState(CharacterDetailInitial());
  }

  /// Atualiza o estado e notifica os listeners
  void _updateState(CharacterDetailState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Mapeia exceções para estados de erro apropriados
  CharacterDetailError _mapExceptionToErrorState(Object exception) {
    if (exception is NetworkException) {
      return CharacterDetailError(
        message: _getNetworkErrorMessage(exception),
        isRetryable: true,
      );
    }

    if (exception is ArgumentError) {
      return CharacterDetailError(
        message: 'ID do personagem inválido.',
        isRetryable: false,
      );
    }

    return CharacterDetailError(
      message: 'Ocorreu um erro inesperado. Tente novamente.',
      isRetryable: true,
    );
  }

  /// Obtém mensagens amigáveis para erros de rede
  String _getNetworkErrorMessage(NetworkException exception) {
    if (exception is NoConnectionException) {
      return 'Sem conexão com a internet. Verifique sua conexão e tente novamente.';
    }
    
    if (exception is TimeoutException) {
      return 'A conexão está muito lenta. Tente novamente.';
    }
    
    if (exception is ServerException) {
      return 'Erro no servidor. Tente novamente mais tarde.';
    }
    
    if (exception is ClientException) {
      if (exception.statusCode == 404) {
        return 'Personagem não encontrado.';
      }
      return 'Erro na requisição. Tente novamente.';
    }

    return exception.message;
  }

  /// Obtém o tipo de erro com base na mensagem de exceção
  ///
  /// Move a lógica que estava na View para o ViewModel seguindo MVVM
  ErrorType getErrorType(String? errorMessage) {
    if (errorMessage == null) return ErrorType.general;
    
    final lowerMessage = errorMessage.toLowerCase();
    
    if (lowerMessage.contains('network') ||
        lowerMessage.contains('connection') ||
        lowerMessage.contains('timeout') ||
        lowerMessage.contains('internet') ||
        lowerMessage.contains('conexão') ||
        lowerMessage.contains('rede')) {
      return ErrorType.network;
    }
    
    if (lowerMessage.contains('not found') ||
        lowerMessage.contains('404') ||
        lowerMessage.contains('não encontrado')) {
      return ErrorType.notFound;
    }
    
    if (lowerMessage.contains('server') ||
        lowerMessage.contains('500') ||
        lowerMessage.contains('503') ||
        lowerMessage.contains('servidor')) {
      return ErrorType.server;
    }
    
    return ErrorType.general;
  }

}