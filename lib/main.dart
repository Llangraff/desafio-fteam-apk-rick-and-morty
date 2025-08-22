import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/dependency_injection.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/custom_page_routes.dart';
import 'core/navigation/navigation_service.dart';
import 'core/services/notification_service.dart';
import 'shared/widgets/splash_screen_widget.dart';
import 'features/characters/presentation/views/character_list_screen.dart';
import 'features/characters/presentation/views/character_detail_screen.dart';

void main() {
  runApp(const RickMortyApp());
}

/// Tela de splash screen
class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navegar para a tela principal após a animação usando NavigationService
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        final navigationService = context.read<NavigationService>();
        navigationService.navigateAndReplace('/character-list');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreenWidget();
  }
}

/// Aplicação principal Rick and Morty
class RickMortyApp extends StatelessWidget {
  const RickMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: DependencyInjection.providers,
      child: MaterialApp(
        title: 'Rick and Morty',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        
        // Configura o NavigationService e NotificationService com contextos globais
        navigatorKey: NavigationService.navigatorKey,
        scaffoldMessengerKey: NotificationService.scaffoldMessengerKey,

            // Tela inicial - Splash Screen
            home: const _SplashScreen(),
            
            // Configuração de rotas
            routes: {
              '/character-list': (context) => const CharacterListScreen(),
            },
            
            // Gerador de rotas para navegação com argumentos
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/character-detail':
                  final characterId = settings.arguments as int;
                  return CustomPageRoutes.characterDetailTransition(
                    page: CharacterDetailScreen(characterId: characterId),
                    settings: settings,
                  );
                
                default:
                  return CustomPageRoutes.fadeScale(
                    page: const _NotFoundScreen(),
                    settings: settings,
                  );
              }
            },
            
        // Rota inicial
        initialRoute: '/',
      ),
    );
  }
}

/// Tela para rotas não encontradas
class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página não encontrada'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Página não encontrada',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'A página que você está procurando não existe.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
