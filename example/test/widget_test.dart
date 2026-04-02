// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:example/main.dart';
import 'package:example/localdb.dart';

//import 'test_util.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Click existing user', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    expect(find.text('Mike'), findsOneWidget);

    final container = tester.container();
    final userList = await container.read(userListProvider.future);
    expect(userList.length, 1);
    expect(userList[0].name, 'Mike');

    // order screen
    await tester.tap(find.text('Mike'));
    await tester.pumpAndSettle();

    expect(find.text('Order (User: Mike)'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(10));

    // order list screen (one order)
    final orderListButton = find.text('View Previous Order');
    expect(orderListButton, findsOneWidget);
    await tester.tap(orderListButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('Order:'), findsOneWidget);

    // order screen
    final newOrderButton = find.text('add new order');
    expect(newOrderButton, findsOneWidget);
    await tester.tap(newOrderButton);
    await tester.pumpAndSettle();

    final sview = find.byType(SingleChildScrollView);
    expect(sview, findsOneWidget);
    final scrollable = find.descendant(
      of: sview,
      matching: find.byType(Scrollable).at(0),
    );
    final chair = find.widgetWithText(ListTile, 'chair');
    expect(chair, findsOneWidget);
    await tester.scrollUntilVisible(chair, 500, scrollable: scrollable);
    await tester.tap(chair);
    //await tester.pumpAndSettle();
    final notebook = find.widgetWithText(ListTile, 'notebook');
    expect(notebook, findsOneWidget);
    await tester.scrollUntilVisible(notebook, 500, scrollable: scrollable);
    await tester.tap(notebook);
    await tester.pumpAndSettle();

    // submit order
    final submitButton = find.text('Submit Order');
    expect(submitButton, findsOneWidget);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('Order:'), findsNWidgets(2));

  });

  testWidgets('Add new user', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    expect(find.text('John'), findsNothing);

    final textField = find.byType(TextField);
    await tester.enterText(textField, 'John');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Order (User: John)'), findsOneWidget);
    expect(find.text('Submit Order'), findsOneWidget);

    // order list screen (no order yet)
    final orderListButton = find.text('View Previous Order');
    expect(orderListButton, findsOneWidget);
    await tester.tap(orderListButton);
    await tester.pumpAndSettle();

    expect(find.text('No orders yet.'), findsOneWidget);

    // back to home screen
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('John'), findsOneWidget);

    final container = tester.container();
    final userList = await container.read(userListProvider.future);
    expect(userList.length, 2);
  });
}

Widget createApp() {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWith((ref) async {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfiNoIsolate;
        final db = AppDatabase();
        debugPrint('Opening in memory database...');
        await db.openInMemory();
        debugPrint('Database path: ${db.path}');

        ref.onDispose(() async {
          debugPrint('Closing in memory database...');
          if (ref.mounted) {
            await db.close();
          }
        });

        await setInitialContents(db);
        return db;
      }),
    ],
    child: MyApp(),
  );
}
