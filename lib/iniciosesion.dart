import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/bloc.dart';
import 'package:flutter_application_1/cambiarClave.dart';
import 'package:flutter_application_1/mapa.dart';
import 'package:flutter_application_1/registro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class InicioDeSesion extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InicioDeSesionState();
  }
}

class InicioDeSesionState extends State<InicioDeSesion> {
  final llaveFormulario = GlobalKey<FormState>();
  StreamSubscription<User> loginStateSubscription;

  String _correo;
  String _contrasena;
  @override
  void initState() {
    super.initState();

    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });

    var provider = Provider.of<Autenticacion>(context, listen: false);
    loginStateSubscription = provider.usuarioActual.listen((fbUser) {
      if (fbUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Mapa(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  _buscarUsuario(String correo, String contrasena) {}

  _dialogo(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (context) {
          return SimpleDialog(
            title: Center(child: Text("Datos incorrectos")),
            children: <Widget>[
              Center(
                  child: Text(
                "El correo y la clave no son correctos, por favor intenta de nuevo.",
                textAlign: TextAlign.center,
              )),
              Center(
                  child: FlatButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop('ok');
                      })),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<Autenticacion>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Bienvenido'),
        ),
        body: Container(
            color: Colors.blue,
            padding: EdgeInsets.all(20),
            child: Center(
                child: Form(
              key: llaveFormulario,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Column(children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Correo'),
                        validator: (value) {
                          return value.isEmpty
                              ? 'El campo correo está vacio'
                              : null;
                        },
                        onSaved: (newValue) => _correo = newValue,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Contraseña'),
                        obscureText: true,
                        validator: (value) {
                          return value.isEmpty
                              ? 'El campo contraseña está vacio'
                              : null;
                        },
                        onSaved: (value) => _contrasena = value,
                      ),
                    ]),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // background
                            onPrimary: Colors.white, //
                          ),
                          onPressed: () {
                            final form = llaveFormulario.currentState;
                            if (form.validate()) {
                              form.save();

                              print(
                                  'formulario validado $_correo  $_contrasena');
                              FirebaseFirestore.instance
                                  .collection("usuarios")
                                  .where("correo", isEqualTo: "$_correo")
                                  .get()
                                  .then((value) {
                                if (value.docs.isEmpty) {
                                  print(value.docs);
                                  final snackBar =
                                      SnackBar(content: Text('No existe'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                                value.docs.forEach((result) {
                                  String contrasenaDef = result.data()['clave'];
                                  print('$_contrasena y $contrasenaDef');
                                  if (contrasenaDef == _contrasena) {
                                    print('Contrasena correcta');
                                    bloc.inicioDeSesionCorreo(
                                        _correo, _contrasena);
                                  } else {
                                    print('Contrasena incorrecta');
                                    final snackBar = SnackBar(
                                        content: Text('Contraseña incorrecta'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                });
                              });
                            } else {
                              print('formulario no validado');
                              _dialogo(context);
                            }
                          },
                          child: Text('Iniciar sesion'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueGrey, // background
                            onPrimary: Colors.black, //
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Registro()),
                            );
                          },
                          child: Text('Registrar'),
                        ),
                        SignInButton(
                          Buttons.Google,
                          onPressed: () => bloc.inicioDeSesion(),
                        ),
                        SignInButton(
                          Buttons.Facebook,
                          onPressed: () => bloc.inicioDeSesionFaceebook(),
                        ),
                        TextButton(
                          child: Text('Olvide contraseña'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CambiarClave()),
                            );
                          },
                        )
                      ])
                ],
              ),
            ))));
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
