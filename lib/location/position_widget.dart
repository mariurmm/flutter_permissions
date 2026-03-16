import 'package:flutter/material.dart';
import 'package:flutter_permissions/services/geolocator_service.dart';
import 'package:geolocator/geolocator.dart';

class PositionWidget extends StatefulWidget {
  const PositionWidget({super.key});

  @override
  State<PositionWidget> createState() => _PositionWidgetState();
}

class _PositionWidgetState extends State<PositionWidget> {
  late final GeolocatorService _service;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _service = GeolocatorService();
    _geolocate();
  }

  @override
  Widget build(BuildContext context) {
    return _currentPosition != null ? Container(
      child: Text('${_currentPosition!.latitude}: ${_currentPosition!.longitude}' , style: TextStyle(color: Colors.red),),
    ) : SizedBox.shrink();
  }

  void _geolocate() async {
    _currentPosition = await _service.geolocate();
  }
}
