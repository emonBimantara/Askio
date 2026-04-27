import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isLoading = false.obs;

  User? get user => firebaseUser.value;

  bool isNavigating = false;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(auth.authStateChanges());
    ever(firebaseUser, setInitialScreen);
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and password cannot be empty");
      return;
    }

    try {
      isLoading.value = true;
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", _loginError(e.code));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String username,
    String email,
    String password,
    String confirmPassword,
    String role,
  ) async {
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar("Error", "All fields must be filled");
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Password confirmation does not match");
      return;
    }

    try {
      isLoading.value = true;

      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.sendEmailVerification();

      await credential.user?.updateDisplayName(username);

      await credential.user?.reload();
      firebaseUser.value = auth.currentUser;

      await firestore.collection('users').doc(credential.user!.uid).set({
        'username': username,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Successfully registered");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", _registerError(e.code));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Email cannot be empty");
      return;
    }

    try {
      isLoading.value = true;

      await auth.sendPasswordResetEmail(email: email.trim());

      Get.snackbar("Success", "Password reset link sent. Check your email.");

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.offAllNamed('/login');
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", _resetError(e.code));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  void setInitialScreen(User? user) async {
    if (isNavigating) return;
    isNavigating = true;

    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    if (user == null) {
      Get.offAllNamed('/login');
    } else if (!user.emailVerified) {
      await auth.signOut();

      Get.offAllNamed('/login');

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          "Verify Email",
          "Please check your email and verify your account first",
        );
      });
    } else {
      Get.offAllNamed('/home');
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      isNavigating = false;
    });
  }

  String _loginError(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Account not found';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email format';
      case 'invalid-credential':
        return 'Invalid email or password';
      default:
        return 'Login failed, please try again';
    }
  }

  String _registerError(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'Password must be at least 6 characters';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'invalid-email':
        return 'Invalid email format';
      default:
        return 'Registration failed, please try again';
    }
  }

  String _resetError(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Email is not registered';
      case 'invalid-email':
        return 'Invalid email format';
      default:
        return 'Failed to send reset email';
    }
  }
}
