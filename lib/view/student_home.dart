import 'package:final_tpg_project_p1/view/application_form_screen.dart';
import 'package:final_tpg_project_p1/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) return;

      Provider.of<ApplicationViewModel>(
        context,
        listen: false,
      ).fetchUserApplications(user.id);
    });
  }

  Future<void> refresh() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    await Provider.of<ApplicationViewModel>(
      context,
      listen: false,
    ).fetchUserApplications(user.id);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ApplicationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Home"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ApplicationFormScreen(),
            ),
          );

          await refresh();
        },
        child: const Icon(Icons.add),
      ),

      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.applications.isEmpty
              ? const Center(
                  child: Text(
                    "No Applications Submitted Yet",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app.module1,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text("Status: ${app.status}"),
                            Text("Year: ${app.yearOfStudy}"),
                            Text("Module 1 Level: ${app.module1Level}"),

                            if (app.module2 != null &&
                                app.module2!.isNotEmpty)
                              Text("Module 2: ${app.module2}"),

                            if (app.module2Level != null &&
                                app.module2Level!.isNotEmpty)
                              Text("Module 2 Level: ${app.module2Level}"),

                            const SizedBox(height: 12),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () async {
                                  if (app.id == null) return;

                                  await vm.deleteApplication(app.id!);
                                  await refresh();

                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Application cancelled"),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.cancel,
                                    color: Colors.red),
                                label: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
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