import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

import '../../../../../Utils/Widgets/input_text_field.dart';

class InputAddress extends StatelessWidget {
  const InputAddress({
    super.key,
    required this.address,
    required this.addressNumber,
    required this.cep,
    required this.referPoint,
    required this.latitudeReport,
    required this.longitudeReport,
  });

  final TextEditingController address;
  final TextEditingController addressNumber;
  final TextEditingController cep;
  final TextEditingController referPoint;
  final TextEditingController latitudeReport;
  final TextEditingController longitudeReport;

  Future<loc.LocationData?> getCurrentLocation() async {
    loc.Location location = loc.Location();

    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }

  Future<Placemark> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return placemarks[1];
      }
      throw "Endereço não disponível";
    } catch (e) {
      throw "Erro: ${e.toString()}";
    }
  }

  Future<void> fillAddress() async {
    loc.LocationData? locationData = await getCurrentLocation();
    if (locationData != null) {
      double? latitude = locationData.latitude;
      double? longitude = locationData.longitude;
      if (latitude != null && longitude != null) {
        latitudeReport.text = latitude.toString();
        longitudeReport.text = longitude.toString();
        Placemark addressPlacemark = await getAddress(latitude, longitude);
        address.text =
            '${addressPlacemark.thoroughfare} - ${addressPlacemark.subLocality}, ${addressPlacemark.subAdministrativeArea} - ${addressPlacemark.administrativeArea}';
        addressNumber.text = '${addressPlacemark.name}';
        cep.text = '${addressPlacemark.postalCode}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Endereço',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton.icon(
              onPressed: () => fillAddress(),
              icon: const Icon(Icons.location_on, color: Colors.orangeAccent),
              label: Text(
                'Usar localização atual',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        const Gap(5),
        InputTextField(
          controller: address,
          keyBoardType: TextInputType.streetAddress,
          hintText: 'Endereço',
          obscureText: false,
          onValidator: (value) {
            return null;
          },
        ),
        const Gap(15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Número',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const Gap(5),
        InputTextField(
          controller: addressNumber,
          keyBoardType: TextInputType.number,
          hintText: 'Número',
          obscureText: false,
          onValidator: (value) {
            return null;
          },
        ),
        const Gap(15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CEP',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const Gap(5),
        InputTextField(
          controller: cep,
          keyBoardType: TextInputType.number,
          hintText: 'CEP',
          obscureText: false,
          onValidator: (value) {
            return null;
          },
        ),
        const Gap(15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ponto de referência',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const Gap(5),
        InputTextField(
          controller: referPoint,
          keyBoardType: TextInputType.text,
          hintText: 'Ponto de referência',
          obscureText: false,
          onValidator: (value) {
            return null;
          },
        ),
      ],
    );
  }
}
