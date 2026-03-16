import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'services/geolocator_service.dart';
import 'services/media_service.dart';
import 'services/permission_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PermissionService _permissionService = PermissionService();
  final GeolocatorService _geolocatorService = GeolocatorService();
  final MediaService _mediaService = MediaService();

  PermissionStatus _locationStatus = PermissionStatus.denied;
  PermissionStatus _cameraStatus = PermissionStatus.denied;
  PermissionStatus _galleryStatus = PermissionStatus.denied;

  String _locationText = 'No location';
  File? _cameraImage;
  File? _galleryImage;

  @override
  void initState() {
    super.initState();
    _loadStatuses();
  }

  Future<void> _loadStatuses() async {
    final locationStatus = await _permissionService.getStatus(Permission.location);
    final cameraStatus = await _permissionService.getStatus(Permission.camera);
    final galleryStatus = await _permissionService.getGalleryStatus();

    if (!mounted) return;

    setState(() {
      _locationStatus = locationStatus;
      _cameraStatus = cameraStatus;
      _galleryStatus = galleryStatus;
    });
  }

  Future<void> _onLocationPressed() async {
    final status = await _permissionService.requestLocation();

    if (!mounted) return;

    setState(() {
      _locationStatus = status;
    });

    if (!status.isGranted) return;

    final position = await _geolocatorService.getCurrentPosition();

    if (!mounted) return;

    setState(() {
      _locationText = '${position.latitude}, ${position.longitude}';
    });
  }

  Future<void> _onCameraPressed() async {
    final status = await _permissionService.requestCamera();

    if (!mounted) return;

    setState(() {
      _cameraStatus = status;
    });

    if (!status.isGranted) return;

    final file = await _mediaService.pickFromCamera();

    if (!mounted || file == null) return;

    setState(() {
      _cameraImage = file;
    });
  }

  Future<void> _onGalleryPressed() async {
    final status = await _permissionService.requestGallery();

    if (!mounted) return;

    setState(() {
      _galleryStatus = status;
    });

    if (!status.isGranted) return;

    final file = await _mediaService.pickFromGallery();

    if (!mounted || file == null) return;

    setState(() {
      _galleryImage = file;
    });
  }

  String _statusText(PermissionStatus status) {
    if (status.isGranted) return 'granted';
    if (status.isDenied) return 'denied';
    if (status.isPermanentlyDenied) return 'permanently denied';
    if (status.isRestricted) return 'restricted';
    if (status.isLimited) return 'limited';
    return status.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PermissionBlock(
              title: 'Location',
              status: _statusText(_locationStatus),
              onPressed: _onLocationPressed,
              child: Text(_locationText),
            ),
            const SizedBox(height: 16),
            PermissionBlock(
              title: 'Camera',
              status: _statusText(_cameraStatus),
              onPressed: _onCameraPressed,
              child: _cameraImage == null
                  ? const Text('No image')
                  : Image.file(_cameraImage!, height: 150),
            ),
            const SizedBox(height: 16),
            PermissionBlock(
              title: 'Gallery',
              status: _statusText(_galleryStatus),
              onPressed: _onGalleryPressed,
              child: _galleryImage == null
                  ? const Text('No image')
                  : Image.file(_galleryImage!, height: 150),
            ),
          ],
        ),
      ),
    );
  }
}

class PermissionBlock extends StatelessWidget {
  final String title;
  final String status;
  final VoidCallback onPressed;
  final Widget child;

  const PermissionBlock({
    super.key,
    required this.title,
    required this.status,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Text('Status: $status'),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text('Request / Show'),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}