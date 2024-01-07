import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:optiparck/widgets/Client.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  getUserEvent() async {
    try {
      String userId = _auth.currentUser!.uid;

      var dataSnapshot = await _database.collection("Users").doc(userId).get();

      Client user = Client(
        userPrenom: dataSnapshot["userPrenom"] ?? "",
        userName: dataSnapshot["userName"] ?? "",
        userId: userId,
        userEmail: dataSnapshot["userEmail"] ?? "",
        userPassword: dataSnapshot["userPassword"] ?? "",
        userphoto: dataSnapshot["userphoto"] ?? "",
        phoneNumber: dataSnapshot["phoneNumber"] ?? 0,
      );

      emit(IsSignInState(user: user));
    } catch (e) {
      print("Error: $e");
      emit(ErrorSignInState());
    }
  }

  singInEvent(Client user) async {
    try {
      emit(LoadingAuthState());
      await _auth.signInWithEmailAndPassword(
          email: user.userEmail, password: user.userPassword);
      emit(const IsSignInState(
          user: Client(
              userName: "userName",
              userId: " userId",
              userEmail: "userEmail",
              userPassword: "userPassword")));
    } catch (e) {
      emit(ErrorSignInState());
    }
  }

  singUpEvent(Client user) async {
    try {
      emit(LoadingAuthState());
      await _auth.createUserWithEmailAndPassword(
        email: user.userEmail,
        password: user.userPassword,
      );

      emit(IsSignUpState());
      return addUser(user);
    } catch (e) {
      emit(ErrorSignInState());
    }
  }

  Future<void> signInWithGoogle() async {
    emit(LoadingAuthState());
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Attempt to sign in silently
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      // If sign in silently is successful, get authentication credentials
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      // Create AuthCredential using Google Sign-In credentials
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final user = await FirebaseAuth.instance.signInWithCredential(credential);
      final userinfo = user.user;
      emit(IsSignInState(
          user: Client(
              userName: userinfo!.displayName ?? "User",
              userId: userinfo.uid,
              userEmail: userinfo.email!,
              userPassword: "",
              phoneNumber: int.parse(userinfo.phoneNumber ?? "610101010"))));

      return addUser(Client(
          userName: userinfo.displayName ?? "User",
          userId: userinfo.uid,
          userEmail: userinfo.email!,
          userPassword: "",
          phoneNumber: int.parse(userinfo.phoneNumber ?? "610101010")));
    }
  }

  singOutEvent() async {
    try {
      await _auth.signOut();
      emit(SignOutState());
    } catch (e) {
      emit(ErrorSignInState());
    }
  }

  addUser(Client user) async {
    await _database
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .set(user.toMap());
  }
}
