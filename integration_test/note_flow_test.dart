import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:note_app/features/presentation/blocs/note/note_bloc.dart';
import 'package:note_app/features/domain/entities/note.dart';
import 'package:note_app/core/core.dart';

import '../test/features/presentation/blocs/note/note_bloc_test.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Note Flow Integration Test', () {
    late MockGetNotesUsecase mockGetNotesUsecase;
    late MockGetNoteByIdUsecase mockGetNoteByIdUsecase;
    late MockAddNoteUsecase mockAddNoteUsecase;
    late MockUpdateNoteUsecase mockUpdateNoteUsecase;
    late MockDeleteNoteUsecase mockDeleteNoteUsecase;
    late NoteBloc noteBloc;

    setUp(() {
      mockGetNotesUsecase = MockGetNotesUsecase();
      mockGetNoteByIdUsecase = MockGetNoteByIdUsecase();
      mockAddNoteUsecase = MockAddNoteUsecase();
      mockUpdateNoteUsecase = MockUpdateNoteUsecase();
      mockDeleteNoteUsecase = MockDeleteNoteUsecase();

      noteBloc = NoteBloc(
        getNotes: mockGetNotesUsecase,
        getNoteById: mockGetNoteByIdUsecase,
        addNote: mockAddNoteUsecase,
        updateNote: mockUpdateNoteUsecase,
        deleteNote: mockDeleteNoteUsecase,
      );
    });

    testWidgets('Load List, Add, Update, and Delete Note Flow',
        (WidgetTester tester) async {
      // Step 1: Load list of notes
      noteBloc.add(RefreshNotes(DrawerSelect.drawerSection));
      await tester.pumpAndSettle();

      expect(noteBloc.state, isA<NotesViewState>());

      // Step 2: Add a new note
      final newNote = Note(
        id: '1',
        title: 'Test Note',
        content: 'This is a test note',
        colorIndex: 0,
        modifiedTime: DateTime.now(),
        stateNote: StatusNote.undefined,
      );

      noteBloc.add(AddNote(newNote));
      await tester.pumpAndSettle();

      expect(noteBloc.state, isA<SuccessState>());
      expect((noteBloc.state as SuccessState).message, equals(ADD_SUCCESS_MSG));

      // Step 3: Update the note
      final updatedNote = newNote.copyWith(
        title: 'Updated Test Note',
        content: 'This note has been updated',
        modifiedTime: DateTime.now(),
      );

      noteBloc.add(UpdateNote(updatedNote));
      await tester.pumpAndSettle();

      expect(noteBloc.state, isA<SuccessState>());
      expect(
          (noteBloc.state as SuccessState).message, equals(UPDATE_SUCCESS_MSG));

      // Step 4: Delete the note
      noteBloc.add(DeleteNote(updatedNote.id));
      await tester.pumpAndSettle();

      expect(noteBloc.state, isA<SuccessState>());
      expect(
          (noteBloc.state as SuccessState).message, equals(DELETE_SUCCESS_MSG));

      // Verify that the note is deleted
      noteBloc.add(GetNoteById(updatedNote.id));
      await tester.pumpAndSettle();

      expect(noteBloc.state, isA<GetNoteByIdState>());
      expect((noteBloc.state as GetNoteByIdState).note, equals(Note.empty()));
    });

    testWidgets('Load List and Verify Empty State',
        (WidgetTester tester) async {
      // Step 1: Load list of notes
      noteBloc.add(RefreshNotes(DrawerSelect.drawerSection));
      await tester.pumpAndSettle();

      expect(noteBloc.state, isA<NotesViewState>());
      expect((noteBloc.state as NotesViewState).otherNotes, isEmpty);
    });

    testWidgets('Add Note and Verify in List', (WidgetTester tester) async {
      // Step 1: Add a new note
      final newNote = Note(
        id: '2',
        title: 'Another Test Note',
        content: 'This is another test note',
        colorIndex: 1,
        modifiedTime: DateTime.now(),
        stateNote: StatusNote.undefined,
      );

      noteBloc.add(AddNote(newNote));
      await tester.pumpAndSettle();

      expect(noteBloc.state, isA<SuccessState>());
      expect((noteBloc.state as SuccessState).message, equals(ADD_SUCCESS_MSG));

      // Step 2: Load list of notes and verify the new note is present
      noteBloc.add(RefreshNotes(DrawerSelect.drawerSection));
      await tester.pumpAndSettle();

      expect(noteBloc.state, isA<NotesViewState>());
      expect((noteBloc.state as NotesViewState).otherNotes, contains(newNote));
    });

    testWidgets('Update Note and Verify Changes', (WidgetTester tester) async {
      // Step 1: Add a new note
      final newNote = Note(
        id: '3',
        title: 'Note to Update',
        content: 'This note will be updated',
        colorIndex: 2,
        modifiedTime: DateTime.now(),
        stateNote: StatusNote.undefined,
      );

      noteBloc.add(AddNote(newNote));
      await tester.pumpAndSettle();

      expect(noteBloc.state, isA<SuccessState>());
      expect((noteBloc.state as SuccessState).message, equals(ADD_SUCCESS_MSG));

      // Step 2: Update the note
      final updatedNote = newNote.copyWith(
        title: 'Updated Note Title',
        content: 'Updated note content',
        modifiedTime: DateTime.now(),
      );

      noteBloc.add(UpdateNote(updatedNote));
      await tester.pumpAndSettle();

      expect(noteBloc.state, isA<SuccessState>());
      expect(
          (noteBloc.state as SuccessState).message, equals(UPDATE_SUCCESS_MSG));

      // Step 3: Load list of notes and verify the updated note is present
      noteBloc.add(RefreshNotes(DrawerSelect.drawerSection));
      await tester.pumpAndSettle();

      expect(noteBloc.state, isA<NotesViewState>());
      expect(
          (noteBloc.state as NotesViewState).otherNotes, contains(updatedNote));
    });

    testWidgets('Delete Note and Verify Removal', (WidgetTester tester) async {
      // Step 1: Add a new note
      final newNote = Note(
        id: '4',
        title: 'Note to Delete',
        content: 'This note will be deleted',
        colorIndex: 3,
        modifiedTime: DateTime.now(),
        stateNote: StatusNote.undefined,
      );

      noteBloc.add(AddNote(newNote));
      await tester.pumpAndSettle();

      expect(noteBloc.state, isA<SuccessState>());
      expect((noteBloc.state as SuccessState).message, equals(ADD_SUCCESS_MSG));

      // Step 2: Delete the note
      noteBloc.add(DeleteNote(newNote.id));
      await tester.pumpAndSettle();

      expect(noteBloc.state, isA<SuccessState>());
      expect(
          (noteBloc.state as SuccessState).message, equals(DELETE_SUCCESS_MSG));

      // Step 3: Load list of notes and verify the note is removed
      noteBloc.add(RefreshNotes(DrawerSelect.drawerSection));
      await tester.pumpAndSettle();

      expect(noteBloc.state, isA<NotesViewState>());
      expect((noteBloc.state as NotesViewState).otherNotes,
          isNot(contains(newNote)));
    });
  });
}
