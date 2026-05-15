import 'package:final_tpg_project_p1/view/application_form_screen.dart';
import 'package:final_tpg_project_p1/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Everything related to the student home screen,
// where students can view their applications,
// check their status, and cancel them if needed.

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {

  Future<void> _refreshApplications() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    await Provider.of<ApplicationViewModel>(
      context,
      listen: false,
    ).fetchUserApplications(user.id);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshApplications();
    });
  }

  // ========================= STATUS COLOR =========================

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {

      case 'approved':
        return Colors.green;

      case 'rejected':
        return Colors.red;

      case 'pending':
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  // ========================= STATUS ICON =========================

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {

      case 'approved':
        return Icons.check_circle;

      case 'rejected':
        return Icons.cancel;

      case 'pending':
        return Icons.hourglass_empty;

      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<ApplicationViewModel>(context);

    return Scaffold(

      appBar: AppBar(
        title: const Text("Student Home"),
        centerTitle: true,
      ),

      // ========================= ADD APPLICATION =========================

      floatingActionButton: FloatingActionButton(

        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ApplicationFormScreen(),
            ),
          );

          // REFRESH AFTER RETURNING
          await _refreshApplications();
        },

        child: const Icon(Icons.add),
      ),

      // ========================= BODY =========================

      body: vm.isLoading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : vm.applications.isEmpty

              ? const Center(
                  child: Text(
                    "No Applications Submitted Yet",
                    style: TextStyle(fontSize: 16),
                  ),
                )

              : RefreshIndicator(

                  onRefresh: _refreshApplications,

                  child: ListView.builder(

                    padding: const EdgeInsets.all(16),

                    itemCount: vm.applications.length,

                    itemBuilder: (context, index) {

                      final app = vm.applications[index];

                      return Card(

                        elevation: 3,

                        margin: const EdgeInsets.only(bottom: 12),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Padding(

                          padding: const EdgeInsets.all(12),

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              // ========================= MODULE =========================

                              Text(
                                app.module1,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // ========================= STATUS =========================

                              Row(
                                children: [

                                  Icon(
                                    _statusIcon(app.status),
                                    color: _statusColor(app.status),
                                  ),

                                  const SizedBox(width: 8),

                                  Text(
                                    "Status: ${app.status}",
                                    style: TextStyle(
                                      color: _statusColor(app.status),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // ========================= DETAILS =========================

                              Text(
                                "Year: ${app.yearOfStudy}",
                              ),

                              Text(
                                "Module 1 Level: ${app.module1Level}",
                              ),

                              if (app.module2 != null &&
                                  app.module2!.isNotEmpty)

                                Text(
                                  "Module 2: ${app.module2}",
                                ),

                              if (app.module2Level != null &&
                                  app.module2Level!.isNotEmpty)

                                Text(
                                  "Module 2 Level: ${app.module2Level}",
                                ),

                              const SizedBox(height: 12),

                              // ========================= CANCEL BUTTON =========================

                              Align(

                                alignment: Alignment.centerRight,

                                child: TextButton.icon(

                                  onPressed: () async {

                                    if (app.id == null) return;

                                    await vm.deleteApplication(
                                      app.id!,
                                    );

                                    // REFRESH AFTER DELETE
                                    await _refreshApplications();

                                    if (!mounted) return;

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(

                                      const SnackBar(
                                        content: Text(
                                          "Application cancelled",
                                        ),
                                      ),
                                    );
                                  },

                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),

                                  label: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}