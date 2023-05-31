import 'package:flutter/material.dart';
import 'package:pharmacy_dashboard/core/layout/adaptive.dart';
import 'dart:math' show pi;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_dashboard/layers/presentation/blocs/home_bloc/home_bloc.dart';

const appBarDesktopHeight = 128.0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                      },
                    ),
                    Expanded(
                      child: Scaffold(
                        backgroundColor: colorScheme.surfaceVariant,
                        body: Container(),
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
}

class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdaptiveAppBar({
    super.key,
    this.isDesktop = false,
  });

  final bool isDesktop;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: !isDesktop,
      title: isDesktop ? null : const SelectableText("Appbar"),
      backgroundColor: themeData.colorScheme.primary,
      bottom: isDesktop
          ? PreferredSize(
              preferredSize: const Size.fromHeight(26),
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                margin: const EdgeInsetsDirectional.fromSTEB(72, 0, 0, 22),
                child: SelectableText(
                  "Appbar",
                  style: themeData.textTheme.titleLarge!.copyWith(
                    color: Colors.black,
                  ),
                ),
              ),
            )
          : null,
      actions: const [],
    );
  }
}

class ListDrawer extends StatefulWidget {
  const ListDrawer({super.key});

  @override
  State<ListDrawer> createState() => _ListDrawerState();
}

class _ListDrawerState extends State<ListDrawer> {
  static const numItems = 9;

  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const ListTile(
              title: SelectableText(
                "Dashboard",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              subtitle: SelectableText(
                '',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            const Divider(),
            ...Iterable<int>.generate(numItems).toList().map((i) {
              return ListTile(
                enabled: true,
                selected: i == selectedItem,
                leading: const Icon(Icons.favorite),
                title: Text(
                  'Item $i',
                ),
                onTap: () {
                  setState(() {
                    selectedItem = i;
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
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
