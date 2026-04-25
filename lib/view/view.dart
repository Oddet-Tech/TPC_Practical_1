import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/viewmodel.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ApplicationViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Test Screen")),
      body: Center(
        child: vm.isLoading
            ? CircularProgressIndicator()
            : Text("Applications: ${vm.applications.length}"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          vm.fetchAllApplications(); // test admin fetch
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}