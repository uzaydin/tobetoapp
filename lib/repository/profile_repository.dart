import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tobetoapp/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;

  ProfileRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
    FirebaseStorage? firebaseStorage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future<UserModel> getCurrentUserDetails() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final snapshot = await _firestore.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!);
      }
    }
    throw Exception("No user logged in or user data not found");
  }

  Future<void> updateUserProfile(UserModel userModel) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(userModel.toMap());
    }
  }

  Future<String?> pickAndUploadProfileImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final user = _firebaseAuth.currentUser;
        if (user != null) {
          final storageRef = _firebaseStorage
              .ref()
              .child('profile_photos')
              .child(user.uid)
              .child('${user.uid}.jpg');

          final uploadTask = storageRef.putFile(File(pickedFile.path));
          final snapshot = await uploadTask;
          final url = await snapshot.ref.getDownloadURL();

          await _firestore.collection('users').doc(user.uid).update({
            'profilePhotoUrl': url,
          });

          return url;
        }
      }
    } catch (e) {
      throw Exception('Failed to pick and upload image: $e');
    }
    return null;
  }

  Future<void> addCertificate(Certificate certificate, File file) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final storageRef = _firebaseStorage
          .ref()
          .child('certificates')
          .child(user.uid)
          .child(
              '${DateTime.now().millisecondsSinceEpoch}.${certificate.fileType}');

      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();

      final updatedCertificate = certificate.copyWith(fileUrl: url);

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data()!;
      final userModel = UserModel.fromMap(userData);

      userModel.certificates = userModel.certificates ?? [];
      userModel.certificates!.add(updatedCertificate);

      await updateUserProfile(userModel);
    }
  }

  Future<void> removeCertificate(String certificateId, String fileUrl) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      // Remove file from Firebase Storage
      final fileRef = _firebaseStorage.refFromURL(fileUrl);
      await fileRef.delete();

      // Remove certificate from Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data()!;
      final userModel = UserModel.fromMap(userData);

      userModel.certificates =
          userModel.certificates?.where((c) => c.id != certificateId).toList();

      await updateUserProfile(userModel);
    }
  }

  Future<void> viewCertificate(String url) async {
    final Uri certificateUri = Uri.parse(url);
    if (await canLaunchUrl(certificateUri)) {
      await launchUrl(certificateUri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch the certificate URL: $url');
    }
  }

  Future<Map<String, dynamic>?> pickCertificate() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null) {
      File selectedFile = File(result.files.single.path!);
      String fileExtension = result.files.single.extension!;
      return {
        'file': selectedFile,
        'extension': fileExtension,
      };
    }
    return null;
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          throw Exception('Eski şifre yanlış');
        } else {
          throw Exception('Şifre değiştirme başarısız');
        }
      }
    }
  }

  Future<void> deleteAccount(String currentPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        // kullanıcıyı doğrulama
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);
        await user.delete();
      } catch (e) {
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'requires-recent-login':
              throw Exception(
                  'Kullanıcıyı silmeden önce yeniden giriş yapmanız gerekmektedir.');
            default:
              throw Exception('Hesap silme hatası: ${e.message}');
          }
        } else {
          throw Exception('Bilinmeyen bir hata oluştu: ${e.toString()}');
        }
      }
    } else {
      throw Exception('Kullanıcı oturumu açık değil.');
    }
  }
}
