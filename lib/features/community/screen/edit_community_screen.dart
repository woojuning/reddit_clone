// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
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

  void save(CommunityModel communityModel) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          communityModel: communityModel,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Edit Community'),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () {
                      save(community);
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              body: isLoading
                  ? Loader()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: selectBannerImage,
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(10),
                                    dashPattern: [10, 4],
                                    color: Pallete.whiteColor,
                                    strokeCap: StrokeCap.round,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: bannerFile != null
                                          ? Image.file(bannerFile!)
                                          : community.banner.isEmpty ||
                                                  community.banner ==
                                                      Constants.bannerDefault
                                              ? Center(
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 50,
                                                  ),
                                                )
                                              : Image.network(community.banner),
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
                                            backgroundImage:
                                                FileImage(profileFile!),
                                            radius: 32,
                                          )
                                        : CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(community.avatar),
                                            radius: 32,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          },
          error: (error, stackTrace) => ErrorText(text: error.toString()),
          loading: () => Loader(),
        );
  }
}
