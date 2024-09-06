import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/core.dart';
import 'package:note_app/features/presentation/blocs/note/note_bloc.dart';
import 'package:note_app/features/presentation/pages/home/home_page.dart';
import 'package:note_app/features/presentation/pages/home/widgets/sliver_notes.dart';

import '../features/presentation/pages/home/home_page_test.mocks.dart';

@GenerateMocks([NoteBloc])
void main() {
  late MockNoteBloc mockNoteBloc;

  setUp(() {
    mockNoteBloc = MockNoteBloc();
  });

  testWidgets('HomePage displays loading state', (WidgetTester tester) async {
    when(mockNoteBloc.state)
        .thenReturn(const LoadingState(DrawerSectionView.home));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<NoteBloc>.value(
          value: mockNoteBloc,
          child: const HomePage(),
        ),
      ),
    );

    expect(find.byType(CommonLoadingNotes), findsOneWidget);
  });

  testWidgets('HomePage displays empty state', (WidgetTester tester) async {
    when(mockNoteBloc.state)
        .thenReturn(const EmptyNoteState(DrawerSectionView.home));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<NoteBloc>.value(
          value: mockNoteBloc,
          child: const HomePage(),
        ),
      ),
    );

    expect(find.byType(CommonEmptyNotes), findsOneWidget);
  });

  testWidgets('HomePage displays notes view state',
      (WidgetTester tester) async {
    when(mockNoteBloc.state).thenReturn(const NotesViewState([], []));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<NoteBloc>.value(
          value: mockNoteBloc,
          child: const HomePage(),
        ),
      ),
    );

    expect(find.byType(SliverNotes), findsOneWidget);
    expect(find.byType(CommonNotesView), findsOneWidget);
  });

  testWidgets('HomePage displays floating action button',
      (WidgetTester tester) async {
    when(mockNoteBloc.state).thenReturn(const NotesViewState([], []));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<NoteBloc>.value(
          value: mockNoteBloc,
          child: const HomePage(),
        ),
      ),
    );

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
