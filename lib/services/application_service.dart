import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:final_tpg_project_p1/model/models.dart';

class ApplicationService {
  final supabase = Supabase.instance.client;

  Future<void> createApplication(ApplicationModel app) async {
    await supabase.from('applications').insert(app.toJson());
  }

  Future<List<ApplicationModel>> getUserApplications(String userId) async {
    final response = await supabase
        .from('applications')
        .select()
        .eq('user_id', userId);

    return (response as List)
        .map((json) => ApplicationModel.fromJson(json))
        .toList();
  }

  Future<void> updateApplication(ApplicationModel app) async {
    await supabase
        .from('applications')
        .update(app.toJson())
        .eq('id', app.id);
  }

  Future<void> deleteApplication(String id) async {
    await supabase
        .from('applications')
        .delete()
        .eq('id', id);
  }

  Future<List<ApplicationModel>> getAllApplications() async {
    final response = await supabase
        .from('applications')
        .select();

    return (response as List)
        .map((json) => ApplicationModel.fromJson(json))
        .toList();
  }

  Future<void> updateStatus(String id, String status) async {
    await supabase
        .from('applications')
        .update({'status': status})
        .eq('id', id);
  }
}