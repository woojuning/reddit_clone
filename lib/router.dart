// loggedOut

//loggedIn

import 'package:flutter/material.dart';
import 'package:reddit/features/auth/view/login_view.dart';
import 'package:reddit/features/community/screen/community_screen.dart';
import 'package:reddit/features/community/screen/create_community_screen.dart';
import 'package:reddit/features/community/screen/edit_community_screen.dart';
import 'package:reddit/features/community/screen/mode_tools_screen.dart';
import 'package:reddit/features/community/screen/test_screen.dart';
import 'package:reddit/features/home/screen/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (route) => MaterialPage(child: LoginView()),
});

final loggedInRoute = RouteMap(
  routes: {
    '/': (route) => MaterialPage(child: HomeScreen()),
    '/create-community': (route) =>
        MaterialPage(child: CreateCommunityScreen()),
    '/r/:name': (route) => MaterialPage(
        child: CommunityScreen(name: route.pathParameters['name']!)),
    '/mod-tools/:name': (route) => MaterialPage(
        child: ModeToolsScreen(name: route.pathParameters['name']!)),
    '/edit-community/:name': (route) => MaterialPage(
        child: EditCommunityScreen(name: route.pathParameters['name']!)),
    '/test-screen': (route) => MaterialPage(child: TestScreen()),
  },
);
