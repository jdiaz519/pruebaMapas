import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/bloc.dart';
import 'package:provider/provider.dart';
import 'iniciosesion.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Principal());
}

class Principal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Provider(
        create: (context) => Autenticacion(),
        child: MaterialApp(
            title: 'Prueba', home: Center(child: InicioDeSesion())));
  }
}
