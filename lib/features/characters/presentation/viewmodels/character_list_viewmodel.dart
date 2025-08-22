import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/network/exceptions.dart';
import '../../domain/usecases/get_characters_page_usecase.dart';
import '../../domain/usecases/get_random_character_usecase.dart';
import '../../domain/entities/character.dart';
import 'character_list_state.dart';

/// ViewModel para gerenciar o estado da lista de personagens
/// 
/// Implementa o padrão MVVM usando ChangeNotifier do Provider
class CharacterListViewModel extends ChangeNotifier {
  final GetCharactersPageUseCase _getCharactersPageUseCase;
  final GetRandomCharacterUseCase _getRandomCharacterUseCase;
  
  /// Status disponíveis na API (oficiais)
  static const List<String> _officialStatuses = [
    'alive',
    'dead',
    'unknown',
  ];
  
  /// Espécies válidas baseadas na API real da Rick and Morty
  /// Apenas valores que existem nos 826+ personagens da API
  static const List<String> _commonSpecies = [
    'human',
    'alien',
    'humanoid',
    'unknown',
    'animal',
    'robot',
  ];
  
  /// Gêneros oficiais da API
  static const List<String> _officialGenders = [
    'male',
    'female',
    'genderless',
    'unknown',
  ];

  CharacterListState _state = CharacterListInitial();
  CharacterListState get state => _state;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  
  bool _isSearching = false;
  bool get isSearching => _isSearching;

  List<String> _selectedStatusFilters = [];
  List<String> get selectedStatusFilters => _selectedStatusFilters;

  List<String> _selectedSpeciesFilters = [];
  List<String> get selectedSpeciesFilters => _selectedSpeciesFilters;

  List<String> _selectedGenderFilters = [];
  List<String> get selectedGenderFilters => _selectedGenderFilters;

  List<String> _selectedTypeFilters = [];
  List<String> get selectedTypeFilters => _selectedTypeFilters;

  List<Character> _allCharacters = [];
  
  // Cache para otimização de toLowerCase()
  final Map<String, String> _lowerCaseCache = {};
  
  // Timer para debounce da busca
  Timer? _searchTimer;
  
  // ========== SISTEMA HÍBRIDO DE FILTROS ==========
  
  // Cache inteligente para resultados filtrados (evita requisições desnecessárias)
  final Map<String, List<Character>> _filterCache = {};
  
  // Timer para debounce dos filtros (800ms)
  Timer? _filterTimer;
  
  // Controla se estamos em modo filtro (API) ou modo paginação (local)
  bool _isFilterMode = false;
  bool get isFilterMode => _isFilterMode;
  
  // Página atual no modo de filtros
  int _filterCurrentPage = 1;

  // Estado do Portal Aleatório
  bool _isPortalLoading = false;
  bool get isPortalLoading => _isPortalLoading;
  
  String? _portalError;
  String? get portalError => _portalError;

  CharacterListViewModel(
    this._getCharactersPageUseCase,
    this._getRandomCharacterUseCase,
  );

  /// Getter que retorna os personagens computados (SISTEMA HÍBRIDO)
  List<Character> get computedCharacters {
    // MODO FILTRO: Retorna dados do estado de filtros (resultados da API)
    if (_isFilterMode && _state is CharacterListFilterResults) {
      final filterState = _state as CharacterListFilterResults;
      return filterState.characters;
    }
    
    // MODO PAGINAÇÃO: Filtragem local como antes (para compatibilidade)
    List<Character> filtered = _allCharacters;

    // Filtro de busca por texto (múltiplos campos expandidos) - APENAS MODO PAGINAÇÃO
    if (_searchQuery.isNotEmpty && !_isFilterMode) {
      final query = _getCachedLowerCase(_searchQuery);
      filtered = filtered.where((character) {
        final name = _getCachedLowerCase(character.name);
        final species = _getCachedLowerCase(character.species);
        final status = _getCachedLowerCase(character.status);
        final type = _getCachedLowerCase(character.type);
        final gender = _getCachedLowerCase(character.gender);
        final originName = _getCachedLowerCase(character.origin.name);
        final locationName = _getCachedLowerCase(character.location.name);
        
        return name.contains(query) ||
               species.contains(query) ||
               status.contains(query) ||
               type.contains(query) ||
               gender.contains(query) ||
               originName.contains(query) ||
               locationName.contains(query);
      }).toList();
    }

    // Filtros por categoria - APENAS MODO PAGINAÇÃO
    if (!_isFilterMode) {
      // Filtro por status
      if (_selectedStatusFilters.isNotEmpty) {
        filtered = filtered.where((character) =>
          _selectedStatusFilters.contains(character.status.toLowerCase())
        ).toList();
      }

      // Filtro por espécie
      if (_selectedSpeciesFilters.isNotEmpty) {
        filtered = filtered.where((character) =>
          _selectedSpeciesFilters.contains(character.species.toLowerCase())
        ).toList();
      }

      // Filtro por gênero
      if (_selectedGenderFilters.isNotEmpty) {
        filtered = filtered.where((character) =>
          _selectedGenderFilters.contains(character.gender.toLowerCase())
        ).toList();
      }

      // Filtro por tipo
      if (_selectedTypeFilters.isNotEmpty) {
        filtered = filtered.where((character) =>
          character.type.isNotEmpty && _selectedTypeFilters.contains(character.type.toLowerCase())
        ).toList();
      }
    }

    return filtered;
  }

