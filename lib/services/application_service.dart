import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:final_tpg_project_p1/model/models.dart';

class ApplicationService {
  final supabase = Supabase.instance.client;
  static const String _tableName = 'applications';

  Future<void> createApplication(ApplicationModel app) async {
    final payload = Map<String, dynamic>.from(app.toJson());
    if (payload['id'] == null || payload['id'] == '') {
      payload.remove('id');
    }
    await supabase.from(_tableName).insert(payload);
  }

  Future<List<ApplicationModel>> getUserApplications(String userId) async {
    final response = await supabase.from(_tableName).select().eq('user_id', userId);

    return (response as List).map((json) => ApplicationModel.fromJson(json)).toList();
  }

  Future<void> updateApplication(ApplicationModel app) async {
    await supabase.from(_tableName).update(app.toJson()).eq('id', app.id);
  }

  Future<void> deleteApplication(String id) async {
    await supabase.from(_tableName).delete().eq('id', id);
  }

  Future<List<ApplicationModel>> getAllApplications() async {
    final response = await supabase.from(_tableName).select();

    return (response as List).map((json) => ApplicationModel.fromJson(json)).toList();
  }

  Future<void> updateStatus(String id, String status) async {
    await supabase.from(_tableName).update({'status': status}).eq('id', id);
  }
}
