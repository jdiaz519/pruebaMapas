import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/iniciosesion.dart';

class Registro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegistroState();
  }
}

_dialogo(BuildContext ctx, String msj) {
  showDialog(
      context: ctx,
      builder: (context) {
        return SimpleDialog(
          title: Center(child: Text("Alerta")),
          children: <Widget>[
            Center(
                child: Text(
              '$msj',
              textAlign: TextAlign.center,
            )),
            Center(
                child: ElevatedButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InicioDeSesion()),
                      );
                    })),
          ],
        );
      });
}

class RegistroState extends State<Registro> {
  final llaveFormulario = GlobalKey<FormState>();
  String _correo;
  String _clave;
  String _nombres;

  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final nuevoUsuario = FirebaseAuth.instance;

    final llaveFormulario = GlobalKey<FormState>();
    CollectionReference usuarios =
        FirebaseFirestore.instance.collection('usuarios');

    Future<void> _nuevoUsuario() {
      return usuarios
          .add({'correo': _correo, 'clave': _clave, 'nombres': _nombres})
          .then((value) => {
                nuevoUsuario.createUserWithEmailAndPassword(
                    email: _correo, password: _clave),
                _dialogo(
                    context, 'Los datos se han guardad satisfactoriamente'),
              })
          .catchError((error) => _dialogo(
              context, 'Ocurrio un error y los datos no fueron guardads'));
    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Container(
        color: Colors.blue,
        padding: EdgeInsets.all(20),
        child: Form(
          key: llaveFormulario,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombres Completos'),
                validator: (value) {
                  return value.isEmpty ? 'El campo Nombres está vacio' : null;
                },
                onSaved: (newValue) => _nombres = newValue,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo'),
                validator: (value) {
                  return value.isEmpty ? 'El campo correo está vacio' : null;
                },
                onSaved: (newValue) => _correo = newValue,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Clave'),
                validator: (value) {
                  return value.isEmpty ? 'El campo clave está vacio' : null;
                },
                onSaved: (newValue) => _clave = newValue,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // background
                    onPrimary: Colors.white, //
                  ),
                  onPressed: () {
                    final form = llaveFormulario.currentState;
                    if (form.validate()) {
                      form.save();
                      FirebaseFirestore.instance
                          .collection("usuarios")
                          .where("correo", isEqualTo: "$_correo")
                          .get()
                          .then((value) {
                        if (value.docs.isEmpty) {
                          _nuevoUsuario();
                        } else {
                          _dialogo(context,
                              'Este correo ya se encuentra registrado, intente con otro');
                        }
                      });
                    }
                  },
                  child: Text("Enviar")),
            ],
          ),
        ),
      ),
    );
  }
}
