// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/core/global_functions/global_purpose_functions.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/admins_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/ads_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/dashboard_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/notificatoins_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/semesters_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/subjects_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/subscriptions_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/desktop_layout.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/mobile_layout.dart';

import '../../../core/layout/adaptive.dart';
import '../blocs/home/home_bloc.dart';
import 'adaptive_app_bar.dart';
import 'list_drawer.dart';

import 'dart:math' show pi;

enum TabsNumber {
  dashboardPage(0),
  subscriptionPage(1),
  adminsPage(2),
  semestersPage(3),
  subjectsPage(4),
  notificationPage(5),
  adsPage(6);

  const TabsNumber(this.order);

  final int order;
}

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({
    super.key,
    required this.body,
    this.currentRoute,
  });

  final Widget body;
  final String? currentRoute;
  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  late final HomeBloc _homeBloc;
  bool isInitialized = false;
  final isUserSuperAdmin = GlobalPurposeFunctions.getAdminModel()!.isSuperAdmin;
  final adminModel = GlobalPurposeFunctions.getAdminModel()!;

  Map<int, String> pageForIndexSuper = {
    TabsNumber.adminsPage.order: AdminsPage.routeName,
    TabsNumber.dashboardPage.order: DashboardPage.routeName,
    TabsNumber.subscriptionPage.order: SubscriptionsPage.routeName,
    TabsNumber.semestersPage.order: SemestersPage.routeName,
    TabsNumber.subjectsPage.order: SubjectsPage.routeName,
    TabsNumber.notificationPage.order: NotificationsPage.routeName,
    TabsNumber.adsPage.order: AdsPage.routeName,
  };

  Map<int, String> pageForIndexAdmin = {
    if (GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions)
      TabsNumber.subscriptionPage.order - 1: SubscriptionsPage.routeName,
    if (GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions)
      TabsNumber.semestersPage.order - 2: SemestersPage.routeName,
    if (GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions)
      TabsNumber.subjectsPage.order - 2: SubjectsPage.routeName,
    if (!GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions)
      TabsNumber.semestersPage.order - 3: SemestersPage.routeName,
    if (!GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions)
      TabsNumber.subjectsPage.order - 3: SubjectsPage.routeName,
    if (GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions &&
        GlobalPurposeFunctions.getAdminModel()!.canAddNotifications)
      TabsNumber.notificationPage.order - 2: NotificationsPage.routeName,
    if (!GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions &&
        GlobalPurposeFunctions.getAdminModel()!.canAddNotifications)
      TabsNumber.notificationPage.order - 3: NotificationsPage.routeName,
    if (GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions &&
        GlobalPurposeFunctions.getAdminModel()!.canAddNotifications &&
        GlobalPurposeFunctions.getAdminModel()!.canAddAds)
      TabsNumber.adsPage.order - 2: AdsPage.routeName,
    if (!GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions &&
        GlobalPurposeFunctions.getAdminModel()!.canAddNotifications &&
        GlobalPurposeFunctions.getAdminModel()!.canAddAds)
      TabsNumber.adsPage.order - 3: AdsPage.routeName,
    if (GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions &&
        !GlobalPurposeFunctions.getAdminModel()!.canAddNotifications &&
        GlobalPurposeFunctions.getAdminModel()!.canAddAds)
      TabsNumber.adsPage.order - 3: AdsPage.routeName,
    if (!GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions &&
        !GlobalPurposeFunctions.getAdminModel()!.canAddNotifications &&
        GlobalPurposeFunctions.getAdminModel()!.canAddAds)
      TabsNumber.adsPage.order - 4: AdsPage.routeName,
  };

  Map<String, int> indexForPageSuper = {
    AdminsPage.routeName: TabsNumber.adminsPage.order,
    DashboardPage.routeName: TabsNumber.dashboardPage.order,
    SubscriptionsPage.routeName: TabsNumber.subscriptionPage.order,
    SemestersPage.routeName: TabsNumber.semestersPage.order,
    SubjectsPage.routeName: TabsNumber.subjectsPage.order,
    NotificationsPage.routeName: TabsNumber.notificationPage.order,
    AdsPage.routeName: TabsNumber.adsPage.order,
  };
  Map<String, int> indexForPageAdmin = {
    if (GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions)
      SubscriptionsPage.routeName: TabsNumber.subscriptionPage.order - 1,
    if (GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions)
      SemestersPage.routeName: TabsNumber.semestersPage.order - 2,
    if (GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions)
      SubjectsPage.routeName: TabsNumber.subjectsPage.order - 2,
    if (!GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions)
      SemestersPage.routeName: TabsNumber.semestersPage.order - 3,
    if (!GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions)
      SubjectsPage.routeName: TabsNumber.subjectsPage.order - 3,
    if (GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions &&
        GlobalPurposeFunctions.getAdminModel()!.canAddNotifications)
      NotificationsPage.routeName: TabsNumber.notificationPage.order - 2,
    if (!GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions &&
        GlobalPurposeFunctions.getAdminModel()!.canAddNotifications)
      NotificationsPage.routeName: TabsNumber.notificationPage.order - 3,
    if (GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions &&
        GlobalPurposeFunctions.getAdminModel()!.canAddNotifications &&
        GlobalPurposeFunctions.getAdminModel()!.canAddAds)
      AdsPage.routeName: TabsNumber.adsPage.order - 2,
    if (!GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions &&
        GlobalPurposeFunctions.getAdminModel()!.canAddNotifications &&
        GlobalPurposeFunctions.getAdminModel()!.canAddAds)
      AdsPage.routeName: TabsNumber.adsPage.order - 3,
    if (GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions &&
        !GlobalPurposeFunctions.getAdminModel()!.canAddNotifications &&
        GlobalPurposeFunctions.getAdminModel()!.canAddAds)
      AdsPage.routeName: TabsNumber.adsPage.order - 3,
    if (!GlobalPurposeFunctions.getAdminModel()!.canAddSubscriptions &&
        !GlobalPurposeFunctions.getAdminModel()!.canAddNotifications &&
        GlobalPurposeFunctions.getAdminModel()!.canAddAds)
      AdsPage.routeName: TabsNumber.adsPage.order - 4,
  };
  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc();
    isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDesktop = isDisplayDesktop(context);

    String? currentRouteMapped =
        widget.currentRoute?.replaceAllMapped(RegExp(r'\?.*'), (match) => '');
    currentRouteMapped =
        currentRouteMapped?.replaceAllMapped(RegExp(r'\/.*'), (match) => '');

    if (currentRouteMapped != null &&
        isInitialized &&
        isUserSuperAdmin &&
        indexForPageSuper.containsKey(currentRouteMapped)) {
      _homeBloc.add(PageIndexChanged(indexForPageSuper[currentRouteMapped]!));
    } else if (currentRouteMapped != null &&
        isInitialized &&
        indexForPageAdmin.containsKey(currentRouteMapped)) {
      _homeBloc.add(PageIndexChanged(indexForPageAdmin[currentRouteMapped]!));
    }

    return BlocProvider(
      create: (context) => _homeBloc,
      child: Material(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: isDesktop
              ? DesktopLayout(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  body: widget.body,
                  navigatorDelegate: _navigatorDelegate,
                )
              : MobileLayout(
                  body: widget.body,
                ),
        ),
      ),
    );
  }

  void _navigatorDelegate(int index) {
    int actualIndex = index;
    context.goNamed(isUserSuperAdmin
        ? pageForIndexSuper[actualIndex]!
        : pageForIndexAdmin[actualIndex]!);
  }
}
