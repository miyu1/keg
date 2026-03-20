import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localdb.dart';

class UserListUI extends ConsumerStatefulWidget {
  const UserListUI({super.key});

  @override
  ConsumerState<UserListUI> createState() => _UserListUIState();
}

class _UserListUIState extends ConsumerState<UserListUI> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();
  List<User> _userList = [];

  @override
  void initState() {
    super.initState();

    Future(() => _refreshIndicatorKey.currentState?.show());
  }

  @override
  Widget build(BuildContext context) {
    final listView = ListView.builder(
      itemCount: _userList.length,
      itemBuilder: (context, index) {
        final user = _userList[index];
        return ListTile(
          title: Text(user.name),
          onTap: () {
            print('Tapped on user: ${user.name}');
          },
        );
      },
    );
    final refreshIndicator = RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: listView,
    );

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
    );
    final textField = TextField(
      onSubmitted: (value) async {
        if (value.isEmpty) return;
        print('user: $value');
      },
      decoration: InputDecoration(
        hintText: 'your name',
        enabledBorder: border,
        focusedBorder: border,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text('keg generator demo')),
      body: Column(
        children: [
          Text('Select or input name'),
          Expanded(child: refreshIndicator),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: textField,
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    //ref.invalidate(userListProvider);
    final userList = await ref.watch(userListProvider.future);
    setState(() {
      _userList = userList;
    });
  }
}
