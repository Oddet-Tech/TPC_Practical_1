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
        title: const Text("My Applications"),
        centerTitle: true,
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ApplicationFormScreen(),
            ),
          );
          await _refreshApplications();
        },
        child: const Icon(Icons.add),
      ),

      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.applications.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inbox_outlined,
                          size: 64, color: Colors.black26),
                      SizedBox(height: 12),
                      Text(
                        'No applications submitted yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black45,
                        ),
                      ),
                    ],
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
                        margin: const EdgeInsets.only(bottom: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header: module name + status badge
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    app.module1.isEmpty
                                        ? 'Application'
                                        : app.module1,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _statusColor(app.status)
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: _statusColor(app.status),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _statusIcon(app.status),
                                          size: 14,
                                          color: _statusColor(app.status),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _capitalize(app.status),
                                          style: TextStyle(
                                            color: _statusColor(app.status),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const Divider(height: 20),

                              _infoRow(Icons.school_outlined, 'Year of Study',
                                  '${app.yearOfStudy}'),
                              const SizedBox(height: 6),
                              _infoRow(Icons.book_outlined, 'Module Level',
                                  app.module1Level),
                              if (app.module2Level != null &&
                                  app.module2Level!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                _infoRow(Icons.book, 'Module 2 Level',
                                    app.module2Level!),
                              ],

                              const SizedBox(height: 14),

                              Align(
                                alignment: Alignment.centerRight,
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    if (app.id == null) return;
                                    final messenger =
                                        ScaffoldMessenger.of(context);
                                    await vm.deleteApplication(app.id!);
                                    await _refreshApplications();
                                    if (!mounted) return;
                                    messenger.showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Application cancelled'),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.close, size: 16),
                                  label: const Text('Cancel'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
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