  /// Cache otimizado para toLowerCase()
  String _getCachedLowerCase(String text) {
    return _lowerCaseCache.putIfAbsent(text, () => text.toLowerCase());
  }

  /// Carrega a primeira página de personagens
  Future<void> loadCharacters() async {
    if (_state is CharacterListLoading) return;

    _updateState(CharacterListLoading());

    try {
      final charactersPage = await _getCharactersPageUseCase.callByPage(page: 1);

      if (charactersPage.isEmpty) {
        _updateState(CharacterListEmpty());
      } else {
        _allCharacters = charactersPage.characters;
        _updateState(CharacterListLoaded(
          characters: computedCharacters,
          canLoadMore: charactersPage.canLoadMore,
          currentPage: 1,
          totalPages: charactersPage.totalPages,
        ));
      }
    } catch (e) {
      _updateState(_mapExceptionToErrorState(e));
    }
  }

  /// Carrega mais personagens (paginação infinita)
  Future<void> loadMoreCharacters() async {
    if (_isLoadingMore || _state is! CharacterListLoaded) return;

    final currentState = _state as CharacterListLoaded;
    if (!currentState.canLoadMore) return;

    _isLoadingMore = true;
    _updateState(CharacterListLoadingMore(currentState.characters));

    try {
      final nextPage = currentState.currentPage + 1;
      final charactersPage = await _getCharactersPageUseCase.callByPage(page: nextPage);

      _allCharacters.addAll(charactersPage.characters);
      final newState = currentState.copyWithMoreCharacters(charactersPage);
      _updateState(CharacterListLoaded(
        characters: computedCharacters,
        canLoadMore: newState.canLoadMore,
        currentPage: newState.currentPage,
        totalPages: newState.totalPages,
      ));
    } catch (e) {
      // Em caso de erro ao carregar mais, volta ao estado anterior
      _updateState(currentState);
      
      // Opcionalmente, pode mostrar um snackbar ou toast com o erro
      debugPrint('Erro ao carregar mais personagens: $e');
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Recarrega a lista (pull to refresh)
  Future<void> refresh() async {
    _updateState(CharacterListInitial());
    await loadCharacters();
  }

  /// Tenta novamente após um erro
  Future<void> retry() async {
    if (_state is CharacterListError) {
      await loadCharacters();
    }
  }

  /// Realiza busca nos personagens com debounce (SISTEMA HÍBRIDO)
  void searchCharacters(String query) {
    // Cancela timers anteriores se existirem
    _searchTimer?.cancel();
    _filterTimer?.cancel();
    
    // Atualiza estado de busca imediatamente para feedback visual
    _isSearching = query.isNotEmpty;
    
    // Configura debounce de 500ms para busca
    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = query;
      
      // Usa sistema híbrido: API se há filtros, local se navegação normal
      _triggerHybridFiltering();
    });
    
    notifyListeners();
  }

  /// Limpa a busca (SISTEMA HÍBRIDO)
  void clearSearch() {
    _searchTimer?.cancel();
    _filterTimer?.cancel();
    _searchQuery = '';
    _isSearching = false;
    _lowerCaseCache.clear(); // Limpa cache quando busca é limpa
    
    // Reavalia filtros com sistema híbrido
    _triggerHybridFiltering();
  }


  /// Atualiza filtros de status (SISTEMA HÍBRIDO)
  void updateStatusFilters(List<String> filters) {
    _selectedStatusFilters = filters.map((f) => f.toLowerCase()).toList();
    _triggerHybridFiltering();
  }

  /// Atualiza filtros de espécie (SISTEMA HÍBRIDO)
  void updateSpeciesFilters(List<String> filters) {
    _selectedSpeciesFilters = filters.map((f) => f.toLowerCase()).toList();
    _triggerHybridFiltering();
  }

  /// Atualiza filtros de gênero (SISTEMA HÍBRIDO)
  void updateGenderFilters(List<String> filters) {
    _selectedGenderFilters = filters.map((f) => f.toLowerCase()).toList();
    _triggerHybridFiltering();
  }

