import '../../domain/entities/character.dart';

/// Estados possíveis para os detalhes de um personagem
abstract class CharacterDetailState {}

/// Estado inicial - sem dados carregados
class CharacterDetailInitial extends CharacterDetailState {}

/// Estado de carregamento
class CharacterDetailLoading extends CharacterDetailState {}

/// Estado de sucesso com dados do personagem
class CharacterDetailLoaded extends CharacterDetailState {
  final Character character;

  CharacterDetailLoaded(this.character);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CharacterDetailLoaded && other.character == character;
  }

  @override
  int get hashCode => character.hashCode;
}

/// Estado de erro
class CharacterDetailError extends CharacterDetailState {
  final String message;
  final bool isRetryable;

  CharacterDetailError({
    required this.message,
    this.isRetryable = true,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CharacterDetailError &&
        other.message == message &&
        other.isRetryable == isRetryable;
  }

  @override
  int get hashCode {
    return Object.hash(message, isRetryable);
  }
}