import 'package:final_tpg_project_p1/view/application_form_screen.dart';
import 'package:final_tpg_project_p1/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() =>
      _StudentHomeState();
}

class _StudentHomeState
    extends State<StudentHome> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Supabase
          .instance.client.auth.currentUser;

      if (user != null) {
        Provider.of<ApplicationViewModel>(
          context,
          listen: false,
        ).fetchUserApplications(user.id);
      }
    });
  }

  Future<void> refreshApplications() async {
    final user = Supabase
        .instance.client.auth.currentUser;

    if (user != null) {
      await Provider.of<ApplicationViewModel>(
        context,
        listen: false,
      ).fetchUserApplications(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm =
        Provider.of<ApplicationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Home"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const ApplicationFormScreen(),
            ),
          );

          refreshApplications();
        },
      ),

      body: vm.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: vm.applications.isEmpty
                  ? const Center(
                      child: Text(
                        "No Applications Submitted Yet",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount:
                          vm.applications.length,
                      itemBuilder: (context, index) {
                        final app =
                            vm.applications[index];

                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.only(
                              bottom: 15),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    15),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.all(
                                    12),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                  children: [
                                    Text(
                                      app.module1,
                                      style:
                                          const TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),

                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: app.status ==
                                                "Pending"
                                            ? Colors.orange
                                                .shade100
                                            : app.status ==
                                                    "Approved"
                                                ? Colors.green
                                                    .shade100
                                                : Colors.red
                                                    .shade100,
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    20),
                                      ),
                                      child: Text(
                                        app.status,
                                        style: TextStyle(
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color: app.status ==
                                                  "Pending"
                                              ? Colors
                                                  .orange
                                              : app.status ==
                                                      "Approved"
                                                  ? Colors
                                                      .green
                                                  : Colors
                                                      .red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                    height: 10),

                                Text(
                                  "Year of Study: ${app.yearOfStudy}",
                                ),

                                Text(
                                  "Module 1 Level: ${app.module1Level}",
                                ),

                                if (app.module2 != null &&
                                    app.module2!
                                        .isNotEmpty)
                                  Text(
                                    "Module 2: ${app.module2}",
                                  ),

                                if (app.module2Level !=
                                        null &&
                                    app.module2Level!
                                        .isNotEmpty)
                                  Text(
                                    "Module 2 Level: ${app.module2Level}",
                                  ),

                                const SizedBox(
                                    height: 15),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .end,
                                  children: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton
                                          .styleFrom(
                                        backgroundColor:
                                            Colors.red,
                                      ),
                                      onPressed: () async {
                                        if (app.id ==
                                            null) return;

                                        await vm
                                            .deleteApplication(
                                                app.id!);

                                        refreshApplications();

                                        if (!context
                                            .mounted) {
                                          return;
                                        }

                                        ScaffoldMessenger
                                                .of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Application cancelled",
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color:
                                            Colors.white,
                                      ),
                                      label: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color:
                                              Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
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