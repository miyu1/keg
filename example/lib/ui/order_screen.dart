import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../localdb.dart';
import '../router.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key, required this.name});

  final String name;

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  final Map<String, Item> _selectedItems = {};

  @override
  Widget build(BuildContext context) {
    final categoryListSync = ref.watch(categoryListProvider);
    Widget body = Text('initial');
    categoryListSync.when(
      data: (data) {
        body = _categoryListWidget(context, data);
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

    final submitButton = ElevatedButton(
      onPressed: _selectedItems.isEmpty
          ? null
          : () async {
              final user = await ref.watch(userProvider(widget.name).future);
              final order = Order(user: user);
              order.itemList = _selectedItems.values.toList();
              final appdb = await ref.watch(appDatabaseProvider.future);
              await appdb.registerOrder(order);
              ref.invalidate(userProvider(widget.name));
              if (context.mounted) {
                UserRoute(widget.name).go(context);
              }
            },
      child: Text('Submit Order'),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Order (User: ${widget.name})')),
      body: SafeArea(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                UserRoute(widget.name).go(context);
              },
              child: Text('View Previous Order'),
            ),
            Expanded(child: body),
            Padding(padding: EdgeInsets.all(16.0), child: submitButton),
          ],
        ),
      ),
    );
  }

  Widget _categoryListWidget(
    BuildContext context,
    List<Category> categoryList,
  ) {
    final columns = <Widget>[];
    final theme = Theme.of(context);

    for (final category in categoryList) {
      columns.add(Text(category.name, style: theme.textTheme.headlineSmall));
      final items = category.itemList
          .map((item) => _buildItemTile(item))
          .toList();
      columns.add(
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: items,
        ),
      );
    }
    final scrollView = SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(children: columns),
    );

    final refreshIndicator = RefreshIndicator(
      onRefresh: () async {
        //print('refreshing user data for ${user.name}');
        // ignore: unused_result
        await ref.refresh(categoryListProvider.future);
      },
      child: scrollView,
    );

    return refreshIndicator;
  }

  Widget _buildItemTile(Item item) {
    final isSelected = _selectedItems.containsKey(item.name);
    var rating = 0.0;
    if (item.orderList.length >= 5) {
      rating = 3.0;
    } else if (item.orderList.length >= 3) {
      rating = 2.0;
    } else if (item.orderList.isNotEmpty) {
      rating = 1.0;
    }
    final ratingWidget = RatingBar.builder(
      initialRating: rating,
      itemCount: 3,
      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
      ignoreGestures: true,
      onRatingUpdate: (rating) {},
    );

    return ListTile(
      title: Text(item.name),
      leading: Checkbox(
        value: isSelected,
        onChanged: (value) {
          setState(() {
            if (value == true) {
              _selectedItems[item.name] = item;
            } else {
              _selectedItems.remove(item.name);
            }
          });
        },
      ),
      trailing: ratingWidget,
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedItems.remove(item.name);
          } else {
            _selectedItems[item.name] = item;
          }
        });
      },
    );
  }
}
