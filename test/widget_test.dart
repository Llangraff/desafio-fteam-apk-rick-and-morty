import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_morty_app/main.dart';
import 'package:rick_morty_app/shared/widgets/splash_screen_widget.dart';
import 'package:rick_morty_app/shared/widgets/search_bar_widget.dart';
import 'package:rick_morty_app/shared/widgets/error_state_widget.dart';
import 'package:rick_morty_app/features/characters/presentation/widgets/character_card.dart';
import 'package:rick_morty_app/features/characters/domain/entities/character.dart';

void main() {
  group('Rick and Morty App Tests', () {
    testWidgets('App should start with splash screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const RickMortyApp());

      // Verify that splash screen is shown
      expect(find.text('Rick and Morty'), findsOneWidget);
      expect(find.text('Personagens'), findsOneWidget);

      // Wait for splash screen timer to complete
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pumpAndSettle();
    });

    testWidgets('Splash screen widget should render correctly', (WidgetTester tester) async {
      // Build splash screen widget
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreenWidget(),
        ),
      );

      // Verify splash screen elements
      expect(find.text('Rick and Morty'), findsOneWidget);
      expect(find.text('Personagens'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Character card should display character info', (WidgetTester tester) async {
      // Create a test character
      const testCharacter = Character(
        id: 1,
        name: 'Rick Sanchez',
        status: 'Alive',
        species: 'Human',
        type: '',
        gender: 'Male',
        origin: CharacterOrigin(name: 'Earth (C-137)', url: 'https://rickandmortyapi.com/api/location/1'),
        location: CharacterLocation(name: 'Citadel of Ricks', url: 'https://rickandmortyapi.com/api/location/3'),
        episode: ['https://rickandmortyapi.com/api/episode/1', 'https://rickandmortyapi.com/api/episode/2'],
        url: 'https://rickandmortyapi.com/api/character/1',
        created: '2017-11-04T18:48:46.250Z',
        image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
      );

      // Build character card widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterCard(
              character: testCharacter,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verify character information is displayed
      expect(find.text('Rick Sanchez'), findsOneWidget);
      expect(find.text('Human'), findsOneWidget);
      expect(find.text('Alive'), findsOneWidget);
    });

    testWidgets('Search bar widget should render correctly', (WidgetTester tester) async {
      // Build search bar widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              onSearch: (query) {},
              hintText: 'Buscar personagens...',
            ),
          ),
        ),
      );

      // Verify search bar elements
      expect(find.text('Buscar personagens...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Error state widget should display error message', (WidgetTester tester) async {
      // Build error state widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              title: 'Erro de teste',
              message: 'Mensagem de erro de teste',
              errorType: ErrorType.general,
            ),
          ),
        ),
      );

      // Verify error state elements
      expect(find.text('Erro de teste'), findsOneWidget);
      expect(find.text('Mensagem de erro de teste'), findsOneWidget);
    });

    testWidgets('Error state widget should show different icons for different error types', (WidgetTester tester) async {
      // Test network error
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              errorType: ErrorType.network,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);

      // Test not found error
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              errorType: ErrorType.notFound,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search_off), findsOneWidget);

      // Test server error
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              errorType: ErrorType.server,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    });
  });
}
