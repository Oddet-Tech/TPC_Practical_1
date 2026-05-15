import 'package:final_tpg_project_p1/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//admin will access all Applications and will have the ability to approve, reject, or delete them.
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() =>
      _AdminDashboardState();
}

class _AdminDashboardState
    extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<ApplicationViewModel>(
          context,
          listen: false,
        ).fetchAllApplications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm =
        Provider.of<ApplicationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),

      body: vm.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
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
                        Text(
                          "Student ID: ${app.userId}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "Year: ${app.yearOfStudy}",
                        ),

                        Text(
                          "Module 1: ${app.module1} (${app.module1Level})",
                        ),

                        if (app.module2 != null)
                          Text(
                            "Module 2: ${app.module2} (${app.module2Level})",
                          ),

                        const SizedBox(height: 5),

                        Text(
                          "Status: ${app.status}",
                        ),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,

                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (app.id == null) return;

                                await vm.updateStatus(
                                  app.id!,
                                  "approved",
                                );

                                await vm.fetchAllApplications();
                              },

                              child: const Text(
                                "Approve",
                              ),
                            ),

                            ElevatedButton(
                              onPressed: () async {
                                if (app.id == null) return;

                                await vm.updateStatus(
                                  app.id!,
                                  "rejected",
                                );

                                await vm.fetchAllApplications();
                              },

                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.red,
                              ),

                              child: const Text(
                                "Reject",
                              ),
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                              ),

                              onPressed: () async {
                                if (app.id == null)
                                  return;

                                await vm
                                    .deleteApplication(
                                  app.id!,
                                );

                                await vm.fetchAllApplications();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}