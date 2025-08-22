import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Widget que exibe filtros usando chips estilizados
class FilterChipsWidget extends StatefulWidget {
  final List<String> availableFilters;
  final List<String> selectedFilters;
  final Function(List<String>) onFiltersChanged;
  final String title;

  const FilterChipsWidget({
    super.key,
    required this.availableFilters,
    required this.selectedFilters,
    required this.onFiltersChanged,
    this.title = 'Filtros',
  });

  @override
  State<FilterChipsWidget> createState() => _FilterChipsWidgetState();
}

class _FilterChipsWidgetState extends State<FilterChipsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  late Animation<double> _opacityAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heightAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
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

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _onChipSelected(String filter, bool selected) {
    final newFilters = List<String>.from(widget.selectedFilters);
    if (selected) {
      newFilters.add(filter);
    } else {
      newFilters.remove(filter);
    }
    widget.onFiltersChanged(newFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabeçalho dos filtros
        InkWell(
          onTap: _toggleExpanded,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha:0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border.withValues(alpha:0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: AppTypography.body1.copyWith(
                    color: AppColors.textOnDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (widget.selectedFilters.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.selectedFilters.length}',
                      style: AppTypography.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Lista de chips (animada e responsiva)
        SizeTransition(
          sizeFactor: _heightAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha:0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.border.withValues(alpha:0.3),
                  width: 1,
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.25, // Máximo 25% da tela
                ),
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(_getResponsivePadding(context)),
                    child: Wrap(
                      spacing: _getResponsiveSpacing(context),
                      runSpacing: _getResponsiveSpacing(context),
                      children: widget.availableFilters.map((filter) {
                        final isSelected = widget.selectedFilters.contains(filter);
                        return _buildResponsiveChip(filter, isSelected, context);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Calcula padding responsivo baseado no tamanho da tela
  double _getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 400) return 12.0; // Telas pequenas
    if (width < 600) return 16.0; // Telas médias
    return 20.0; // Telas grandes
  }

  /// Calcula spacing responsivo baseado no tamanho da tela
  double _getResponsiveSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 400) return 6.0; // Telas pequenas
    if (width < 600) return 8.0; // Telas médias
    return 10.0; // Telas grandes
  }

  /// Constrói chip responsivo com texto truncado
  Widget _buildResponsiveChip(String filter, bool isSelected, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final maxChipWidth = width < 400 ? width * 0.35 : width * 0.25;
    
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxChipWidth,
        minHeight: 32,
      ),
      child: FilterChip(
        label: Text(
          _truncateText(filter, maxChipWidth, context),
          style: AppTypography.body2.copyWith(
            color: isSelected ? Colors.white : AppColors.textOnDark,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: width < 400 ? 12.0 : 14.0, // Fonte menor em telas pequenas
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        selected: isSelected,
        onSelected: (selected) => _onChipSelected(filter, selected),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? AppColors.primary
                : AppColors.border.withValues(alpha:0.5),
            width: 1,
          ),
        ),
        elevation: isSelected ? 4 : 1,
        shadowColor: isSelected
            ? AppColors.primary.withValues(alpha:0.3)
            : Colors.transparent,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  /// Trunca texto baseado na largura disponível
  String _truncateText(String text, double maxWidth, BuildContext context) {
    if (text.length <= 12) return text; // Textos curtos não precisam truncar
    
    // Trunca genericamente se muito longo (removido lógica bugada)
    return text.length > 15 ? '${text.substring(0, 12)}...' : text;
  }
}