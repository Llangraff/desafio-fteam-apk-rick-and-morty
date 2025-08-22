import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../core/network/api_client.dart';
import '../core/navigation/navigation_service.dart';
import '../core/services/notification_service.dart';
import '../features/characters/data/sources/character_remote_data_source.dart';
import '../features/characters/data/sources/character_remote_data_source_impl.dart';
import '../features/characters/data/repositories/character_repository_impl.dart';
import '../features/characters/domain/repositories/character_repository.dart';
import '../features/characters/domain/usecases/get_characters_page_usecase.dart';
import '../features/characters/domain/usecases/get_character_by_id_usecase.dart';
import '../features/characters/domain/usecases/get_random_character_usecase.dart';
import '../features/characters/presentation/viewmodels/character_list_viewmodel.dart';
import '../features/characters/presentation/viewmodels/character_detail_viewmodel.dart';

/// Configuração da injeção de dependências usando Provider
/// 
/// Define todos os providers necessários para a aplicação seguindo
/// a arquitetura MVVM com injeção de dependências
class DependencyInjection {
  /// Lista de providers para serem registrados na aplicação
  static List<SingleChildWidget> get providers {
    return [
      // Core Services
      Provider<ApiClient>(
        create: (_) => ApiClient(),
      ),

      Provider<NavigationService>(
        create: (_) => NavigationService(),
      ),

      Provider<NotificationService>(
        create: (_) => NotificationService(),
      ),

      // Data Sources
      ProxyProvider<ApiClient, CharacterRemoteDataSource>(
        update: (_, apiClient, __) => CharacterRemoteDataSourceImpl(apiClient),
      ),

      // Repositories
      ProxyProvider<CharacterRemoteDataSource, CharacterRepository>(
        update: (_, remoteDataSource, __) => 
            CharacterRepositoryImpl(remoteDataSource),
      ),

      // Use Cases
      ProxyProvider<CharacterRepository, GetCharactersPageUseCase>(
        update: (_, repository, __) => GetCharactersPageUseCase(repository),
      ),

      ProxyProvider<CharacterRepository, GetCharacterByIdUseCase>(
        update: (_, repository, __) => GetCharacterByIdUseCase(repository),
      ),

      ProxyProvider<CharacterRepository, GetRandomCharacterUseCase>(
        update: (_, repository, __) => GetRandomCharacterUseCase(repository),
      ),

      // ViewModels
      ChangeNotifierProxyProvider2<GetCharactersPageUseCase, GetRandomCharacterUseCase, CharacterListViewModel>(
        create: (context) => CharacterListViewModel(
          Provider.of<GetCharactersPageUseCase>(context, listen: false),
          Provider.of<GetRandomCharacterUseCase>(context, listen: false),
        ),
        update: (_, useCase1, useCase2, previous) =>
            previous ?? CharacterListViewModel(useCase1, useCase2),
      ),

      ChangeNotifierProxyProvider<GetCharacterByIdUseCase, CharacterDetailViewModel>(
        create: (context) => CharacterDetailViewModel(
          Provider.of<GetCharacterByIdUseCase>(context, listen: false),
        ),
        update: (_, useCase, previous) => 
            previous ?? CharacterDetailViewModel(useCase),
      ),
    ];
  }

  /// Disposa recursos quando a aplicação é finalizada
  static void dispose() {
    // Aqui podemos adicionar limpeza de recursos se necessário
    // Por exemplo, fechar conexões de rede, cancelar timers, etc.
  }
}