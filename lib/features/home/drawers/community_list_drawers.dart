import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToTestScreen(BuildContext context) {
    Routemaster.of(context).push('/test-screen');
  }

  void navigateToCommunityScreen(
      BuildContext context, CommunityModel communityModel) {
    Routemaster.of(context).push('/r/${communityModel.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: Switch(
                value: ref.watch(themeModeProvider),
                onChanged: (value) {
                  ref.read(themeModeProvider.notifier).update((state) => value);
                },
              ),
              title: Text('Theme Mode'),
            ),
            ListTile(
              title: Text('Test'),
              leading: Icon(Icons.add),
              onTap: () {
                navigateToTestScreen(context);
              },
            ),
            ListTile(
              title: Text('Create Community List'),
              leading: Icon(Icons.add),
              onTap: () {
                navigateToCreateCommunity(context);
              },
            ),
            Expanded(
              child: ref.watch(userCommunitiesProvider).when(
                    data: (communties) {
                      return ListView.builder(
                        itemCount: communties.length,
                        itemBuilder: (context, index) {
                          final community = communties[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                            ),
                            title: Text('r/${community.name}'),
                            onTap: () {
                              navigateToCommunityScreen(context, community);
                            },
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) =>
                        ErrorText(text: error.toString()),
                    loading: () => Loader(),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
