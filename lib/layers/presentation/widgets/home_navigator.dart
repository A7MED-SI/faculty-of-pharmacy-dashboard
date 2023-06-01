import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/admins_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/dashboard_page.dart';

import '../../../core/layout/adaptive.dart';
import '../blocs/home_bloc/home_bloc.dart';
import 'adaptive_app_bar.dart';
import 'list_drawer.dart';

import 'dart:math' show pi;

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({
    super.key,
    required this.body,
  });

  final Widget body;

  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  late final HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDesktop = isDisplayDesktop(context);

    if (isDesktop) {
      return BlocProvider(
        create: (context) => _homeBloc,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Material(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    NavigationRail(
                      backgroundColor: colorScheme.background,
                      extended: state.isExtended,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.lock_clock),
                          label: Text('المسؤولين'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(
                            Icons.alarm,
                          ),
                          label: Text('الفصول'),
                        ),
                      ],
                      selectedIndex: state.selectedIndex,
                      elevation: 4,
                      labelType: state.isExtended
                          ? NavigationRailLabelType.none
                          : NavigationRailLabelType.selected,
                      indicatorColor: colorScheme.primaryContainer,
                      unselectedLabelTextStyle: textTheme.bodyLarge!.copyWith(
                        color: colorScheme.onBackground,
                      ),
                      selectedLabelTextStyle: textTheme.bodyLarge!.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      selectedIconTheme:
                          IconThemeData(color: colorScheme.onPrimaryContainer),
                      leading: const _NavigationRailHeader(),
                      useIndicator: true,
                      onDestinationSelected: (newIndex) {
                        _homeBloc.add(PageIndexChanged(newIndex));
                        _navigatorDelegate(newIndex);
                      },
                    ),
                    Expanded(
                      child: Scaffold(
                        backgroundColor: colorScheme.surfaceVariant,
                        body: widget.body,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: const AdaptiveAppBar(),
          body: Container(),
          drawer: const ListDrawer(),
          floatingActionButton: FloatingActionButton(
            heroTag: 'Add',
            onPressed: () {},
            tooltip: "tooltip",
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
      );
    }
  }

  void _navigatorDelegate(int index) {
    switch (index) {
      case 0:
        context.goNamed(AdminsPage.routeName);
      case 1:
        context.goNamed(DashboardPage.routeName);
    }
  }
}

class _NavigationRailHeader extends StatelessWidget {
  const _NavigationRailHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final animation = NavigationRail.extendedAnimation(context);
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Align(
          alignment: AlignmentDirectional.centerStart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                      color: colorScheme.surfaceVariant,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 6),
                    Material(
                      child: InkWell(
                        key: const ValueKey('ReplyLogo'),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        onTap: () {
                          context.read<HomeBloc>().add(RailExtendingToggled());
                        },
                        child: Row(
                          children: [
                            Transform.rotate(
                              angle: animation.value * pi,
                              child: Icon(
                                Icons.arrow_right,
                                color: colorScheme.onBackground,
                                size: 16,
                              ),
                            ),
                            const Icon(Icons.flutter_dash),
                            const SizedBox(width: 30),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              widthFactor: animation.value,
                              child: Opacity(
                                opacity: animation.value,
                                child: Text(
                                  'DO IT RIGHT',
                                  style: textTheme.headlineMedium!.copyWith(
                                    color: colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 18 * animation.value),
                          ],
                        ),
                      ),
                    ),
                    if (animation.value > 0)
                      Opacity(
                        opacity: animation.value,
                        child: const SizedBox(width: 100),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
