import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/core/global_functions/global_purpose_functions.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/auth/auth_bloc.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/admins_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/ads_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/dashboard_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/login_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/notificatoins_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/question_banks_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/semesters_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/subject_images_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/subscriptions_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/home_navigator.dart';

import 'layers/presentation/pages/questions_page.dart';
import 'layers/presentation/pages/subjects_page.dart';

GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

class MyRouter {
  static GoRouter getRouter(
      {required AuthState authState, required String? currentLocation}) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      observers: [BotToastNavigatorObserver()],
      initialLocation: currentLocation ?? '/${LoginPage.routeName}',
      redirect: (context, state) {
        bool isNotLoggedIn = GlobalPurposeFunctions.getAccessToken() == null;
        bool isInLoginPage = state.location == '/${LoginPage.routeName}';
        if (isNotLoggedIn) {
          return isInLoginPage ? null : '/${LoginPage.routeName}';
        }
        if (isInLoginPage) {
          final adminModel = GlobalPurposeFunctions.getAdminModel()!;
          final isUserSuperAdmin = adminModel.isSuperAdmin;
          final userCanAddSubs = adminModel.canAddSubscriptions;

          return isUserSuperAdmin
              ? '/${DashboardPage.routeName}'
              : userCanAddSubs
                  ? '/${SubscriptionsPage.routeName}'
                  : '/${SemestersPage.routeName}';
        }
        return null;
      },
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
                GlobalPurposeFunctions.setCurrentPath(state.location);
                return const DashboardPage();
              },
            ),
            GoRoute(
              name: AdminsPage.routeName,
              path: '/${AdminsPage.routeName}',
              builder: (context, state) {
                GlobalPurposeFunctions.setCurrentPath(state.location);
                return const AdminsPage();
              },
            ),
            GoRoute(
              name: SubscriptionsPage.routeName,
              path: '/${SubscriptionsPage.routeName}',
              builder: (context, state) {
                GlobalPurposeFunctions.setCurrentPath(state.location);
                return const SubscriptionsPage();
              },
            ),
            GoRoute(
              name: SemestersPage.routeName,
              path: '/${SemestersPage.routeName}',
              builder: (context, state) {
                GlobalPurposeFunctions.setCurrentPath(state.location);
                return const SemestersPage();
              },
            ),
            GoRoute(
              name: SubjectsPage.routeName,
              path: '/${SubjectsPage.routeName}',
              builder: (context, state) {
                GlobalPurposeFunctions.setCurrentPath(state.location);
                return SubjectsPage(
                  semesterId: state.queryParameters['semesterId'] != null
                      ? int.parse(state.queryParameters['semesterId']!)
                      : null,
                );
              },
              routes: [
                GoRoute(
                  name: QuestionBanksPage.routeName,
                  path: ':subId/${QuestionBanksPage.routeName}',
                  builder: (context, state) {
                    GlobalPurposeFunctions.setCurrentPath(state.location);
                    return QuestionBanksPage(
                      subjectId: int.parse(state.pathParameters['subId']!),
                    );
                  },
                  routes: [
                    GoRoute(
                      name: QuestionsPage.routeName,
                      path: ':qBankId/${QuestionsPage.routeName}',
                      builder: (context, state) {
                        GlobalPurposeFunctions.setCurrentPath(state.location);
                        return QuestionsPage(
                          questionBankId:
                              int.parse(state.pathParameters['qBankId']!),
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  name: SubjectImagesPage.routeName,
                  path: ':subId/${SubjectImagesPage.routeName}',
                  builder: (context, state) {
                    GlobalPurposeFunctions.setCurrentPath(state.location);
                    return SubjectImagesPage(
                      subjectId: int.parse(state.pathParameters['subId']!),
                      subjectName: state.queryParameters['subject']!,
                    );
                  },
                )
              ],
            ),
            GoRoute(
              name: NotificationsPage.routeName,
              path: '/${NotificationsPage.routeName}',
              builder: (context, state) {
                GlobalPurposeFunctions.setCurrentPath(state.location);
                return const NotificationsPage();
              },
            ),
            GoRoute(
              name: AdsPage.routeName,
              path: '/${AdsPage.routeName}',
              builder: (context, state) {
                GlobalPurposeFunctions.setCurrentPath(state.location);
                return const AdsPage();
              },
            )
          ],
        ),
      ],
    );
  }
}
