// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/provider/firebase_provider.dart';
import 'package:reddit/core/typedef.dart';
import 'package:reddit/models/user_model.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
      firebaseFirestore: ref.watch(firebaseFirestorProvider),
      auth: ref.watch(authProvider),
      googleSignIn: ref.watch(googleSignInProvider));
});

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  AuthRepository({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _firestore = firebaseFirestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserModel userModel; //나중에 다시 값을 대입하겠다고 선언

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No Name',
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: [],
        );
        await _users
            .doc(userCredential.user!.uid)
            .set(userModel.toMap()); //다큐먼트 만드는 것
      } else {
        userModel = await getuserData(userCredential.user!.uid)
            .first; //첫번째 요소가 넘어온다음에 스트림이 종료
      }

      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getuserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void signOut() async {
    await _auth.signOut();
  }
}