  /// Atualiza filtros de tipo (SISTEMA HÍBRIDO)
  void updateTypeFilters(List<String> filters) {
    _selectedTypeFilters = filters.map((f) => f.toLowerCase()).toList();
    _triggerHybridFiltering();
  }

  /// Coordena sistema híbrido: paginação local vs filtros via API
  void _triggerHybridFiltering() {
    _filterTimer?.cancel();
    
    // Debounce de 800ms para filtros
    _filterTimer = Timer(const Duration(milliseconds: 800), () {
      final hasFilters = _hasActiveFilters();
      
      if (hasFilters) {
        // MODO FILTRO: Consulta API com parâmetros
        _isFilterMode = true;
        _filterCurrentPage = 1;
        _executeFilterSearch();
      } else {
        // MODO PAGINAÇÃO: Volta à navegação normal
        _clearFiltersAndReturnToPagination();
      }
    });
  }

  /// Limpa todos os filtros (SISTEMA HÍBRIDO)
  void clearAllFilters() {
    _searchTimer?.cancel();
    _filterTimer?.cancel();
    _searchQuery = '';
    _isSearching = false;
    _selectedStatusFilters.clear();
    _selectedSpeciesFilters.clear();
    _selectedGenderFilters.clear();
    _selectedTypeFilters.clear();
    _lowerCaseCache.clear();
    
    // Retorna ao modo paginação
    _clearFiltersAndReturnToPagination();
  }

  /// Retorna filtros disponíveis baseados nos personagens carregados
  /// Filtros de status (oficiais da API)
  List<String> get availableStatusFilters {
    return List<String>.from(_officialStatuses);
  }

  /// Filtros de espécie (baseados na API real dos 826+ personagens)
  List<String> get availableSpeciesFilters {
    return List<String>.from(_commonSpecies);
  }
  
  /// Filtros de gênero (oficiais da API)
  List<String> get availableGenderFilters {
    return List<String>.from(_officialGenders);
  }

  /// Filtros de tipo (dinâmicos baseados em personagens carregados + comuns)
  List<String> get availableTypeFilters {
    // Combina tipos dos personagens carregados com os mais comuns
    final Set<String> allTypes = {};
    
    // Adiciona tipos dos personagens carregados
    if (_allCharacters.isNotEmpty) {
      allTypes.addAll(_allCharacters
          .map((character) => character.type.toLowerCase())
          .where((type) => type.isNotEmpty));
    }
    
    // Adiciona tipos comuns conhecidos
    allTypes.addAll([
      'parasite',
      'genetic experiment',
      'sentient arm',
      'collective',
      'vampire',
      'cyborg',
      'duplicate',
      'clone',
      'simulation',
      'hologram',
      'superhuman',
      'microverse inhabitant',
    ]);
    
    final typesList = allTypes.toList();
    typesList.sort();
    return typesList;
  }
  /// Atualiza o estado e notifica os listeners
  void _updateState(CharacterListState newState) {
    _state = newState;
    notifyListeners();
  }

  // ========== MÉTODOS DO SISTEMA HÍBRIDO ==========
  
  /// Detecta se há filtros ativos (determina modo paginação vs filtros)
  bool _hasActiveFilters() {
    return _searchQuery.isNotEmpty ||
           _selectedStatusFilters.isNotEmpty ||
           _selectedSpeciesFilters.isNotEmpty ||
           _selectedGenderFilters.isNotEmpty ||
           _selectedTypeFilters.isNotEmpty;
  }
  
  /// Gera chave única para cache baseada nos filtros aplicados
  String _generateFilterKey() {
    final parts = <String>[];
    if (_searchQuery.isNotEmpty) parts.add('search:$_searchQuery');
    if (_selectedStatusFilters.isNotEmpty) parts.add('status:${_selectedStatusFilters.join(",")}');
    if (_selectedSpeciesFilters.isNotEmpty) parts.add('species:${_selectedSpeciesFilters.join(",")}');
    if (_selectedGenderFilters.isNotEmpty) parts.add('gender:${_selectedGenderFilters.join(",")}');
    if (_selectedTypeFilters.isNotEmpty) parts.add('type:${_selectedTypeFilters.join(",")}');
    return parts.join('|');
  }
  
