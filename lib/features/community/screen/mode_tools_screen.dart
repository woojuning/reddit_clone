// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ModeToolsScreen extends ConsumerWidget {
  final String name;
  const ModeToolsScreen({
    required this.name,
  });

  void navigateToEditScreen(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mode Tools'),
        ),
        body: Column(
          children: [
            ListTile(
              leading: Icon(Icons.add_moderator),
              title: Text('Add Moderators'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('edit Community'),
              onTap: () {
                navigateToEditScreen(context);
              },
            ),
          ],
        ));
  }
}
