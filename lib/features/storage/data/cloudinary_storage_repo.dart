import 'dart:io';
import 'package:dio/dio.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class CloudinaryStorageRepo implements StorageRepo {
  final String cloudName = 'ddrr96avj';
  final String uploadPreset = 'test_preset'; // Thay bằng preset của bạn

  @override
  Future<String?> upaloadProfileMobile(String path, String fileName) async {
    try {
      final file = File(path);
      if (!await file.exists()) {
        print('File không tồn tại: $path');
        return null;
      }

      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        'upload_preset': uploadPreset,
        'folder': 'profile_images',
      });

      var dio = Dio();
      var response = await dio.post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      return response.data['secure_url'];
    } on DioException catch (e) {
      print('Lỗi Cloudinary: ${e.response?.data}');
      return null;
    } catch (e) {
      print('Lỗi không xác định: $e');
      return null;
    }
  }

  @override
  Future<String?> upaloadPostMobile(String path, String fileName) async {
    try {
      final file = File(path);
      if (!await file.exists()) {
        print('File không tồn tại: $path');
        return null;
      }

      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        'upload_preset': uploadPreset,
        'folder': 'post_images',
      });

      var dio = Dio();
      var response = await dio.post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      return response.data['secure_url'];
    } on DioException catch (e) {
      print('Lỗi Cloudinary: ${e.response?.data}');
      return null;
    } catch (e) {
      print('Lỗi không xác định: $e');
      return null;
    }
  }
}
