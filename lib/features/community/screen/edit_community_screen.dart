import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenStateState();
}

class _EditCommunityScreenStateState
    extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void editCommunity(WidgetRef ref, CommunityModel communityModel) {
    ref
        .read(communityControllerProvider.notifier)
        .editCommunity(communityModel, profileFile, bannerFile);
  }

  @override
  Widget build(BuildContext context) {
    final communityModel =
        ref.watch(getCommunityByNameProvider(widget.name)).value!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Community'),
        actions: [
          TextButton(
            onPressed: () {
              editCommunity(ref, communityModel);
            },
            child: Text(
              'Save',
              style: TextStyle(fontSize: 19),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 250,
          child: Stack(
            children: [
              GestureDetector(
                onTap: selectBannerImage,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(20),
                  dashPattern: [10, 5],
                  color: Pallete.whiteColor,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    child: bannerFile != null
                        ? Image.file(
                            bannerFile!,
                          )
                        : Icon(
                            Icons.camera_enhance_outlined,
                            size: 60,
                          ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 20,
                child: GestureDetector(
                  onTap: selectProfileImage,
                  child: profileFile != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(profileFile!),
                          radius: 35,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(communityModel.avatar),
                          radius: 35,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
