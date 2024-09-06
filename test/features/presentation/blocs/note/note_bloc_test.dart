import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:note_app/core/core.dart';
import 'package:note_app/features/domain/entities/note.dart';
import 'package:note_app/features/domain/usecases/add_note.dart';
import 'package:note_app/features/domain/usecases/detele_note.dart';
import 'package:note_app/features/domain/usecases/get_note_by_id.dart';
import 'package:note_app/features/domain/usecases/get_notes.dart';
import 'package:note_app/features/domain/usecases/update_note.dart';
import 'package:note_app/features/presentation/blocs/blocs.dart';

import 'note_bloc_test.mocks.dart';

@GenerateMocks([
  GetNotesUsecase,
  GetNoteByIdUsecase,
  AddNoteUsecase,
  UpdateNoteUsecase,
  DeleteNoteUsecase,
])
void main() {
  late NoteBloc noteBloc;
  late MockGetNotesUsecase mockGetNotes;
  late MockGetNoteByIdUsecase mockGetNoteById;
  late MockAddNoteUsecase mockAddNote;
  late MockUpdateNoteUsecase mockUpdateNote;
  late MockDeleteNoteUsecase mockDeleteNote;

  setUp(() {
    mockGetNotes = MockGetNotesUsecase();
    mockGetNoteById = MockGetNoteByIdUsecase();
    mockAddNote = MockAddNoteUsecase();
    mockUpdateNote = MockUpdateNoteUsecase();
    mockDeleteNote = MockDeleteNoteUsecase();

    noteBloc = NoteBloc(
      getNotes: mockGetNotes,
      getNoteById: mockGetNoteById,
      addNote: mockAddNote,
      updateNote: mockUpdateNote,
      deleteNote: mockDeleteNote,
    );
  });

  tearDown(() {
    noteBloc.close();
  });

  group('AddNote', () {
    final tNote = Note(
      id: '1',
      title: 'Test Note',
      content: 'This is a test note',
      modifiedTime: DateTime.now(),
      stateNote: StatusNote.undefined,
      colorIndex: 0,
    );

    test('should emit [SuccessState] when adding a note is successful',
        () async {
      // Arrange
      when(mockAddNote(any)).thenAnswer((_) async => const Right(unit));

      // Act
      noteBloc.add(AddNote(tNote));

      // Assert
      await expectLater(
        noteBloc.stream,
        emits(const SuccessState(ADD_SUCCESS_MSG)),
      );
    });

    test('should emit [ErrorState] when adding a note fails', () async {
      // Arrange
      when(mockAddNote(any)).thenAnswer((_) async => Left(DatabaseFailure()));

      // Act
      noteBloc.add(AddNote(tNote));

      // Assert
      await expectLater(
        noteBloc.stream,
        emits(ErrorState(DATABASE_FAILURE_MSG, DrawerSelect.drawerSection)),
      );
    });
  });
  group('UpdateNote', () {
    final tNote = Note(
      id: '1',
      title: 'Updated Test Note',
      content: 'This is an updated test note',
      modifiedTime: DateTime.now(),
      stateNote: StatusNote.undefined,
      colorIndex: 0,
    );

    test('should emit [SuccessState] when updating a note is successful',
        () async {
      // Arrange
      when(mockUpdateNote(any)).thenAnswer((_) async => const Right(unit));

      // Act
      noteBloc.add(UpdateNote(tNote));

      // Assert
      await expectLater(
        noteBloc.stream,
        emits(const SuccessState(UPDATE_SUCCESS_MSG)),
      );
    });

    test('should emit [ErrorState] when updating a note fails', () async {
      // Arrange
      when(mockUpdateNote(any))
          .thenAnswer((_) async => Left(DatabaseFailure()));

      // Act
      noteBloc.add(UpdateNote(tNote));

      // Assert
      await expectLater(
        noteBloc.stream,
        emits(ErrorState(DATABASE_FAILURE_MSG, DrawerSelect.drawerSection)),
      );
    });
  });
  group('DeleteNote', () {
    const tNoteId = '1';

    test('should emit [SuccessState] when deleting a note is successful',
        () async {
      // Arrange
      when(mockDeleteNote(any)).thenAnswer((_) async => const Right(unit));

      // Act
      noteBloc.add(const DeleteNote(tNoteId));

      // Assert
      await expectLater(
        noteBloc.stream,
        emitsInOrder([
          const SuccessState(DELETE_SUCCESS_MSG),
          isA<GoPopNoteState>(),
        ]),
      );
    });

    test('should emit [ErrorState] when deleting a note fails', () async {
      // Arrange
      when(mockDeleteNote(any))
          .thenAnswer((_) async => Left(DatabaseFailure()));

      // Act
      noteBloc.add(const DeleteNote(tNoteId));

      // Assert
      await expectLater(
        noteBloc.stream,
        emitsInOrder([
          ErrorState(DATABASE_FAILURE_MSG, DrawerSelect.drawerSection),
          isA<GoPopNoteState>(),
        ]),
      );
    });
  });
}
