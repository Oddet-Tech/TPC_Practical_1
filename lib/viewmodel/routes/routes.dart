//Group P1 members: Shilenge Oddet 223015126
//Brandon Lombaard 223021599
//Motloli TJ 22206982
//Quadri PF 224017653
//Asive Mnyamazi 224113476
//Selahla KO 221007346
// Makhanye NJ 220000689

import 'package:final_tpg_project_p1/view/login.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/';
  static const String studentHome = '/student/home';
  static const String applicationForm = '/student/apply';
  static const String applicationDetail = '/student/detail';
  static const String adminDashboard = '/admin/dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      // TODO (view team): replace _Placeholder with StudentHomeScreen
      case studentHome:
        return MaterialPageRoute(
          builder: (_) => const _Placeholder('Student Home'),
        );

      // TODO (view team): replace _Placeholder with ApplicationFormScreen
      case applicationForm:
        return MaterialPageRoute(
          builder: (_) => const _Placeholder('Application Form'),
        );

      // TODO (view team): replace _Placeholder with ApplicationDetailScreen
      // settings.arguments will be an ApplicationModel
      case applicationDetail:
        return MaterialPageRoute(
          builder: (_) => const _Placeholder('Application Detail'),
        );

      // TODO (view team): replace _Placeholder with AdminDashboardScreen
      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const _Placeholder('Admin Dashboard'),
        );

      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}

class _Placeholder extends StatelessWidget {
  final String label;
  const _Placeholder(this.label);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(child: Text('$label — coming soon')),
    );
  }
}
