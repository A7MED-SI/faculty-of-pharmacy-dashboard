import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/admins_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/ads_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/dashboard_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/notificatoins_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/semesters_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/subjects_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/subscriptions_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/home_navigator.dart';

import '../blocs/home/home_bloc.dart';

class ListDrawer extends StatefulWidget {
  const ListDrawer({super.key});

  @override
  State<ListDrawer> createState() => _ListDrawerState();
}

class _ListDrawerState extends State<ListDrawer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Drawer(
          child: SafeArea(
            child: ListView(
              children: [
                DrawerTile(
                  title: 'لوحة التحكم',
                  selected:
                      state.selectedIndex == TabsNumber.dashboardPage.order,
                  onTap: () {
                    context
                        .read<HomeBloc>()
                        .add(PageIndexChanged(TabsNumber.dashboardPage.order));
                    context.goNamed(DashboardPage.routeName);
                  },
                ),
                DrawerTile(
                  title: 'الإشتراكات',
                  selected:
                      state.selectedIndex == TabsNumber.subscriptionPage.order,
                  onTap: () {
                    context.read<HomeBloc>().add(
                        PageIndexChanged(TabsNumber.subscriptionPage.order));
                    context.goNamed(SubscriptionsPage.routeName);
                  },
                ),
                DrawerTile(
                  title: 'المسؤولين',
                  selected: state.selectedIndex == TabsNumber.adminsPage.order,
                  onTap: () {
                    context
                        .read<HomeBloc>()
                        .add(PageIndexChanged(TabsNumber.adminsPage.order));
                    context.goNamed(AdminsPage.routeName);
                  },
                ),
                DrawerTile(
                  title: 'الفصول',
                  selected:
                      state.selectedIndex == TabsNumber.semestersPage.order,
                  onTap: () {
                    context
                        .read<HomeBloc>()
                        .add(PageIndexChanged(TabsNumber.semestersPage.order));
                    context.goNamed(SemestersPage.routeName);
                  },
                ),
                DrawerTile(
                  title: 'المواد',
                  selected:
                      state.selectedIndex == TabsNumber.subjectsPage.order,
                  onTap: () {
                    context
                        .read<HomeBloc>()
                        .add(PageIndexChanged(TabsNumber.subjectsPage.order));
                    context.goNamed(SubjectsPage.routeName);
                  },
                ),
                DrawerTile(
                  title: 'الإشعارات',
                  selected:
                      state.selectedIndex == TabsNumber.notificationPage.order,
                  onTap: () {
                    context.read<HomeBloc>().add(
                        PageIndexChanged(TabsNumber.notificationPage.order));
                    context.goNamed(NotificationsPage.routeName);
                  },
                ),
                DrawerTile(
                  title: 'الإعلانات',
                  selected: state.selectedIndex == TabsNumber.adsPage.order,
                  onTap: () {
                    context
                        .read<HomeBloc>()
                        .add(PageIndexChanged(TabsNumber.adsPage.order));
                    context.goNamed(AdsPage.routeName);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.onTap,
    required this.selected,
    required this.title,
  });
  final bool selected;
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      enabled: true,
      selected: selected,
      leading: const Icon(Icons.favorite),
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
    );
  }
}
