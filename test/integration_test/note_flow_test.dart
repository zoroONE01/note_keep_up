import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:note_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Note Flow Integration Test', () {
    testWidgets('Add, Update, and Delete Note', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Add a new note
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill in the note details
      await tester.enterText(find.byType(TextField).first, 'Test Title');
      await tester.enterText(find.byType(TextField).last, 'Test Content');
      await tester.pumpAndSettle();

      // Save the note
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify the note is added
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);

      // Open the note to update
      await tester.tap(find.text('Test Title'));
      await tester.pumpAndSettle();

      // Update the note
      await tester.enterText(find.byType(TextField).first, 'Updated Title');
      await tester.enterText(find.byType(TextField).last, 'Updated Content');
      await tester.pumpAndSettle();

      // Save the updated note
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify the note is updated
      expect(find.text('Updated Title'), findsOneWidget);
      expect(find.text('Updated Content'), findsOneWidget);

      // Delete the note
      await tester.longPress(find.text('Updated Title'));
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Verify the note is deleted
      expect(find.text('Updated Title'), findsNothing);
      expect(find.text('Updated Content'), findsNothing);
    });
  });
}
