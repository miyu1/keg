import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localdb.dart';
import '../router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userListAsync = ref.watch(userListProvider);
    Widget body = Text('initial');
    userListAsync.when(
      data: (data) {
        body = _userListWidget(context, data);
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


    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey),
    );
    final textField = TextField(
      controller: textController,
      onSubmitted: (value) async {
        if (value.isEmpty) return;
        //print('user: $value');
        final appdb = await ref.watch(appDatabaseProvider.future);
        await appdb.transaction((txn) async {
          final existingUser = await txn.queryUser(
            where: '${appdb.userHelper.column.name} = ?',
            whereArgs: [value],
          );
          if (existingUser.isEmpty) {
            final user = User(value);
            await txn.registerUser(user);
            ref.invalidate(userListProvider);
          }
        });
        textController.clear();
        if (context.mounted) {
          OrderRoute(value).go(context);
        }
      },
      decoration: InputDecoration(
        hintText: 'your name',
        enabledBorder: border,
        focusedBorder: border,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('keg generator demo')),
      body: SafeArea(
        child: Column(
          children: [
            Text('Select or input name'),
            Expanded(child: body),
            Padding(padding: const EdgeInsets.all(8.0), child: textField),
          ],
        ),
      ),
    );
  }

  Widget _userListWidget(BuildContext context, List<User> userList) {
    final listview = ListView.builder(
      itemCount: userList.length,
      itemBuilder: (context, index) {
        final user = userList[index];
        return ListTile(
          title: Text(user.name),
          onTap: () {
            OrderRoute(user.name).go(context);
            //UserRoute(user.name).go(context);
          },
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final appdb = await ref.watch(appDatabaseProvider.future);
              await appdb.transaction((txn) async {
                final qUser = await txn.getUser(user.id);
                if (qUser == null) return;
                await txn.deleteOrderByIds(qUser.orderList);
                await txn.deleteUserByIds([qUser]);
                ref.invalidate(userListProvider);
                ref.invalidate(userProvider(qUser.name));
              });
              if (context.mounted) { 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User ${user.name} deleted')),
                );
              }
            },
          ),
        );
      },
    );

    final refreshIndicator = RefreshIndicator(
      onRefresh: () async => ref.refresh(userListProvider.future),
      child: listview,
    );

    return refreshIndicator;
  }
}

