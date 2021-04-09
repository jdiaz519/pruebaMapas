import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/direccion.dart';
import 'package:flutter_application_1/iniciosesion.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as lct;
import 'package:uuid/uuid.dart';

import 'bloc.dart';
import 'servicioDirecciones.dart';

class Mapa extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MapaState();
  }
}

class MapaState extends State<Mapa> {
  List<Marker> marcadores = [];
  final _destinationController = TextEditingController();
  StreamSubscription<User> loginStateSubscription;
  GoogleMapController mapController;

  void initState() {
    marcadores.add(Marker(
        markerId: MarkerId('Unab'),
        draggable: false,
        onTap: () {
          print("marcador seleccionado");
        },
        position: LatLng(7.009394143254109, -73.13622572698776)));

    marcadores.add(Marker(
        markerId: MarkerId('Puesto de trabajo'),
        draggable: false,
        onTap: () {
          print("marcador seleccionado");
        },
        position: LatLng(7.120024, -73.109300)));
    var provider = Provider.of<Autenticacion>(context, listen: false);
    loginStateSubscription = provider.usuarioActual.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => InicioDeSesion(),
          ),
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _destinationController.dispose();
    super.dispose();
  }

  busqueda() async {
    final sesionToken = Uuid().v4();
    final Suggestion resultado = await showSearch(
        context: context, delegate: BuscarDireccion(sesionToken));
    if (resultado != null) {
      setState(() {
        _destinationController.text = resultado.description;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<Autenticacion>(context);
    final _destinationController = TextEditingController();

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ingrese el lugar',
          style: TextStyle(
              fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
            child: Row(
              children: [
                Direcciones(
                  controller: _destinationController,
                  hint: 'Escriba una dirección',
                  onTap: busqueda,
                ),
                GestureDetector(
                  onTap: () {
                    bloc.cerrarSesion();
                  },
                  child: Icon(
                    Icons.logout,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: StreamBuilder<User>(
            stream: bloc.usuarioActual,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              return Column(children: <Widget>[
                Expanded(
                  child: GoogleMap(
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(7.009394143254109, -73.13622572698776),
                          zoom: 12),
                      markers: Set.from(marcadores),
                      zoomControlsEnabled: true,
                      onMapCreated: (controller) => mapController = controller),
                ),
                Text(snapshot.data.email)
              ]);
            }),
      ),
    );
  }
}

class Direcciones extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Function onTap;

  const Direcciones({Key key, this.controller, this.hint, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        Container(
          height: 50.0,
          width: 320.0,
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 25.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.0),
            color: Colors.grey[100],
          ),
          child: TextField(
            controller: controller,
            onTap: onTap,
            enabled: true,
            decoration: InputDecoration.collapsed(
              hintText: hint,
            ),
          ),
        )
      ],
    );
  }
}
