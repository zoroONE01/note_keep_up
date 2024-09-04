import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:note_app/features/presentation/pages/note/widget/widgets.dart';
import 'package:note_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Note Flow Integration Test', () {
    testWidgets('Load list of notes and add a new note', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify that the HomePage is displayed
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Tap the FloatingActionButton to add a new note
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify that the NotePage is displayed
      expect(find.byType(TextFieldsForm), findsOneWidget);

      // Enter a title for the new note
      await tester.enterText(find.byType(TextField).first, 'Test Note Title');

      // Enter content for the new note
      await tester.enterText(find.byType(TextField).last, 'Test Note Content');

      // Navigate back to save the note
      await tester.tap(find.byType(AppBarNote));
      await tester.pumpAndSettle();

      // Verify that we're back on the HomePage
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Verify that the new note is displayed in the list
      expect(find.text('Test Note Title'), findsOneWidget);
      expect(find.text('Test Note Content'), findsOneWidget);
    });
  });
}
