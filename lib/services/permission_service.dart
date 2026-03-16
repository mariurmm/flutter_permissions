import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<PermissionStatus> getStatus(Permission permission) async {
    return permission.status;
  }

  Future<PermissionStatus> request(Permission permission) async {
    return permission.request();
  }

  Future<PermissionStatus> requestLocation() async {
    return request(Permission.location);
  }

  Future<PermissionStatus> requestCamera() async {
    return request(Permission.camera);
  }

  Future<PermissionStatus> requestGallery() async {
    return request(_galleryPermission);
  }

  Future<PermissionStatus> getGalleryStatus() async {
    return getStatus(_galleryPermission);
  }

  Permission get _galleryPermission {
    if (Platform.isIOS) {
      return Permission.photos;
    }

    return Permission.photos;
  }
}