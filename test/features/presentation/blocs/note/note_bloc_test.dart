import 'package:bloc_test/bloc_test.dart';
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
  late MockGetNotesUsecase mockGetNotesUsecase;
  late MockGetNoteByIdUsecase mockGetNoteByIdUsecase;
  late MockAddNoteUsecase mockAddNoteUsecase;
  late MockUpdateNoteUsecase mockUpdateNoteUsecase;
  late MockDeleteNoteUsecase mockDeleteNoteUsecase;
  late NoteBloc bloc;

  setUp(() {
    mockGetNotesUsecase = MockGetNotesUsecase();
    mockGetNoteByIdUsecase = MockGetNoteByIdUsecase();
    mockAddNoteUsecase = MockAddNoteUsecase();
    mockUpdateNoteUsecase = MockUpdateNoteUsecase();
    mockDeleteNoteUsecase = MockDeleteNoteUsecase();

    bloc = NoteBloc(
      getNotes: mockGetNotesUsecase,
      getNoteById: mockGetNoteByIdUsecase,
      addNote: mockAddNoteUsecase,
      updateNote: mockUpdateNoteUsecase,
      deleteNote: mockDeleteNoteUsecase,
    );
  });

  group('AddNote Event', () {
    final tNote = Note(
      id: '1',
      title: 'title',
      content: 'content',
      modifiedTime: DateTime.now(),
      colorIndex: 0,
      stateNote: StatusNote.undefined,
    );

    blocTest<NoteBloc, NoteState>(
      'should emit [LoadingState, SuccessState] when add note is successful',
      build: () {
        when(mockAddNoteUsecase.call(any))
            .thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act: (bloc) => bloc.add(AddNote(tNote)),
      expect: () => [
        // LoadingState(DrawerSelect.drawerSection), // You might not need this state if you're not showing a loading indicator
        const SuccessState(ADD_SUCCESS_MSG),
      ],
    );

    blocTest<NoteBloc, NoteState>(
      'should emit [LoadingState, ErrorState] when add note fails',
      build: () {
        when(mockAddNoteUsecase.call(any))
            .thenAnswer((_) async => Left(DatabaseFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(AddNote(tNote)),
      expect: () => [
        // LoadingState(DrawerSelect.drawerSection), // You might not need this state if you're not showing a loading indicator
        ErrorState(DATABASE_FAILURE_MSG, DrawerSelect.drawerSection),
      ],
    );
  });
  group('UpdateNote', () {
    final tNote = Note(
      id: '1',
      title: 'Updated Test Note',
      content: 'This is an updated test note',
      colorIndex: 1,
      stateNote: StatusNote.undefined,
      modifiedTime: DateTime.now(),
    );

    blocTest<NoteBloc, NoteState>(
      'emits [LoadingState, SuccessState] when note is updated successfully',
      build: () {
        when(mockUpdateNoteUsecase(any))
            .thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateNote(tNote)),
      expect: () => [
        const SuccessState(UPDATE_SUCCESS_MSG),
      ],
    );

    blocTest<NoteBloc, NoteState>(
      'emits [LoadingState, ErrorState] when updating note fails',
      build: () {
        when(mockUpdateNoteUsecase(any))
            .thenAnswer((_) async => Left(DatabaseFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateNote(tNote)),
      expect: () => [
        ErrorState(DATABASE_FAILURE_MSG, DrawerSelect.drawerSection),
      ],
    );
  });
  group('DeleteNote', () {
    const tNoteId = '1';

    blocTest<NoteBloc, NoteState>(
      'emits [LoadingState, SuccessState, GoPopNoteState] when note is deleted successfully',
      build: () {
        when(mockDeleteNoteUsecase(any))
            .thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteNote(tNoteId)),
      expect: () => [
        const SuccessState(DELETE_SUCCESS_MSG),
        GoPopNoteState(),
      ],
    );

    blocTest<NoteBloc, NoteState>(
      'emits [LoadingState, ErrorState] when deleting note fails',
      build: () {
        when(mockDeleteNoteUsecase(any))
            .thenAnswer((_) async => Left(DatabaseFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteNote(tNoteId)),
      expect: () => [
        ErrorState(DATABASE_FAILURE_MSG, DrawerSelect.drawerSection),
        GoPopNoteState(),
      ],
    );
  });

  group('DeleteNote', () {
    const tNoteId = '1';

    blocTest<NoteBloc, NoteState>(
      'emits [LoadingState, SuccessState, GoPopNoteState] when note is deleted successfully',
      build: () {
        when(mockDeleteNoteUsecase(any))
            .thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteNote(tNoteId)),
      expect: () => [
        const SuccessState(DELETE_SUCCESS_MSG),
        GoPopNoteState(),
      ],
    );

    blocTest<NoteBloc, NoteState>(
      'emits [LoadingState, ErrorState] when deleting note fails',
      build: () {
        when(mockDeleteNoteUsecase(any))
            .thenAnswer((_) async => Left(DatabaseFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteNote(tNoteId)),
      expect: () => [
        ErrorState(DATABASE_FAILURE_MSG, DrawerSelect.drawerSection),
        GoPopNoteState(),
      ],
    );
  });
}
