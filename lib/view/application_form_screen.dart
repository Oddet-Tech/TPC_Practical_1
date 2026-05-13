import 'package:final_tpg_project_p1/model/models.dart';
import 'package:final_tpg_project_p1/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApplicationFormScreen extends StatefulWidget {
  const ApplicationFormScreen({super.key});

  @override
  ApplicationFormScreenState createState() => ApplicationFormScreenState();
}

class ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController yearController = TextEditingController();
  final TextEditingController module1Controller = TextEditingController();
  final TextEditingController module1LevelController = TextEditingController();
  final TextEditingController module2Controller = TextEditingController();
  final TextEditingController module2LevelController = TextEditingController();

  bool isEligible = false;
  bool isLoading = false;

  void submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final user = Supabase.instance.client.auth.currentUser;

    final app = ApplicationModel(
      id: '',
      userId: user!.id,
      yearOfStudy: int.parse(yearController.text),
      module1: module1Controller.text,
      module1Level: module1LevelController.text,
      module2: module2Controller.text.isEmpty ? null : module2Controller.text,
      module2Level: module2LevelController.text.isEmpty
          ? null
          : module2LevelController.text,
      isEligible: isEligible,
      documentUrl: '',
      status: 'pending',
      createdAt: DateTime.now(),
    );

    try {
      await Provider.of<ApplicationViewModel>(
        context,
        listen: false,
      ).createApplication(app);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Application submitted")));

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Application failed: $e")));
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF48CAE4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 24, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Apply for Tutoring',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          'Fill in the details below',
                          style: TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // White rounded sheet
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                      children: [
                        // Section: Study Info
                        _sectionLabel('Study Information'),
                        const SizedBox(height: 12),
                        _buildField(
                          controller: yearController,
                          label: 'Year of Study',
                          icon: Icons.calendar_today_outlined,
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v!.isEmpty ? 'Enter year of study' : null,
                        ),
                        const SizedBox(height: 28),

                        // Section: Module 1
                        _sectionLabel('Module 1'),
                        const SizedBox(height: 12),
                        _buildField(
                          controller: module1Controller,
                          label: 'Module Name',
                          icon: Icons.book_outlined,
                          validator: (v) =>
                              v!.isEmpty ? 'Enter module 1' : null,
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          controller: module1LevelController,
                          label: 'Module Level',
                          icon: Icons.bar_chart_outlined,
                          validator: (v) => v!.isEmpty ? 'Enter level' : null,
                        ),
                        const SizedBox(height: 28),

                        // Section: Module 2
                        _sectionLabel('Module 2 (Optional)'),
                        const SizedBox(height: 12),
                        _buildField(
                          controller: module2Controller,
                          label: 'Module Name',
                          icon: Icons.book_outlined,
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          controller: module2LevelController,
                          label: 'Module Level',
                          icon: Icons.bar_chart_outlined,
                        ),
                        const SizedBox(height: 28),

                        // Eligibility toggle
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            title: const Text(
                              'I meet the requirements',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            subtitle: const Text(
                              'Confirm your eligibility for this application',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                              ),
                            ),
                            value: isEligible,

                            onChanged: (value) =>
                                setState(() => isEligible = value),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Submit button
                        isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF6C63FF),
                                ),
                              )
                            : ElevatedButton.icon(
                                onPressed: submitApplication,
                                icon: const Icon(Icons.send_outlined, size: 18),
                                label: const Text(
                                  'Submit Application',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6C63FF),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Color(0xFF6C63FF),
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black45, fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}
