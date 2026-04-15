import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:example/main.dart';
import 'package:example/localdb.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  String path = '';
  tearDownAll(() async {
    // Clean up the database file after all tests are done
    if (path.isNotEmpty) {
      final dbFile = File(path);
      if (await dbFile.exists()) {
        debugPrint('Deleting database file: $path');
        await dbFile.delete();
      }
    }
  });

  testWidgets('Select existing user', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    final container = tester.container();
    final appdb = await container.read(appDatabaseProvider.future);
    path = appdb.path;
    debugPrint('Database path: $path');

    expect(find.text('Mike'), findsOneWidget);

    // order screen
    await tester.tap(find.text('Mike'));
    await tester.pumpAndSettle();
    expect(find.text('Order (User: Mike)'), findsOneWidget);

    final phone = find.widgetWithText(ListTile, 'smart phone');
    expect(phone, findsOneWidget);
    await tester.tap(phone);
    final light = find.widgetWithText(ListTile, 'light');
    expect(light, findsOneWidget);
    await tester.tap(light);
    await tester.pumpAndSettle();

    // submit order
    final submitButton = find.text('Submit Order');
    expect(submitButton, findsOneWidget);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('Order:'), findsNWidgets(2));

  });
}

Widget createApp() {
  return ProviderScope(overrides: [], child: MyApp());
}
