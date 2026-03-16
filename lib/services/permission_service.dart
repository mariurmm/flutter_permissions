import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<PermissionStatus> getPermissionsStatus(Permission permission) async {
    switch (permission) {
      case Permission.location:
        return await Permission.location.status;

      default:
        return PermissionStatus.denied;
    }
  }

  Future<PermissionStatus> requestPermission(Permission permission) async {
    switch (permission) {
      case Permission.location:
        return await Permission.location.request();

      default:
        return PermissionStatus.denied;
    }
  }
}
