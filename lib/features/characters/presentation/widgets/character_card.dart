import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/character.dart';

/// Widget que representa um card de personagem na lista
///
/// Exibe a imagem, nome e status do personagem de forma compacta
class CharacterCard extends StatefulWidget {
  final Character character;
  final VoidCallback? onTap;

  const CharacterCard({
    super.key,
    required this.character,
    this.onTap,
  });

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 8.0,
      end: 12.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            elevation: _elevationAnimation.value,
            shadowColor: AppColors.primary.withValues(alpha:0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: widget.onTap,
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              borderRadius: BorderRadius.circular(16),
              splashColor: AppColors.primary.withValues(alpha:0.1),
              highlightColor: AppColors.primary.withValues(alpha:0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagem do personagem
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.character.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.shimmer,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.background,
                          child: const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 48,
                          ),
                        ),
                        memCacheWidth: 300, // Otimização de memória
                        memCacheHeight: 300,
                      ),
                    ),
                  ),
                  
                  // Informações do personagem
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8), // Padding reduzido 10→8px para compactação
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Nome do personagem
                          Flexible(
                            child: Text(
                              widget.character.name,
                              style: AppTypography.characterName.copyWith(fontSize: 13), // Fonte reduzida 14→13px
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 4), // Espaçamento reduzido 6→4px

                          // Status com chip colorido
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: _StatusChip(status: widget.character.status),
                              ),
                              const SizedBox(width: 4), // Espaçamento reduzido 6→4px
                              Expanded(
                                child: Text(
                                  widget.character.species,
                                  style: AppTypography.characterSpecies.copyWith(fontSize: 11), // Fonte reduzida 12→11px
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Widget que exibe o status do personagem com cor semântica
class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final statusColor = AppColors.getStatusColor(status);

    return Container(
      constraints: const BoxConstraints(maxWidth: 75), // Largura máxima reduzida 80→75px
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), // Padding reduzido
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(10), // Borda reduzida 12→10px
        border: Border.all(color: statusColor.withValues(alpha:0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha:0.15),
            blurRadius: 2, // Blur reduzido 3→2px
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        status,
        style: AppTypography.characterStatus.copyWith(
          color: statusColor,
          fontSize: 11, // Fonte reduzida 12→11px
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}