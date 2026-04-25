import 'package:flutter/material.dart';
import '../model/models.dart';
import '../services/application_service.dart';

class ApplicationViewModel extends ChangeNotifier {
  final ApplicationService _service = ApplicationService();

  List<ApplicationModel> applications = [];
  bool isLoading = false;

  Future<void> fetchUserApplications(String userId) async {
    isLoading = true;
    notifyListeners();

    applications = await _service.getUserApplications(userId);

    isLoading = false;
    notifyListeners();
  }

  Future<void> createApplication(ApplicationModel app) async {
    await _service.createApplication(app);
  }

  Future<void> updateApplication(ApplicationModel app) async {
    await _service.updateApplication(app);
  }

  Future<void> deleteApplication(String id) async {
    await _service.deleteApplication(id);
  }

  Future<void> fetchAllApplications() async {
    isLoading = true;
    notifyListeners();

    applications = await _service.getAllApplications();

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateStatus(String id, String status) async {
    await _service.updateStatus(id, status);
  }
}