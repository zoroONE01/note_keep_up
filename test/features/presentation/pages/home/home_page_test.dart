import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:note_app/core/core.dart';
import 'package:note_app/features/domain/entities/note.dart';
import 'package:note_app/features/presentation/blocs/blocs.dart';
import 'package:note_app/features/presentation/pages/home/home_page.dart';
import 'package:note_app/features/presentation/pages/home/widgets/sliver_notes.dart';

import 'home_page_test.mocks.dart';

@GenerateMocks([NoteBloc, StatusIconsCubit])
void main() {
  late MockNoteBloc mockNoteBloc;
  late MockStatusIconsCubit mockStatusIconsCubit;

  setUp(() {
    mockNoteBloc = MockNoteBloc();
    mockStatusIconsCubit = MockStatusIconsCubit();
  });

  Widget buildHomePage() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteBloc>.value(value: mockNoteBloc),
        BlocProvider<StatusIconsCubit>.value(value: mockStatusIconsCubit),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }

  testWidgets(
      'HomePage should display SliverNotes when state is NotesViewState',
      (WidgetTester tester) async {
    final note1 = Note(
      id: '1',
      title: 'Note 1',
      content: 'Content 1',
      modifiedTime: DateTime.now(),
      colorIndex: 0,
      stateNote: StatusNote.undefined,
    );
    final note2 = Note(
      id: '2',
      title: 'Note 2',
      content: 'Content 2',
      modifiedTime: DateTime.now(),
      colorIndex: 1,
      stateNote: StatusNote.pinned,
    );

    when(mockNoteBloc.stream).thenAnswer(
      (_) => Stream.value(
        NotesViewState(
          [note1],
          [note2],
        ),
      ),
    );

    await tester.pumpWidget(buildHomePage());

    expect(find.byType(SliverNotes), findsOneWidget);
  });
}
