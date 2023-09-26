import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/provider/storage_repository.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/repository/community_repository.dart';
import 'package:reddit/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

//communtiy를 name에 맞는 document를 가져오는 streamprovider
final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getCommunityByName(name);
});

final userCommunitiesProvider = StreamProvider((ref) {
  final communtiyController = ref.watch(communityControllerProvider.notifier);
  return communtiyController.getUserCommunities();
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
    communityRepository: communityRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    String uid = _ref.watch(userProvider)?.uid ?? '';
    CommunityModel communityModel = CommunityModel(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );
    final res = await _communityRepository.createCommunity(communityModel);
    if (mounted) state = false;

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'community created successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  void editCommunity(CommunityModel communityModel, File? profileFile,
      File? bannerFile) async {
    //1. profileDownLoadPath를 storage로 부터 얻는다.
    state = true;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'communities/profile/',
          id: communityModel.name,
          file: profileFile);
      res.fold((l) => null, (downLoadPath) {
        communityModel = communityModel.copyWith(avatar: downLoadPath);
      });
    }
    //2. bannerDownLoadPath또한 얻는다.
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'communities/banner/',
          id: communityModel.name,
          file: bannerFile);
      res.fold((l) => null, (downLoadPath) {
        communityModel = communityModel.copyWith(banner: downLoadPath);
      });
    }
    state = false;
    //4. communityRepository의 매개변수로 넘겨서 업데이트한다. 그 결과값을 처리한다.
    final res = await _communityRepository.editCommunity(communityModel);

    res.fold((l) => null, (r) => null);

    //3. 받아온 communityModel의 avatar와 banner의 값을 변경한다.
  }

  Stream<List<CommunityModel>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }
}
