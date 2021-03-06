import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CambiarClave extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CambiarClaveEstado();
  }
}

class CambiarClaveEstado extends State<CambiarClave> {
  final cambioClave = FirebaseAuth.instance;

  String _correo;
  final llaveFormulario = GlobalKey<FormState>();
  Future<void> resetPassword(String email) async {
    await cambioClave.sendPasswordResetEmail(email: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambiar Clave'),
      ),
      body: Container(
        color: Colors.blue,
        padding: EdgeInsets.all(20),
        child: Form(
          key: llaveFormulario,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Cambiar clave',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 33,
                  ),
                  textAlign: TextAlign.center),
              Card(
                  child: TextFormField(
                decoration: InputDecoration(labelText: 'Correo'),
                validator: (value) {
                  return value.isEmpty ? 'El campo Correo está vacio' : null;
                },
                onSaved: (newValue) => _correo = newValue,
              )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  onPrimary: Colors.white, //
                ),
                child: Text("Enviar"),
                onPressed: () {
                  final form = llaveFormulario.currentState;
                  if (form.validate()) {
                    form.save();
                    print("gola $_correo");
                    resetPassword(_correo);
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
