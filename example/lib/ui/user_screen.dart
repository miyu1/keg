import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localdb.dart';
import '../router.dart';

class UserScreen extends ConsumerWidget {
  const UserScreen({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(name));
    Widget body = Text('initial');
    userAsync.when(
      data: (data) {
        body = _userWidget(ref, data);
      },
      error: (error, stack) {
        body = Text('Error: $error $stack');
      },
      loading: () {
        body = Align(
          alignment: Alignment.topLeft,
          child: CircularProgressIndicator(),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text('Order History (User: $name)')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              child: Text('add new order'),
              onPressed: () {
                OrderRoute(name).go(context);
              },
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  Widget _userWidget(WidgetRef ref, User user) {
    final columns = <Widget>[];

    for (final order in user.orderList) {
      columns.add(Text('Order: ${order.created}'));
      final items = order.itemList
          .map((item) => ListTile(title: Text(item.name)))
          .toList();
      columns.add(
        Card(
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: items,
          ),
        ),
      );
    }
    if (user.orderList.isEmpty) {
      columns.add(Center(child: Text('No orders yet.')));
    }
    final scrollView = SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(children: columns),
    );

    final refreshIndicator = RefreshIndicator(
      //key: _refreshIndicatorKey,
      onRefresh: () async {
        //print('refreshing user data for ${user.name}');
        // ignore: unused_result
        await ref.refresh(userProvider(name).future);
      },
      child: scrollView,
    );

    return refreshIndicator;
  }
}
