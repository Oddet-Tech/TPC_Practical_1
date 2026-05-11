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
      id: '', // Supabase can auto-generate if configured
      userId: user!.id,
      yearOfStudy: int.parse(yearController.text),
      module1: module1Controller.text,
      module1Level: module1LevelController.text,
      module2: module2Controller.text.isEmpty ? null : module2Controller.text,
      module2Level: module2LevelController.text.isEmpty
          ? null
          : module2LevelController.text,
      isEligible: isEligible,
      documentUrl: '', // skip for now or add later
      status: 'pending',
      createdAt: DateTime.now(),
    );

    try {
      await Provider.of<ApplicationViewModel>(
        context,
        listen: false,
      ).createApplication(app);
       bool submissionSuccessful = true; // if no exception was thrown, it succeeded

      if (submissionSuccessful) {
        // Fetch the latest applications
        if (user != null) {
          final viewModel = Provider.of<ApplicationViewModel>(context, listen: false);
          await viewModel.fetchUserApplications(user.id);
        }

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
      appBar: AppBar(title: Text("Apply")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: yearController,
                decoration: InputDecoration(labelText: "Year of Study"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter year" : null,
              ),

              TextFormField(
                controller: module1Controller,
                decoration: InputDecoration(labelText: "Module 1"),
                validator: (value) => value!.isEmpty ? "Enter module 1" : null,
              ),

              TextFormField(
                controller: module1LevelController,
                decoration: InputDecoration(labelText: "Module 1 Level"),
                validator: (value) => value!.isEmpty ? "Enter level" : null,
              ),

              TextFormField(
                controller: module2Controller,
                decoration: InputDecoration(labelText: "Module 2 (Optional)"),
              ),

              TextFormField(
                controller: module2LevelController,
                decoration: InputDecoration(
                  labelText: "Module 2 Level (Optional)",
                ),
              ),

              SwitchListTile(
                title: Text("I meet the requirements"),
                value: isEligible,
                onChanged: (value) {
                  setState(() {
                    isEligible = value;
                  });
                },
              ),

              SizedBox(height: 20),

              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: submitApplication,
                      child: Text("Submit Application"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
