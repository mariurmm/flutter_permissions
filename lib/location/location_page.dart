import 'package:flutter/material.dart';
import 'package:flutter_permissions/location/position_widget.dart';
import 'package:flutter_permissions/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late final PermissionService _service;
  PermissionStatus _status = PermissionStatus.denied;
  @override
  void initState() {
    super.initState();
    _service = PermissionService();
    _initStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _status == PermissionStatus.denied ? Container() : Center(child: PositionWidget()),
    );
  }

  void _initStatus() async {
    _status = await _service.getPermissionsStatus(Permission.location);

    if (_status == PermissionStatus.denied) {
      _status = await _service.requestPermission(Permission.location);
    }
    print('status $_status');
    setState(() {});
  }
}
