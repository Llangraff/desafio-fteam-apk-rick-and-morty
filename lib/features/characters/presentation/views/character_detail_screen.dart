import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../domain/entities/character.dart';
import '../viewmodels/character_detail_viewmodel.dart';
import '../viewmodels/character_detail_state.dart';

/// Tela de detalhes PREMIUM de um personagem específico
class CharacterDetailScreen extends StatefulWidget {
  final int characterId;

  const CharacterDetailScreen({
    super.key,
    required this.characterId,
  });

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Inicializa animações
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    // Carrega os dados do personagem
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterDetailViewModel>().loadCharacter(widget.characterId);
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RickMortyBackground(
        child: Consumer<CharacterDetailViewModel>(
          builder: (context, viewModel, child) {
            final state = viewModel.state;

            if (state is CharacterDetailLoading) {
              return const CharacterDetailPremiumShimmer();
            }

            if (state is CharacterDetailError) {
              return ErrorStateWidget(
                title: 'Erro ao carregar personagem',
                message: state.message,
                actionText: state.isRetryable ? 'Tentar novamente' : null,
                onAction: state.isRetryable ? viewModel.retry : null,
                errorType: viewModel.getErrorType(state.message),
              );
            }

            if (state is CharacterDetailLoaded) {
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _CharacterDetailPremiumContent(
                        character: state.character,
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

}

/// Widget PREMIUM que exibe o conteúdo completo dos detalhes do personagem
class _CharacterDetailPremiumContent extends StatelessWidget {
  final Character character;

  const _CharacterDetailPremiumContent({required this.character});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Hero Section com AppBar transparente
        _HeroSectionSliver(character: character),
        
        // Conteúdo principal com seções organizadas
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Informações Pessoais
                _PersonalInfoSection(character: character),
                
                const SizedBox(height: 16),
                
                // Localização
                _LocationSection(character: character),
                
                const SizedBox(height: 16),
                
                // Episódios
                _EpisodesSection(character: character),
                
                const SizedBox(height: 16),
                
                // Estatísticas
                _StatisticsSection(character: character),
                
                const SizedBox(height: 16),
                
                // Detalhes Técnicos
                _TechnicalDetailsSection(character: character),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Hero Section com imagem e informações básicas em overlay
class _HeroSectionSliver extends StatelessWidget {
  final Character character;

  const _HeroSectionSliver({required this.character});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha:0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            final navigationService = context.read<NavigationService>();
            navigationService.goBack();
          },
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Imagem do personagem
            CachedNetworkImage(
              imageUrl: character.image,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.shimmer,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.background,
                child: const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 64,
                ),
              ),
            ),
            
            // Overlay gradiente
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha:0.7),
                  ],
                ),
              ),
            ),
            
            // Informações básicas em overlay
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome
                  Text(
                    character.name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Status Badge
                  _StatusBadge(status: character.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Badge animado para status
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getStatusColor(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha:0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Seção de informações pessoais
class _PersonalInfoSection extends StatelessWidget {
  final Character character;

  const _PersonalInfoSection({required this.character});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Informações Pessoais',
      icon: Icons.person,
      children: [
        _InfoRowPremium(
          icon: AppIcons.getSpeciesIcon(character.species),
          label: 'Espécie',
          value: character.species,
          iconColor: AppColors.secondary,
        ),
        if (character.type.isNotEmpty) ...[
          const SizedBox(height: 12),
          _InfoRowPremium(
            icon: Icons.category,
            label: 'Tipo',
            value: character.type,
            iconColor: AppColors.warning,
          ),
        ],
        const SizedBox(height: 12),
        _InfoRowPremium(
          icon: _getGenderIcon(character.gender),
          label: 'Gênero',
          value: character.gender,
          iconColor: _getGenderColor(character.gender),
        ),
      ],
    );
  }

  IconData _getGenderIcon(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return Icons.male;
      case 'female':
        return Icons.female;
      case 'genderless':
        return Icons.remove_circle_outline;
      default:
        return Icons.help_outline;
    }
  }

  Color _getGenderColor(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return Colors.blue;
      case 'female':
        return Colors.pink;
      case 'genderless':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

/// Seção de localização
class _LocationSection extends StatelessWidget {
  final Character character;

  const _LocationSection({required this.character});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Localização',
      icon: Icons.public,
      children: [
        _LocationCard(
          title: 'Origem',
          location: character.origin.name,
          icon: Icons.home,
          color: AppColors.primary,
        ),
        const SizedBox(height: 12),
        _LocationCard(
          title: 'Localização Atual',
          location: character.location.name,
          icon: Icons.location_on,
          color: AppColors.secondary,
        ),
      ],
    );
  }
}

