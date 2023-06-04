import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/admins_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/ads_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/dashboard_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/login_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/notificatoins_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/semesters_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/subscriptions_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/home_navigator.dart';

import 'layers/presentation/pages/subjects_page.dart';

GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: '/dashboard',
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      name: LoginPage.routeName,
      path: '/${LoginPage.routeName}',
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return HomeNavigator(
          body: child,
          currentRoute: state.location.substring(1),
        );
      },
      routes: [
        GoRoute(
          name: DashboardPage.routeName,
          path: '/${DashboardPage.routeName}',
          builder: (context, state) {
            return const DashboardPage();
          },
        ),
        GoRoute(
          name: AdminsPage.routeName,
          path: '/${AdminsPage.routeName}',
          builder: (context, state) {
            return const AdminsPage();
          },
        ),
        GoRoute(
          name: SubscriptionsPage.routeName,
          path: '/${SubscriptionsPage.routeName}',
          builder: (context, state) {
            return const SubscriptionsPage();
          },
        ),
        GoRoute(
          name: SemestersPage.routeName,
          path: '/${SemestersPage.routeName}',
          builder: (context, state) {
            return const SemestersPage();
          },
        ),
        GoRoute(
          name: SubjectsPage.routeName,
          path: '/${SubjectsPage.routeName}',
          builder: (context, state) {
            return const SubjectsPage();
          },
        ),
        GoRoute(
          name: NotificationsPage.routeName,
          path: '/${NotificationsPage.routeName}',
          builder: (context, state) {
            return const NotificationsPage();
          },
        ),
        GoRoute(
          name: AdsPage.routeName,
          path: '/${AdsPage.routeName}',
          builder: (context, state) {
            return const AdsPage();
          },
        )
      ],
    ),
  ],
);
