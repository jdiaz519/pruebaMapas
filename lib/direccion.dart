import 'package:flutter/material.dart';
import 'package:flutter_application_1/servicioDirecciones.dart';

class BuscarDireccion extends SearchDelegate<Suggestion> {
  final sessionToken;
  PlaceApiProvider apiClient;
  BuscarDireccion(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    //
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {},
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query == ""
          ? null
          : apiClient.fetchSuggestions(query, searchFieldLabel),
      builder: (context, snapchot) => query == ''
          ? Container(
              child: Text('Direccion'),
            )
          : snapchot.hasData
              ? ListView.builder(
                  itemBuilder: (context, i) => ListTile(
                    title: Text((snapchot.data[i] as Suggestion).description),
                    onTap: () {},
                    onLongPress: () {},
                  ),
                  itemCount: snapchot.data.length,
                )
              : Container(
                  child: Center(child: CircularProgressIndicator()),
                ),
    );
  }
}
