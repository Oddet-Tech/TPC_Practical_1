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
            Text(
              '${vm.applications.length} total',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () =>
                Provider.of<ApplicationViewModel>(context, listen: false)
                    .fetchAllApplications(),
          ),
        ],
      ),

      body: Column(
        children: [
          if (vm.errorMessage != null)
            Container(
              width: double.infinity,
              color: Colors.red.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                vm.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),

          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.applications.isEmpty
                    ? const Center(
                        child: Text(
                          'No applications yet',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: vm.applications.length,
                        itemBuilder: (context, index) {
                          final app = vm.applications[index];
                          final status = app.status.toLowerCase();

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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'ID: ${app.userId.length > 8 ? '${app.userId.substring(0, 8)}...' : app.userId}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black54,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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

                                  _infoRow(Icons.school_outlined,
                                      'Year of Study', '${app.yearOfStudy}'),
                                  const SizedBox(height: 6),
                                  _infoRow(Icons.book_outlined, 'Module',
                                      '${app.module1} — Level ${app.module1Level}'),
                                  if (app.module2Level != null &&
                                      app.module2Level!.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    _infoRow(Icons.book, 'Module 2 Level',
                                        app.module2Level!),
                                  ],

                                  const SizedBox(height: 16),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: status == 'approved'
                                              ? null
                                              : () async {
                                                  if (app.id == null) return;
                                                  await vm.updateStatus(
                                                      app.id!, 'approved');
                                                  if (!context.mounted) return;
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        vm.errorMessage ??
                                                            'Application approved'),
                                                    backgroundColor:
                                                        vm.errorMessage != null
                                                            ? Colors.red
                                                            : Colors.green,
                                                  ));
                                                },
                                          icon: const Icon(Icons.check,
                                              size: 16),
                                          label: const Text('Approve'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.green,
                                            side: const BorderSide(
                                                color: Colors.green),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: status == 'rejected'
                                              ? null
                                              : () async {
                                                  if (app.id == null) return;
                                                  await vm.updateStatus(
                                                      app.id!, 'rejected');
                                                  if (!context.mounted) return;
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        vm.errorMessage ??
                                                            'Application rejected'),
                                                    backgroundColor:
                                                        vm.errorMessage != null
                                                            ? Colors.red
                                                            : Colors.orange,
                                                  ));
                                                },
                                          icon: const Icon(Icons.close,
                                              size: 16),
                                          label: const Text('Reject'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            side: const BorderSide(
                                                color: Colors.red),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.grey),
                                        onPressed: () async {
                                          if (app.id == null) return;
                                          await vm.deleteApplication(app.id!);
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(vm.errorMessage ??
                                                'Application deleted'),
                                            backgroundColor:
                                                vm.errorMessage != null
                                                    ? Colors.red
                                                    : Colors.green,
                                          ));
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
