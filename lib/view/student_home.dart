import 'package:final_tpg_project_p1/view/application_form_screen.dart';
import 'package:final_tpg_project_p1/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  StudentHomeState createState() => StudentHomeState();
}

class StudentHomeState extends State<StudentHome> {
  @override
  void initState() {
    super.initState();

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApplicationViewModel>(
        context,
        listen: false,
      ).fetchUserApplications(user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ApplicationViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Student Home")),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ApplicationFormScreen(),
                        ),
                      ).then((created) {
                        if (created == true) {
                          final user = Supabase.instance.client.auth.currentUser;
                          if (user != null) {
                            Provider.of<ApplicationViewModel>(
                              context,
                              listen: false,
                            ).fetchUserApplications(user.id);
                          }
                        }
                      });
                    },
                    child: const Text("Apply"),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: vm.applications.isEmpty
                        ? const Center(child: Text("No application submitted"))
                        : ListView.builder(
                            itemCount: vm.applications.length,
                            itemBuilder: (context, index) {
                              final app = vm.applications[index];

                              return Card(
                                margin: const EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Module: ${app.module1}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  "Year: ${app.yearOfStudy}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(
                                                app.status,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              app.status.toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      if (app.module2 != null)
                                        Text(
                                          "Module 2: ${app.module2}",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child:
                                            app.status.toLowerCase() ==
                                                    'pending'
                                                ? ElevatedButton.icon(
                                                    onPressed: () async {
                                                      _showCancelDialog(
                                                        context,
                                                        app.id,
                                                        vm,
                                                      );
                                                    },
                                                    icon: const Icon(Icons.delete),
                                                    label:
                                                        const Text("Cancel"),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  )
                                                : const SizedBox(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showCancelDialog(
    BuildContext context,
    String applicationId,
    ApplicationViewModel vm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cancel Application"),
          content: const Text(
            "Are you sure you want to cancel this application? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await vm.cancelApplication(applicationId);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Application cancelled successfully"),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to cancel application: $e")),
                  );
                }
              },
              child: const Text("Yes, Cancel"),
            ),
          ],
        );
      },
    );
  }
}
