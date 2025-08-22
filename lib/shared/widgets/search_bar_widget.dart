import 'package:flutter/material.dart';
import 'package:rick_morty_app/core/theme/app_colors.dart';

/// Widget de barra de pesquisa elegante com animações
class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;
  final String hintText;
  final VoidCallback? onClear;
  final bool showFilterButton;
  final VoidCallback? onFilterTap;
  final bool isSearching;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    this.hintText = 'Buscar personagens...',
    this.onClear,
    this.showFilterButton = false,
    this.onFilterTap,
    this.isSearching = false,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
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
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _isSearching = value.isNotEmpty;
    });
    widget.onSearch(value);

    if (value.isNotEmpty) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.surface,
                  AppColors.surface.withValues(alpha:0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha:0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              // SOLUÇÃO DEFINITIVA: Bypass completo do sistema de temas
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                inherit: false, // Ignora herança de tema completamente
              ),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  inherit: false, // Ignora herança de tema completamente
                ),
                prefixIcon: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    widget.isSearching ? Icons.search : Icons.search,
                    color: widget.isSearching || _isSearching ? AppColors.primary : AppColors.textHint,
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isSearching)
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: AppColors.textSecondaryOnDark,
                          ),
                          onPressed: _clearSearch,
                        ),
                      ),
                    if (widget.showFilterButton)
                      IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: widget.isSearching || _isSearching ? AppColors.primary : AppColors.textSecondaryOnDark,
                        ),
                        onPressed: widget.onFilterTap,
                      ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 236, 12, 12),

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
