import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/theme/pallete.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(communityNameController.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Community'),
      ),
      body: isLoading
          ? Loader()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text('Community name')),
                  SizedBox(height: 10),
                  TextField(
                    controller: communityNameController,
                    decoration: InputDecoration(
                      hintText: 'r/Community_name',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    maxLength: 21,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: createCommunity,
                    child: Text(
                      'Create community',
                      style: TextStyle(
                        fontSize: 17,
                        color: Pallete.whiteColor,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.blueColor,
                      minimumSize: Size(
                        double.infinity,
                        50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
