//Group P1 members: Shilenge Oddet 223015126
//Brandon Lombaard 223021599
//Motloli TJ 22206982
//Quadri PF 224017653
//Asive Mnyamazi 224113476
//Selahla KO 221007346
// Makhanye NJ 220000689
import 'package:final_tpg_project_p1/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


//admin will access all Applications and
// will have the ability to approve, reject, or delete them.
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
//All applications are displayed in a list, 
//with options to approve, reject, or delete each application.
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
//infomation about the application, such as the student ID, year of study, selected modules,
// and current status is displayed.This infomation is retrieved from the
// Application form and the generated ID for the student.
                      children: [
                        Text(
                          "Student ID: ${app.userId}",//A Generated ID is used to
                          // identify the student who submitted the application.
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Year: ${app.yearOfStudy}",//from the Application form
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
                                if (app.id == null) {
                                  return;
                                }

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