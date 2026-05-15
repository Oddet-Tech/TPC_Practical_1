import 'package:final_tpg_project_p1/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


//admin will access all Applications and
// will have the ability to approve, reject, or delete them.
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<ApplicationViewModel>(context, listen: false)
            .fetchAllApplications();
      }
    });
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.hourglass_empty;
    }
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ApplicationViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!vm.isLoading)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${vm.applications.length} total',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            ),
        ],
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

          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.applications.isEmpty
                    ? const Center(
                        child: Text(
                          'No applications yet',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
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
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black38),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.black45, fontSize: 13),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
