import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/admins_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/dashboard_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/login_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/home_navigator.dart';

final GoRouter router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      name: LoginPage.routeName,
      path: '/login',
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return HomeNavigator(body: child);
      },
      routes: [
        GoRoute(
          name: DashboardPage.routeName,
          path: '/dashboard',
          builder: (context, state) {
            return const DashboardPage();
          },
        ),
        GoRoute(
          name: AdminsPage.routeName,
          path: '/admins',
          builder: (context, state) {
            return const AdminsPage();
          },
        )
      ],
    ),
  ],
);
