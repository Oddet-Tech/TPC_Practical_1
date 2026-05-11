import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:final_tpg_project_p1/model/models.dart';

class ApplicationService {
  final supabase = Supabase.instance.client;

  // CREATE (FIXED NULL SAFETY)
  Future<void> createApplication(ApplicationModel app) async {
    final data = app.toJson();

    // 🔥 force safe values for Supabase
    data['module2'] ??= '';
    data['module2_level'] ??= '';
    data['document_url'] ??= '';

    await supabase.from('applications').insert(data);
  }

  // GET USER APPLICATIONS
  Future<List<ApplicationModel>> getUserApplications(String userId) async {
    final response = await supabase
        .from('applications')
        .select()
        .eq('user_id', userId)
        .order('created_at');

    return (response as List)
        .map((json) => ApplicationModel.fromJson(json))
        .toList();
  }

  // UPDATE
  Future<void> updateApplication(ApplicationModel app) async {
    if (app.id == null) return;

    final data = app.toJson();
    data['module2'] ??= '';
    data['module2_level'] ??= '';
    data['document_url'] ??= '';

    await supabase
        .from('applications')
        .update(data)
        .eq('id', app.id!);
  }

  // DELETE
  Future<void> deleteApplication(String id) async {
    await supabase
        .from('applications')
        .delete()
        .eq('id', id);
  }

  // ADMIN VIEW
  Future<List<ApplicationModel>> getAllApplications() async {
    final response = await supabase
        .from('applications')
        .select()
        .order('created_at');

    return (response as List)
        .map((json) => ApplicationModel.fromJson(json))
        .toList();
  }

  // STATUS UPDATE
  Future<void> updateStatus(String id, String status) async {
    await supabase
        .from('applications')
        .update({'status': status})
        .eq('id', id);
  }
}