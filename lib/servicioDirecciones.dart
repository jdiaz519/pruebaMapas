import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

class Place {
  String streetNumber;
  String street;
  String city;
  String zipCode;

  Place(
    this.streetNumber,
    this.street,
    this.city,
    this.zipCode,
  );

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static final String androidKey = 'AIzaSyDYCd0CrSR2OLVg4kvZrx6ipnmVc6v9qkc';
  static final String iosKey = 'YOUR_API_KEY_HERE';
  final apiKey = Platform.isAndroid;

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=AIzaSyDYCd0CrSR2OLVg4kvZrx6ipnmVc6v9qkc&sessiontoken=$sessionToken';
    print('{$sessionToken key $androidKey $input}');
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
