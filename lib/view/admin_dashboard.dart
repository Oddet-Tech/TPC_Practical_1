import 'package:final_tpg_project_p1/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();

    // Fetch all applications when screen loads
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
    final vm = Provider.of<ApplicationViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: vm.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: vm.applications.length,
              itemBuilder: (context, index) {
                final app = vm.applications[index];

                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Student ID: ${app.userId}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        SizedBox(height: 5),
                        Text("Year: ${app.yearOfStudy}"),

                        Text("Module 1: ${app.module1} (${app.module1Level})"),

                        if (app.module2 != null)
                          Text(
                            "Module 2: ${app.module2} (${app.module2Level})",
                          ),

                        SizedBox(height: 5),
                        Text("Status: ${app.status}"),

                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await vm.updateStatus(app.id, "approved");
                                vm.fetchAllApplications();
                              },
                              child: Text("Approve"),
                            ),

                            ElevatedButton(
                              onPressed: () async {
                                await vm.updateStatus(app.id, "rejected");
                                vm.fetchAllApplications();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text("Reject"),
                            ),

                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await vm.deleteApplication(app.id);
                                vm.fetchAllApplications();
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
