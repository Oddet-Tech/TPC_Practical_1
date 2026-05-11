import 'package:final_tpg_project_p1/model/models.dart';
import 'package:final_tpg_project_p1/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApplicationFormScreen extends StatefulWidget {
  const ApplicationFormScreen({super.key});

  @override
  State<ApplicationFormScreen> createState() =>
      _ApplicationFormScreenState();
}

class _ApplicationFormScreenState
    extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController yearController = TextEditingController();
  final TextEditingController module1Controller = TextEditingController();
  final TextEditingController module1LevelController =
      TextEditingController();
  final TextEditingController module2Controller =
      TextEditingController();
  final TextEditingController module2LevelController =
      TextEditingController();

  bool isEligible = false;
  bool isLoading = false;

  @override
  void dispose() {
    yearController.dispose();
    module1Controller.dispose();
    module1LevelController.dispose();
    module2Controller.dispose();
    module2LevelController.dispose();
    super.dispose();
  }

  Future<void> submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      final application = ApplicationModel(
        id: '',
        userId: user.id,
        yearOfStudy: int.parse(yearController.text.trim()),
        module1: module1Controller.text.trim(),
        module1Level: module1LevelController.text.trim(),
        module2: module2Controller.text.trim().isEmpty
            ? null
            : module2Controller.text.trim(),
        module2Level:
            module2LevelController.text.trim().isEmpty
                ? null
                : module2LevelController.text.trim(),
        isEligible: isEligible,
        documentUrl: '',
        status: 'Pending',
        createdAt: DateTime.now(),
      );

      await Provider.of<ApplicationViewModel>(
        context,
        listen: false,
      ).createApplication(application);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Application submitted successfully",
          ),
        ),
      );

      Navigator.pop(context, application);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to submit application: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    bool isNumber = false,
    bool requiredField = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType:
            isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (requiredField &&
              (value == null || value.trim().isEmpty)) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Application Form"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField(
                controller: yearController,
                label: "Year of Study",
                isNumber: true,
              ),

              buildTextField(
                controller: module1Controller,
                label: "Module 1",
              ),

              buildTextField(
                controller: module1LevelController,
                label: "Module 1 Level",
              ),

              buildTextField(
                controller: module2Controller,
                label: "Module 2 (Optional)",
                requiredField: false,
              ),

              buildTextField(
                controller: module2LevelController,
                label: "Module 2 Level (Optional)",
                requiredField: false,
              ),

              Card(
                child: SwitchListTile(
                  title: const Text(
                    "I meet the requirements",
                  ),
                  value: isEligible,
                  onChanged: (value) {
                    setState(() {
                      isEligible = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 25),

              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: submitApplication,
                        child: const Text(
                          "Submit Application",
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}