import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/filter_chips_widget.dart';
import '../../domain/entities/character.dart';
import '../viewmodels/character_list_viewmodel.dart';
import '../viewmodels/character_list_state.dart';
import '../widgets/character_card.dart';

/// Tela principal que exibe a lista de personagens com filtros
class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _isFiltersExpanded = false;

  @override
  void initState() {
    super.initState();
    
    // Configura infinite scroll
    _scrollController.addListener(_onScroll);
    
    // Carrega dados iniciais
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterListViewModel>().loadCharacters();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<CharacterListViewModel>().loadMoreCharacters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildFilters(),
              Expanded(
                child: Consumer<CharacterListViewModel>(
                  builder: (context, viewModel, child) {
                    return _buildContent(viewModel);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Título
          const Text(
            'Personagens Rick and Morty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          // Linha com barra de busca e botão de filtros
          Row(
            children: [
              // Barra de busca expandida
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar personagens...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<CharacterListViewModel>().clearSearch();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha:0.9),
                  ),
                  onChanged: (query) {
                    context.read<CharacterListViewModel>().searchCharacters(query);
                  },
                ),
              ),
              const SizedBox(width: 12),
              
              // Botão de filtros com badge
              Consumer<CharacterListViewModel>(
                builder: (context, viewModel, child) {
                  final totalActiveFilters = viewModel.totalActiveFilters;
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha:0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isFiltersExpanded
                            ? Colors.blue.withValues(alpha:0.5)
                            : Colors.grey.withValues(alpha:0.3),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isFiltersExpanded = !_isFiltersExpanded;
                            });
                          },
                          icon: Icon(
                            _isFiltersExpanded ? Icons.filter_alt : Icons.filter_alt_outlined,
                            color: _isFiltersExpanded ? Colors.blue : Colors.grey[600],
                            size: 24,
                          ),
                          tooltip: _isFiltersExpanded ? 'Ocultar Filtros' : 'Mostrar Filtros',
                        ),
                        // Badge com número de filtros ativos
                        if (totalActiveFilters > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                totalActiveFilters.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              
              // Botão Portal Aleatório
              Consumer<CharacterListViewModel>(
                builder: (context, viewModel, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00ff88), Color(0xFF00cc66)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00ff88).withValues(alpha:0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: viewModel.isPortalLoading ? null : () async {
                          // Capture services before async operation
                          final navigationService = context.read<NavigationService>();
                          final notificationService = context.read<NotificationService>();
                          
                          final characterId = await viewModel.openRandomPortal();
                          if (characterId != null && mounted) {
                            navigationService.navigateToCharacterDetail(characterId);
                          } else if (viewModel.portalError != null && mounted) {
                            notificationService.showError(viewModel.portalError!);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: viewModel.isPortalLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 24,
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildFilters() {
    // Se os filtros não estão expandidos, não mostra nada
    if (!_isFiltersExpanded) {
      return const SizedBox.shrink();
    }

    return Consumer<CharacterListViewModel>(
      builder: (context, viewModel, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              
              // Filtros por Status (inicia colapsado)
              FilterChipsWidget(
                availableFilters: viewModel.availableStatusFilters,
                selectedFilters: viewModel.selectedStatusFilters,
                onFiltersChanged: (filters) {
                  viewModel.updateStatusFilters(filters);
                },
                title: 'Status',
              ),
              const SizedBox(height: 12),

              // Filtros por Espécie (inicia colapsado)
              FilterChipsWidget(
                availableFilters: viewModel.availableSpeciesFilters,
                selectedFilters: viewModel.selectedSpeciesFilters,
                onFiltersChanged: (filters) {
                  viewModel.updateSpeciesFilters(filters);
                },
                title: 'Espécie',
              ),
              const SizedBox(height: 12),

              // Filtros por Gênero (inicia colapsado)
              FilterChipsWidget(
                availableFilters: viewModel.availableGenderFilters,
                selectedFilters: viewModel.selectedGenderFilters,
                onFiltersChanged: (filters) {
                  viewModel.updateGenderFilters(filters);
                },
                title: 'Gênero',
              ),
              
              // Botão limpar filtros
              if (viewModel.selectedStatusFilters.isNotEmpty ||
                  viewModel.selectedSpeciesFilters.isNotEmpty ||
                  viewModel.selectedGenderFilters.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        viewModel.clearAllFilters();
                      },
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Limpar Filtros'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withValues(alpha:0.8),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(CharacterListViewModel viewModel) {
    final state = viewModel.state;

    if (state is CharacterListInitial || state is CharacterListLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (state is CharacterListError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.white70,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar personagens',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => viewModel.retry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    List<Character> characters = [];
    bool showLoadingMore = false;

    if (state is CharacterListLoaded) {
      characters = state.characters;
    } else if (state is CharacterListLoadingMore) {
      characters = state.currentCharacters;
      showLoadingMore = true;
    } else if (state is CharacterListFilterResults) {
      characters = state.characters;
    }

    if (characters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: Colors.white70,
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhum personagem encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tente ajustar os filtros ou fazer uma nova busca.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.refresh(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Grid responsivo baseado na largura da tela
          int crossAxisCount;
          double childAspectRatio;
          
          if (constraints.maxWidth < 600) {
            // Mobile: 2 colunas
            crossAxisCount = 2;
            childAspectRatio = 0.85;
          } else if (constraints.maxWidth < 900) {
            // Tablet: 3 colunas
            crossAxisCount = 3;
            childAspectRatio = 0.9;
          } else {
            // Desktop: 4 colunas
            crossAxisCount = 4;
            childAspectRatio = 0.95;
          }
          
          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12), // Espaçamento reduzido 16→12
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12, // Espaçamento reduzido 16→12
              crossAxisSpacing: 12, // Espaçamento reduzido 16→12
              childAspectRatio: childAspectRatio,
            ),
            itemCount: characters.length + (showLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (showLoadingMore && index == characters.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              }

              return CharacterCard(
                character: characters[index],
                onTap: () {
                  final navigationService = context.read<NavigationService>();
                  navigationService.navigateToCharacterDetail(characters[index].id);
                },
              );
            },
          );
        },
      ),
    );
  }
}