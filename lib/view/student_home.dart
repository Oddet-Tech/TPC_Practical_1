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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ApplicationFormScreen(),
                        ),
                      );
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
                                child: ListTile(
                                  title: Text("Module: ${app.module1}"),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Year: ${app.yearOfStudy}"),
                                      Text("Status: ${app.status}"),
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
}
