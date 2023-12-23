import 'package:equatable/equatable.dart';

class Client extends Equatable {
  final String userName;
  final String userId;
  final String? userPrenom;
  final String userEmail;
  final String userPassword;
  final String? userphoto;
  final String? phoneNumber;

  const Client(
      {required this.userName,
      required this.userId,
      this.userPrenom,
      required this.userEmail,
      required this.userPassword,
      this.userphoto,
      this.phoneNumber});

  Map<String, dynamic> clientToMap() {
    return {
      "phoneNumber": phoneNumber,
      "userEmail": userEmail,
      "userPassword": userPassword,
      "userphoto": userphoto,
      "userName": userName,
      "userId": userId,
      "userPrenom": userPrenom ?? '',
    };
  }

  @override
  List<Object?> get props => [
        userName,
        userId,
        userPrenom,
        userEmail,
        userPassword,
        userphoto,
        phoneNumber
      ];
}




// class UserDataSourcesImpl1 implements UserDataSources {

//   @override
//   Future<void> signIn(Usr usr) async {
//     await _auth.signInWithEmailAndPassword(
//         email: usr.email, password: usr.password!);
//   }

//   @override
//   Future<void> signUp(Usr usr) async {
//     await _auth.createUserWithEmailAndPassword(
//       email: usr.email,
//       password: usr.password!,
//     );
//     final user = _auth.currentUser;
//     return addUser(Usr(
//         adress: "adress",
//         payes: "payes",
//         phoneNumber: usr.phoneNumber,
//         email: usr.email,
//         password: usr.password,
//         profileUrl: usr.profileUrl,
//         name: usr.name,
//         uid: user!.uid));
//   }

//   @override
//   Future<void> singOut() async {
//     await _auth.signOut();
//   }

//   @override
//   Future<void> signInWithGoogle() async {
//     final GoogleSignIn googleSignIn = GoogleSignIn();

//     // Attempt to sign in silently
//     final GoogleSignInAccount? googleSignInAccount =
//         await googleSignIn.signIn();
//     if (googleSignInAccount != null) {
//       // If sign in silently is successful, get authentication credentials
//       final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount.authentication;
//       // Create AuthCredential using Google Sign-In credentials
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );
//       final user = await FirebaseAuth.instance.signInWithCredential(credential);

//       return addUser(Usr(
//         adress: "",
//         payes: "",
//         email: user.user!.email!,
//         password: "",
//         name: user.user!.displayName!,
//         uid: user.user!.uid,
//         phoneNumber: user.user!.phoneNumber,
//         profileUrl: user.user!.photoURL,
//       ));
//     }
//   }

//   Future<void> addUser(Usr user) async {
//     await _firebase.collection('Users').doc(user.uid).set(UserModel(
//             uid: user.uid,
//             name: user.name,
//             phoneNumber: user.phoneNumber,
//             adress: user.adress,
//             payes: user.payes,
//             email: user.email,
//             password: user.password,
//             profileUrl: '')
//         .toMap());
//   }
// }