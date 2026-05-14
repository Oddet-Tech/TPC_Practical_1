import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:final_tpg_project_p1/model/models.dart';

class ApplicationService {
  final SupabaseClient supabase = Supabase.instance.client;
  static const String _tableName = 'applications';

  // ========================= CREATE =========================
  Future<void> createApplication(ApplicationModel app) async {
    final payload = app.toJson();

    try {
      await supabase.from(_tableName).insert(payload);
    } catch (e) {
      throw Exception("Create failed: $e");
    }
  }

  // ========================= GET USER =========================
  Future<List<ApplicationModel>> getUserApplications(String userId) async {
    try {
      final response = await supabase
          .from(_tableName)
          .select()
          .eq('id', userId);

      return (response as List)
          .map((json) => ApplicationModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Fetch user applications failed: $e");
    }
  }

  // ========================= UPDATE =========================
  Future<void> updateApplication(ApplicationModel app) async {
    if (app.id == null || app.id!.trim().isEmpty) {
      throw Exception("Invalid application ID");
    }

    final payload = app.toJson();
    payload.remove('created_at');

    try {
      await supabase
          .from(_tableName)
          .update(payload)
          .eq('id', app.id!);
    } catch (e) {
      throw Exception("Update failed: $e");
    }
  }

  // ========================= DELETE =========================
  Future<void> deleteApplication(String id) async {
    if (id.trim().isEmpty) {
      throw Exception("Invalid ID");
    }

    try {
      await supabase
          .from(_tableName)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception("Delete failed: $e");
    }
  }

  // ========================= ADMIN GET ALL =========================
  Future<List<ApplicationModel>> getAllApplications() async {
    try {
      final response = await supabase.from(_tableName).select();

      return (response as List)
          .map((json) => ApplicationModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Fetch all applications failed: $e");
    }
  }

  // ========================= STATUS UPDATE =========================
  Future<void> updateStatus(String id, String status) async {
    if (id.trim().isEmpty) {
      throw Exception("Invalid ID");
    }

    try {
      await supabase
          .from(_tableName)
          .update({'status': status})
          .eq('id', id);
    } catch (e) {
      throw Exception("Status update failed: $e");
    }
  }
}