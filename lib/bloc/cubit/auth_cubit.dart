import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:optiparck/widgets/Client.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  getUserEvent() async {
    try {
      String userId = _auth.currentUser!.uid;

      DataSnapshot dataSnapshot =
          await _database.ref().child("Users").child(userId).get();

      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> data =
            dataSnapshot.value as Map<dynamic, dynamic>;

        Client user = Client(
          userPrenom: data["userPrenom"] ?? "",
          userName: data["userName"] ?? "",
          userId: userId,
          userEmail: data["userEmail"] ?? "",
          userPassword: data["userPassword"] ?? "",
          userphoto: data["userphoto"] ?? "",
          phoneNumber: data["phoneNumber"] ?? 0,
        );

        emit(IsSignInState(user: user));
      } else {
        emit(ErrorSignInState());
      }
    } catch (e) {
      print("Error: $e");
      emit(ErrorSignInState());
    }
  }

//   getUserEvent() async {
//     try {
//       DataSnapshot dataSnapshot = await _database
//           .ref()
//           .child("Users")
//           .child(_auth.currentUser!.uid)
//           .get();

//       var user = dataSnapshot.children.map((evve) {
//         Map<dynamic, dynamic> data = evve.value as Map<dynamic, dynamic>;

//         return Client(
//           userPrenom: data["userPrenom"] ?? "",
//           userName: data["userName"] ?? "",
//           userId: evve.key!,
//           userEmail: data["userEmail"] ?? "",
//           userPassword: data["userPassword"] ?? "",
//           userphoto: data["userphoto"] ?? "",
//           phoneNumber: data["phoneNumber"] ?? "",
//         );
//       }).toList();
//       emit(IsSignInState(user: user.first));
//     } catch (e) {
//       emit(ErrorSignInState());
//     }
//   }

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

  singGoogleEvent() {}

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
        .ref()
        .child('Users')
        .child(_auth.currentUser!.uid)
        .set(user.toMap());
  }

  internetConnectEvent() {
    emit(InternetConnectState());
  }

  internetDeconnectEvent() {
    emit(InternetDesconnectState());
  }
}
