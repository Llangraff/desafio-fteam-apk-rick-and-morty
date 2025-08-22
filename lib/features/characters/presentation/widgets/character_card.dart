import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/character.dart';

/// Widget que representa um card de personagem na lista
///
/// Redesenhado com nova paleta "Espaço Sideral" para máxima legibilidade
/// e experiência visual premium
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
      duration: const Duration(milliseconds: 200), // Animação mais suave
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96, // Escala mais sutil
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 4.0, // Elevação inicial reduzida
      end: 8.0,   // Elevação máxima reduzida
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
            shadowColor: AppColors.primary.withValues(alpha: 0.15), // Sombra mais sutil
            color: AppColors.surface, // Nova cor da paleta "Espaço Sideral"
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: AppColors.border.withValues(alpha: 0.3), // Borda sutil
                width: 0.5,
              ),
            ),
            child: InkWell(
              onTap: widget.onTap,
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              borderRadius: BorderRadius.circular(16),
              splashColor: AppColors.primary.withValues(alpha: 0.08), // Splash mais sutil
              highlightColor: AppColors.primary.withValues(alpha: 0.04),
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
                          color: AppColors.surface,
                          child: const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 40, // Tamanho reduzido para melhor proporção
                          ),
                        ),
                        memCacheWidth: 300, // Otimização mantida
                        memCacheHeight: 300,
                      ),
                    ),
                  ),
                  
                  // Informações do personagem
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12), // Padding aumentado para melhor respiração
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Nome do personagem - MELHOR LEGIBILIDADE
                          Flexible(
                            child: Text(
                              widget.character.name,
                              style: AppTypography.characterName.copyWith(
                                color: AppColors.textPrimary, // Branco puro
                                fontSize: 14, // Fonte restaurada para melhor legibilidade
                                fontWeight: FontWeight.w700, // Mais bold
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 6), // Espaçamento aumentado

                          // Status e espécie com melhor layout
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Status chip redesenhado
                              _StatusChip(status: widget.character.status),
                              const SizedBox(width: 8), // Espaçamento aumentado
                              // Espécie com melhor contraste
                              Expanded(
                                child: Text(
                                  widget.character.species,
                                  style: AppTypography.characterSpecies.copyWith(
                                    color: AppColors.textSecondary, // Cinza claro da nova paleta
                                    fontSize: 12, // Fonte restaurada
                                  ),
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

/// Widget que exibe o status do personagem com design premium
/// 
/// Redesenhado com a nova paleta "Espaço Sideral" para máxima legibilidade
class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final statusColor = AppColors.getStatusColor(status);

    return Container(
      constraints: const BoxConstraints(maxWidth: 80), // Largura otimizada
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Padding aumentado
      decoration: BoxDecoration(
        // Background com opacity adequada para legibilidade
        color: statusColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.4), // Borda mais visível
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.2),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicador circular do status
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          // Texto do status
          Flexible(
            child: Text(
              status,
              style: AppTypography.characterStatus.copyWith(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.w600, // Mais bold para legibilidade
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}