  /// Gera descrição amigável dos filtros aplicados
  String _generateFilterDescription() {
    final filters = <String>[];
    if (_searchQuery.isNotEmpty) filters.add('Busca: $_searchQuery');
    if (_selectedStatusFilters.isNotEmpty) filters.add('Status: ${_selectedStatusFilters.join(", ")}');
    if (_selectedSpeciesFilters.isNotEmpty) filters.add('Espécies: ${_selectedSpeciesFilters.join(", ")}');
    if (_selectedGenderFilters.isNotEmpty) filters.add('Gêneros: ${_selectedGenderFilters.join(", ")}');
    if (_selectedTypeFilters.isNotEmpty) filters.add('Tipos: ${_selectedTypeFilters.join(", ")}');
    return filters.join(' • ');
  }
  
  /// Executa busca com filtros via API (sistema híbrido)
  Future<void> _executeFilterSearch() async {
    final filterKey = _generateFilterKey();
    
    // Verifica cache primeiro
    if (_filterCache.containsKey(filterKey)) {
      final cachedResults = _filterCache[filterKey]!;
      _updateState(CharacterListFilterResults(
        characters: cachedResults,
        hasMorePages: false, // Cache completo
        currentPage: 1,
        totalPages: 1,
        appliedFilters: _generateFilterDescription(),
      ));
      return;
    }
    
    _updateState(CharacterListLoadingFilter());
    
    try {
      // Busca via API com filtros
      // Busca via API com filtros
      final charactersPage = await _getCharactersPageUseCase.callWithFilters(
        name: _searchQuery.isNotEmpty ? _searchQuery : null,
        status: _selectedStatusFilters.isNotEmpty ? _selectedStatusFilters : null,
        species: _selectedSpeciesFilters.isNotEmpty ? _selectedSpeciesFilters : null,
        type: _selectedTypeFilters.isNotEmpty ? _selectedTypeFilters : null,
        gender: _selectedGenderFilters.isNotEmpty ? _selectedGenderFilters : null,
        page: _filterCurrentPage,
      );
      if (charactersPage.characters.isEmpty) {
        _updateState(CharacterListEmpty());
      } else {
        // Armazena no cache
        _filterCache[filterKey] = charactersPage.characters;
        
        _updateState(CharacterListFilterResults(
          characters: charactersPage.characters,
          hasMorePages: charactersPage.canLoadMore,
          currentPage: _filterCurrentPage,
          totalPages: charactersPage.totalPages,
          appliedFilters: _generateFilterDescription(),
        ));
      }
    } catch (e) {
      // Tratamento especial para 404: significa "sem resultados" não "erro"
      if (e is ClientException && e.statusCode == 404) {
        debugPrint('Filtro não retornou resultados (404): $_generateFilterDescription()');
        _updateState(CharacterListEmpty());
      } else {
        _updateState(_mapExceptionToErrorState(e));
      }
    }
  }
  
  /// Limpa cache de filtros e retorna ao modo paginação
  void _clearFiltersAndReturnToPagination() {
    _filterCache.clear();
    _filterCurrentPage = 1;
    _isFilterMode = false;
    
    // Recarrega paginação normal
    loadCharacters();
  }

  /// Mapeia exceções para estados de erro apropriados
  CharacterListError _mapExceptionToErrorState(Object exception) {
    if (exception is NetworkException) {
      return CharacterListError(
        message: _getNetworkErrorMessage(exception),
        isRetryable: true,
      );
    }

    return CharacterListError(
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
        return 'Personagens não encontrados.';
      }
      return 'Erro na requisição. Tente novamente.';
    }

    return exception.message;
  }

  /// Portal Aleatório - Funcionalidade especial Rick & Morty
  ///
  /// Busca um personagem completamente aleatório e retorna seu ID para navegação
  /// Inclui animação de "portal" durante o carregamento
  Future<int?> openRandomPortal() async {
    if (_isPortalLoading) return null;

    _isPortalLoading = true;
    notifyListeners();

    try {
      // Simula delay do portal para melhor UX
      await Future.delayed(const Duration(milliseconds: 800));
      
      final randomCharacter = await _getRandomCharacterUseCase.call();
      
      return randomCharacter.id;
    } catch (e) {
      debugPrint('Erro no Portal Aleatório: $e');
      
      // Define mensagem de erro específica para o usuário
      _portalError = 'Falha no portal! Tente novamente.';
      
      // Limpa o erro após 3 segundos
      Future.delayed(const Duration(seconds: 3), () {
        _portalError = null;
        notifyListeners();
      });
      
      return null;
    } finally {
      _isPortalLoading = false;
      notifyListeners();
    }
  }

  /// Calcula o total de filtros ativos em todas as categorias
  ///
  /// CORREÇÃO MVVM: Move lógica da View para ViewModel
  int get totalActiveFilters {
    return _selectedStatusFilters.length +
           _selectedSpeciesFilters.length +
           _selectedGenderFilters.length +
           _selectedTypeFilters.length;
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _filterTimer?.cancel();
    super.dispose();
  }
}