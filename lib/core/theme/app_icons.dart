import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Classe centralizada para ícones personalizados da aplicação
class AppIcons {
  
  // Ícones para status dos personagens
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Icons.favorite;
      case 'dead':
        return Icons.heart_broken;
      case 'unknown':
      default:
        return Icons.help_outline;
    }
  }

  // Ícones para espécies
  static IconData getSpeciesIcon(String species) {
    switch (species.toLowerCase()) {
      case 'human':
        return Icons.person;
      case 'alien':
        return Icons.android;
      case 'humanoid':
        return Icons.accessibility;
      case 'robot':
        return Icons.smart_toy;
      case 'cronenberg':
        return Icons.bug_report;
      case 'disease':
        return Icons.coronavirus;
      default:
        return Icons.science;
    }
  }

  // Ícones para gênero
  static IconData getGenderIcon(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return Icons.male;
      case 'female':
        return Icons.female;
      case 'genderless':
        return Icons.remove;
      case 'unknown':
      default:
        return Icons.help_outline;
    }
  }

  // Ícones temáticos da aplicação
  static const IconData search = Icons.search;
  static const IconData filter = Icons.filter_list;
  static const IconData refresh = Icons.refresh;
  static const IconData location = Icons.location_on;
  static const IconData origin = Icons.home;
  static const IconData episodes = Icons.movie;
  static const IconData info = Icons.info_outline;
  static const IconData back = Icons.arrow_back;
  static const IconData settings = Icons.settings;
  static const IconData darkMode = Icons.dark_mode;
  static const IconData lightMode = Icons.light_mode;
  static const IconData share = Icons.share;
  static const IconData favorite = Icons.favorite_border;
  static const IconData favoriteSelected = Icons.favorite;

  // Ícones para navegação
  static const IconData home = Icons.home_outlined;
  static const IconData homeSelected = Icons.home;
  static const IconData profile = Icons.person_outline;
  static const IconData profileSelected = Icons.person;

  // Ícones para estados
  static const IconData error = Icons.error_outline;
  static const IconData warning = Icons.warning_amber;
  static const IconData success = Icons.check_circle_outline;
  static const IconData loading = Icons.hourglass_empty;
  static const IconData empty = Icons.inbox_outlined;
  static const IconData noNetwork = Icons.wifi_off;
}

/// Widget helper para ícones com estilo consistente
class AppIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  const AppIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size ?? 24,
      color: color ?? AppColors.textOnDark,
      semanticLabel: semanticLabel,
    );
  }
}

/// Widget para ícones status com cor temática
class StatusIcon extends StatelessWidget {
  final String status;
  final double? size;

  const StatusIcon({
    super.key,
    required this.status,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AppIcon(
      AppIcons.getStatusIcon(status),
      size: size,
      color: AppColors.getStatusColor(status),
    );
  }
}

/// Widget para ícones de espécie com estilo
class SpeciesIcon extends StatelessWidget {
  final String species;
  final double? size;
  final Color? color;

  const SpeciesIcon({
    super.key,
    required this.species,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppIcon(
      AppIcons.getSpeciesIcon(species),
      size: size,
      color: color ?? AppColors.primary,
    );
  }
}

/// Widget para ícones circulares com background
class CircularIcon extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final double size;
  final double? iconSize;

  const CircularIcon({
    super.key,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.size = 40,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary.withValues(alpha:0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: AppIcon(
          icon,
          size: iconSize ?? size * 0.5,
          color: iconColor ?? AppColors.primary,
        ),
      ),
    );
  }
}