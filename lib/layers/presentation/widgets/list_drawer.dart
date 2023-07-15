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
import 'package:pharmacy_dashboard/layers/presentation/widgets/svg_image.dart';

import '../../../core/constants/images/svg_images.dart';
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
                  icon: const SvgImage(
                    SvgImages.statistics,
                    height: 20,
                  ),
                  title: 'الإحصائيات',
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
                  icon: const SvgImage(
                    SvgImages.qr,
                    height: 20,
                  ),
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
                  icon: const SvgImage(
                    SvgImages.admin,
                    height: 20,
                  ),
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
                  icon: const SvgImage(
                    SvgImages.graduationHat,
                    height: 20,
                  ),
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
                  icon: const SvgImage(
                    SvgImages.books,
                    height: 20,
                  ),
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
                  icon: const SvgImage(
                    SvgImages.notificationBell,
                    height: 20,
                  ),
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
                  icon: const SvgImage(
                    SvgImages.ads,
                    height: 20,
                  ),
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
    required this.icon,
  });
  final bool selected;
  final String title;
  final VoidCallback onTap;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
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
    );
  }
}
