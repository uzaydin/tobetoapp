import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/models/user_enum.dart';



class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<String?> getUserRole(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    return snapshot.data()?['role'];
  }

  Future<User?> loggedInUser(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<User?> signUp(String name, String lastName, String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
      final userModel = UserModel(
        id: user.uid,
        firstName: name,
        lastName: lastName,
        email: email,
        role: UserRole.student, // Varsayılan rol
      );
      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
    }
    return user;
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      // Kullanıcı Google hesabı seçmeden çıkış yaptı
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    if (userCredential.user != null) {
      final User user = userCredential.user!;
      final userDoc = await _firestore.collection("users").doc(user.uid).get();
      if (!userDoc.exists) {
        // Kullanıcı Firestore'da kayıtlı değilse yeni kayıt oluştur
        UserModel newUser = UserModel(
          firstName: googleUser.displayName ?? '',
          lastName: '',
          email: googleUser.email,
          role: UserRole.student, // default olarak student kaydı yapılıyor.
        );
        await _firestore.collection("users").doc(user.uid).set(newUser.toMap());
      }
      return user;
    } else {
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
