import 'package:firebase_auth/firebase_auth.dart';

class Servicio {
  final inicioSesion = FirebaseAuth.instance;

  Future<UserCredential> inicioSesionGoogle(AuthCredential credential) =>
      inicioSesion.signInWithCredential(credential);
  Future<void> logout() => inicioSesion.signOut();
  Stream<User> get usuarioActual => inicioSesion.authStateChanges();
}
