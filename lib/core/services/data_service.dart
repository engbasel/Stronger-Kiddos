abstract class DatabaseService {
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? docuementId,
  });

  Future<void> updateData({
    required String path,
    required String docuementId,
    required Map<String, dynamic> data,
  });

  Future<dynamic> getData({required String path, String? docuementId});

  Future<bool> checkIfDatatExists({
    required String path,
    required String docuementId,
  });
}
