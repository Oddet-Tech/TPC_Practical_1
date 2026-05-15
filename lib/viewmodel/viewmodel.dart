import 'package:final_tpg_project_p1/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/models.dart';
import '../services/application_service.dart';

// Here we will manage all the logic related to the application,
// such as fetching, creating, updating, and deleting applications (CRUD).
// It will also handle user authentication and role management.
// This way, our UI can simply call these methods without worrying
// about the underlying implementation.

class ApplicationViewModel extends ChangeNotifier {

  final ApplicationService _service = ApplicationService();
  final AuthService _authService = AuthService();

  List<ApplicationModel> applications = [];

  bool isLoading = false;
  bool isSubmitting = false;

  String? errorMessage;
  UserModel? currentUser;

  bool get isAdmin => currentUser?.isAdmin ?? false;
  bool get isAuthenticated => currentUser != null;

  // ========================= LOGIN =========================

  Future<bool> login(
    String email,
    String password,
  ) async {

    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {

      await _authService.signIn(
        email,
        password,
      );

      await _loadCurrentUser();

      return true;

    } catch (e) {

      errorMessage =
          'Login failed. Check your credentials.';

      return false;

    } finally {

      isLoading = false;
      notifyListeners();
    }
  }

  // ========================= LOGOUT =========================

  Future<void> logout() async {

    try {

      await _authService.signOut();

      currentUser = null;
      applications = [];

    } catch (e) {

      errorMessage = 'Logout failed: $e';
    }

    notifyListeners();
  }

  // ========================= LOAD CURRENT USER =========================

  Future<void> _loadCurrentUser() async {

    try {

      final authUser =
          _authService.getCurrentUser();

      if (authUser == null) return;

      final response = await Supabase
          .instance
          .client
          .from('profiles')
          .select()
          .eq('id', authUser.id)
          .single();

      currentUser =
          UserModel.fromJson(response);

    } catch (e) {
      // No profile row means regular student — not an error
      currentUser = null;
    }

    notifyListeners();
  }

  // ========================= FETCH USER APPLICATIONS =========================

  Future<void> fetchUserApplications(
    String userId,
  ) async {

    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {

      applications =
          await _service.getUserApplications(
        userId,
      );

    } catch (e) {

      applications = [];

      errorMessage =
          'Failed to load applications: $e';

    } finally {

      isLoading = false;
      notifyListeners();
    }
  }

  // ========================= CREATE APPLICATION =========================

  Future<void> createApplication(
    ApplicationModel app,
  ) async {

    isSubmitting = true;
    errorMessage = null;

    notifyListeners();

    try {

      await _service.createApplication(app);

      // REFRESH APPLICATIONS
      await fetchUserApplications(
        app.userId,
      );

    } catch (e) {

      errorMessage =
          'Failed to submit application: $e';

      rethrow;

    } finally {

      isSubmitting = false;
      notifyListeners();
    }
  }

  // ========================= UPDATE APPLICATION =========================

  Future<void> updateApplication(
    ApplicationModel app,
  ) async {

    try {

      await _service.updateApplication(app);

      // REFRESH APPLICATIONS
      await fetchUserApplications(
        app.userId,
      );

    } catch (e) {

      errorMessage =
          'Failed to update application: $e';

      notifyListeners();
    }
  }

  // ========================= DELETE APPLICATION =========================

  Future<void> deleteApplication(
    String id,
  ) async {

    try {

      await _service.deleteApplication(id);
      await fetchAllApplications();

    } catch (e) {

      errorMessage =
          'Failed to delete application: $e';

      notifyListeners();
    }
  }

  // ========================= FETCH ALL APPLICATIONS =========================

  Future<void> fetchAllApplications() async {

    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {

      applications =
          await _service.getAllApplications();

    } catch (e) {

      errorMessage =
          'Failed to load applications: $e';

    } finally {

      isLoading = false;
      notifyListeners();
    }
  }

  // ========================= UPDATE STATUS =========================

  Future<void> updateStatus(
    String id,
    String status,
  ) async {

    try {

      await _service.updateStatus(id, status);
      await fetchAllApplications();

    } catch (e) {

      errorMessage =
          'Failed to update status: $e';

      notifyListeners();
    }
  }

  // ========================= CHECK EXISTING APPLICATION =========================

  Future<bool> hasExistingApplication(
    String userId,
  ) async {

    try {

      final userApps =
          await _service.getUserApplications(
        userId,
      );

      return userApps.isNotEmpty;

    } catch (e) {

      errorMessage =
          'Failed to check application: $e';

      notifyListeners();

      return false;
    }
  }
}