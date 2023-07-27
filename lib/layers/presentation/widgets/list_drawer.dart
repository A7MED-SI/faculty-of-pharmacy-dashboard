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
import 'package:pharmacy_dashboard/layers/presentation/widgets/home_navigator.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/logout_confirmation_dialog.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/svg_image.dart';

import '../../../core/constants/images/svg_images.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/home/home_bloc.dart';

class ListDrawer extends StatefulWidget {
  const ListDrawer({super.key});

  @override
  State<ListDrawer> createState() => _ListDrawerState();
}

class _ListDrawerState extends State<ListDrawer> {
  final isUserSuperAdmin = GlobalPurposeFunctions.getAdminModel()!.isSuperAdmin;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Drawer(
          child: SafeArea(
            child: ListView(
              children: [
                const SizedBox(height: 12),
                Text(
                  'DO IT RIGHT',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                if (isUserSuperAdmin)
                  DrawerTile(
                    icon: const SvgImage(
                      SvgImages.statistics,
                      height: 20,
                    ),
                    title: 'الإحصائيات',
                    selected: isTileSelected(
                        selectedIndex: state.selectedIndex,
                        tabsNumber: TabsNumber.dashboardPage),
                    onTap: () {
                      context.read<HomeBloc>().add(PageIndexChanged(
                          selectedPageIndex(TabsNumber.dashboardPage)));
                      context.goNamed(DashboardPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                DrawerTile(
                  icon: const SvgImage(
                    SvgImages.qr,
                    height: 20,
                  ),
                  title: 'الإشتراكات',
                  selected: isTileSelected(
                      selectedIndex: state.selectedIndex,
                      tabsNumber: TabsNumber.subscriptionPage),
                  onTap: () {
                    context.read<HomeBloc>().add(PageIndexChanged(
                        selectedPageIndex(TabsNumber.subscriptionPage)));
                    context.goNamed(SubscriptionsPage.routeName);
                    Scaffold.of(context).closeDrawer();
                  },
                ),
                if (isUserSuperAdmin)
                  DrawerTile(
                    icon: const SvgImage(
                      SvgImages.admin,
                      height: 20,
                    ),
                    title: 'المسؤولين',
                    selected: isTileSelected(
                        selectedIndex: state.selectedIndex,
                        tabsNumber: TabsNumber.adminsPage),
                    onTap: () {
                      context.read<HomeBloc>().add(PageIndexChanged(
                          selectedPageIndex(TabsNumber.adminsPage)));
                      context.goNamed(AdminsPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                DrawerTile(
                  icon: const SvgImage(
                    SvgImages.graduationHat,
                    height: 20,
                  ),
                  title: 'الفصول',
                  selected: isTileSelected(
                      selectedIndex: state.selectedIndex,
                      tabsNumber: TabsNumber.semestersPage),
                  onTap: () {
                    context.read<HomeBloc>().add(PageIndexChanged(
                        selectedPageIndex(TabsNumber.semestersPage)));
                    context.goNamed(SemestersPage.routeName);
                    Scaffold.of(context).closeDrawer();
                  },
                ),
                DrawerTile(
                  icon: const SvgImage(
                    SvgImages.books,
                    height: 20,
                  ),
                  title: 'المواد',
                  selected: isTileSelected(
                      selectedIndex: state.selectedIndex,
                      tabsNumber: TabsNumber.subjectsPage),
                  onTap: () {
                    context.read<HomeBloc>().add(PageIndexChanged(
                        selectedPageIndex(TabsNumber.subjectsPage)));
                    context.goNamed(SubjectsPage.routeName);
                    Scaffold.of(context).closeDrawer();
                  },
                ),
                DrawerTile(
                  icon: const SvgImage(
                    SvgImages.notificationBell,
                    height: 20,
                  ),
                  title: 'الإشعارات',
                  selected: isTileSelected(
                      selectedIndex: state.selectedIndex,
                      tabsNumber: TabsNumber.notificationPage),
                  onTap: () {
                    context.read<HomeBloc>().add(PageIndexChanged(
                        selectedPageIndex(TabsNumber.notificationPage)));
                    context.goNamed(NotificationsPage.routeName);
                    Scaffold.of(context).closeDrawer();
                  },
                ),
                DrawerTile(
                  icon: const SvgImage(
                    SvgImages.ads,
                    height: 20,
                  ),
                  title: 'الإعلانات',
                  selected: isTileSelected(
                      selectedIndex: state.selectedIndex,
                      tabsNumber: TabsNumber.adsPage),
                  onTap: () {
                    context.read<HomeBloc>().add(PageIndexChanged(
                        selectedPageIndex(TabsNumber.adsPage)));
                    context.goNamed(AdsPage.routeName);
                    Scaffold.of(context).closeDrawer();
                  },
                ),
                DrawerTile(
                  icon: const SvgImage(
                    SvgImages.logout,
                    height: 20,
                  ),
                  isLast: true,
                  title: 'تسجيل الخروج',
                  selected: false,
                  onTap: () async {
                    final authBloc = context.read<AuthBloc>();
                    final result = await showDialog<bool?>(
                      context: context,
                      builder: (context) {
                        return const LogoutConfirmationDialog();
                      },
                    );
                    if (result != null && result) {
                      authBloc.add(LogoutSubmitted());
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isTileSelected(
      {required int selectedIndex, required TabsNumber tabsNumber}) {
    if (isUserSuperAdmin) {
      return selectedIndex == tabsNumber.order;
    }
    if (tabsNumber == TabsNumber.subscriptionPage) {
      return selectedIndex == tabsNumber.order - 1;
    }
    return selectedIndex == tabsNumber.order - 2;
  }

  int selectedPageIndex(TabsNumber tabsNumber) {
    if (isUserSuperAdmin) {
      return tabsNumber.order;
    }
    if (tabsNumber == TabsNumber.subscriptionPage) {
      return tabsNumber.order - 1;
    }
    return tabsNumber.order - 2;
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.onTap,
    required this.selected,
    required this.title,
    required this.icon,
    this.isLast = false,
  });
  final bool selected;
  final String title;
  final VoidCallback onTap;
  final Widget icon;
  final bool isLast;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        ListTile(
          enabled: true,
          selected: selected,
          leading: icon,
          title: Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              color: selected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onBackground,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selectedColor: colorScheme.primary,
          selectedTileColor: colorScheme.primaryContainer,
          onTap: onTap,
        ),
        if (!isLast)
          const Divider(
            endIndent: 10,
            indent: 10,
          ),
      ],
    );
  }
}
