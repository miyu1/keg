import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'ui/home_screen.dart';
import 'ui/user_screen.dart';
import 'ui/order_screen.dart';

part 'router.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<UserRoute>(path: 'user/:name/history'),
    TypedGoRoute<OrderRoute>(path: 'user/:name/new_order'),
  ],
)
// home route - add/select user
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

// user route - show order history for the user
class UserRoute extends GoRouteData with $UserRoute {
  const UserRoute(this.name);

  final String name;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      UserScreen(name: name);
}

// order route - add new order for the user
class OrderRoute extends GoRouteData with $OrderRoute {
  const OrderRoute(this.name);

  final String name;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
    OrderScreen(name: name);
}

@riverpod
GoRouter router(Ref ref) {
  final router = GoRouter(
    routes: $appRoutes,
    // errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );

  ref.onDispose(router.dispose);

  return router;
}

