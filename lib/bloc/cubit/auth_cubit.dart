import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:optiparck/widgets/datasources.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  singInEvent(Client user) async {
    try {
      emit(LoadingAuthState());
      await _auth.signInWithEmailAndPassword(
          email: user.userEmail, password: user.userPassword);
      emit(IsSignInState());
    } catch (e) {
      emit(ErrorSignInState());
    }
  }

  singUpEvent(Client user) async {
    await _auth.createUserWithEmailAndPassword(
      email: user.userEmail,
      password: user.userPassword,
    );
    return addUser(
      Client(
        phoneNumber: user.phoneNumber,
        userEmail: user.userEmail,
        userPassword: user.userPassword,
        userphoto: user.userphoto,
        userName: user.userName,
        userId: _auth.currentUser!.uid,
        userPrenom: user.userPrenom ?? '',
      ),
    );
  }

  singGoogleEvent() {}

  singOutEvent() {
    try {
      _auth.signOut();
      emit(SignOutState());
    } catch (e) {
      emit(ErrorSignInState());
    }
  }

  addUser(Client user) {
    _database.ref().child('Users').set({'email': user.userEmail});
    emit(IsSignInState());
  }

  internetConnectEvent() {
    emit(InternetConnectState());
  }

  internetDeconnectEvent() {
    emit(InternetDesconnectState());
  }
}