/// Card individual de localização
class _LocationCard extends StatelessWidget {
  final String title;
  final String location;
  final IconData icon;
  final Color color;

  const _LocationCard({
    required this.title,
    required this.location,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cardLight,
            AppColors.cardLight,
            color.withValues(alpha:0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondaryOnDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: AppTypography.subtitle2.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Seção de episódios
class _EpisodesSection extends StatelessWidget {
  final Character character;

  const _EpisodesSection({required this.character});

  @override
  Widget build(BuildContext context) {
    final episodeCount = character.totalEpisodes;
    
    return _SectionCard(
      title: 'Episódios',
      icon: Icons.tv,
      subtitle: '$episodeCount aparições',
      children: [
        // Contador de episódios destacado
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha:0.1),
                AppColors.secondary.withValues(alpha:0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha:0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha:0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.tv,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$episodeCount',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                episodeCount == 1 ? 'Episódio' : 'Episódios',
                style: AppTypography.body2.copyWith(
                  color: AppColors.textSecondaryOnDark,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Lista de episódios em scroll horizontal
        if (character.episodeIds.isNotEmpty) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Lista de Episódios',
              style: AppTypography.subtitle2.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: character.episodeIds.length,
              itemBuilder: (context, index) {
                final episodeId = character.episodeIds[index];
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha:0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'EP $episodeId',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

/// Seção de estatísticas
class _StatisticsSection extends StatelessWidget {
  final Character character;

  const _StatisticsSection({required this.character});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Estatísticas',
      icon: Icons.analytics,
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Episódios',
                value: '${character.totalEpisodes}',
                icon: Icons.tv,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'ID',
                value: '#${character.id}',
                icon: Icons.tag,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Status',
                value: character.status,
                icon: AppIcons.getStatusIcon(character.status),
                color: AppColors.getStatusColor(character.status),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'Gênero',
                value: character.gender,
                icon: character.isMale ? Icons.male : character.isFemale ? Icons.female : Icons.help_outline,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Card individual de estatística
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cardLight,
            AppColors.cardLight.withValues(alpha:0.95),
            color.withValues(alpha:0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondaryOnDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// Seção de detalhes técnicos
class _TechnicalDetailsSection extends StatelessWidget {
  final Character character;

  const _TechnicalDetailsSection({required this.character});

  @override
  Widget build(BuildContext context) {
    final createdDate = DateTime.tryParse(character.created);
    final formattedDate = createdDate != null
        ? '${createdDate.day}/${createdDate.month}/${createdDate.year}'
        : character.created;

    return _SectionCard(
      title: 'Detalhes Técnicos',
      icon: Icons.code,
      children: [
        _InfoRowPremium(
          icon: Icons.link,
          label: 'API URL',
          value: character.url,
          iconColor: AppColors.warning,
          valueStyle: AppTypography.caption.copyWith(
            color: AppColors.textSecondaryOnDark,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),
        _InfoRowPremium(
          icon: Icons.schedule,
          label: 'Criado em',
          value: formattedDate,
          iconColor: AppColors.primary,
        ),
      ],
    );
  }
}

/// Card base para seções
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? subtitle;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: AppColors.primary.withValues(alpha:0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.cardGradient,
          ),
          border: Border.all(
            color: AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header da seção
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.subtitle1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondaryOnDark,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Conteúdo da seção
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget premium para linha de informação
class _InfoRowPremium extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final TextStyle? valueStyle;

  const _InfoRowPremium({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primary).withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppColors.primary,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondaryOnDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: valueStyle ?? AppTypography.body2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Shimmer loading premium específico para detalhes
class CharacterDetailPremiumShimmer extends StatelessWidget {
  const CharacterDetailPremiumShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Hero shimmer
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: ShimmerLoading(
              child: Container(
                color: AppColors.shimmer,
              ),
            ),
          ),
        ),
        
        // Conteúdo shimmer
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Seções shimmer
                for (int i = 0; i < 4; i++) ...[
                  _SectionShimmer(),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Shimmer para seções individuais
class _SectionShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header shimmer
            Row(
              children: [
                ShimmerLoading(
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.shimmer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoading(
                        child: Container(
                          width: 120,
                          height: 16,
                          color: AppColors.shimmer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ShimmerLoading(
                        child: Container(
                          width: 80,
                          height: 12,
                          color: AppColors.shimmer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Conteúdo shimmer
            for (int i = 0; i < 3; i++) ...[
              Row(
                children: [
                  ShimmerLoading(
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.shimmer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoading(
                          child: Container(
                            width: 60,
                            height: 12,
                            color: AppColors.shimmer,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ShimmerLoading(
                          child: Container(
                            width: double.infinity,
                            height: 14,
                            color: AppColors.shimmer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (i < 2) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}