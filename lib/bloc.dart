import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_application_1/servicio.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Autenticacion {
  final servicio = Servicio();
  final inicioDeSesionGoogle = GoogleSignIn(scopes: ['email']);

  Stream<User> get usuarioActual => servicio.usuarioActual;

  final fb = FacebookLogin();

  inicioDeSesionFaceebook() async {
    print('se inicio sesion');

    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    switch (res.status) {
      case FacebookLoginStatus.success:
        print('Accedio');

        //Convert to Auth Credential
        final AuthCredential credential =
            FacebookAuthProvider.credential(res.accessToken.token);

        print('holaa ${res.accessToken.token}');
        print('holaa2 $credential');

        //User Credential to Sign in with Firebase
        final result = await servicio.inicioSesionGoogle(credential);

        print('${result.user.displayName} is now logged in');

        break;

      case FacebookLoginStatus.cancel:
        print('Se cancelo el inicio de sesion');
        break;
      case FacebookLoginStatus.error:
        print('hay un error');
        break;
      case FacebookLoginStatus.cancel:
        // TODO: Handle this case.
        break;
    }
  }

  inicioDeSesion() async {
    try {
      final GoogleSignInAccount usuario = await inicioDeSesionGoogle.signIn();
      final GoogleSignInAuthentication autenticacion =
          await usuario.authentication;
      final AuthCredential credenciales = GoogleAuthProvider.credential(
          idToken: autenticacion.idToken,
          accessToken: autenticacion.accessToken);
      final resultado = await servicio.inicioSesionGoogle(credenciales);

      print('${resultado.user.displayName}');
    } catch (error) {}
  }

  inicioDeSesionCorreo(String correo, String clave) async {
    try {
      final AuthCredential credenciales =
          EmailAuthProvider.credential(email: correo, password: clave);

      final resultado = await servicio.inicioSesionGoogle(credenciales);
      print('${resultado.user.email}');
    } catch (error) {
      print('Contraseña incorrecta');
    }
  }

  cerrarSesion() {
    servicio.logout();
  }
}
