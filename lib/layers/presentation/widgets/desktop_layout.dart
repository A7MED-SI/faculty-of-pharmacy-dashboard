import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_dashboard/core/constants/images/svg_images.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/svg_image.dart';

import 'dart:math' show pi;

import '../../../core/constants/images/app_images.dart';
import '../blocs/home/home_bloc.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({
    super.key,
    required this.colorScheme,
    required this.textTheme,
    required this.body,
    required this.navigatorDelegate,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final Widget body;
  final void Function(int) navigatorDelegate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Row(
          children: [
            ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                padding:
                    !state.isExtended ? const EdgeInsets.only(left: 5) : null,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  child: IntrinsicHeight(
                    child: NavigationRail(
                      backgroundColor: colorScheme.background,
                      extended: state.isExtended,
                      destinations: const [
                        NavigationRailDestination(
                          icon: SvgImage(
                            SvgImages.statistics,
                            height: 30,
                          ),
                          label: Text('الإحصائيات'),
                        ),
                        NavigationRailDestination(
                          icon: SvgImage(
                            SvgImages.qr,
                            height: 30,
                          ),
                          label: Text('الاشتراكات'),
                        ),
                        NavigationRailDestination(
                          icon: SvgImage(
                            SvgImages.admin,
                            height: 30,
                          ),
                          label: Text('المسؤولين'),
                        ),
                        NavigationRailDestination(
                          icon: SvgImage(
                            SvgImages.graduationHat,
                            height: 30,
                          ),
                          label: Text('الفصول'),
                        ),
                        NavigationRailDestination(
                          icon: SvgImage(
                            SvgImages.books,
                            height: 30,
                          ),
                          label: Text('المواد'),
                        ),
                        NavigationRailDestination(
                          icon: SvgImage(
                            SvgImages.notificationBell,
                            height: 30,
                          ),
                          label: Text('الإشعارات'),
                        ),
                        NavigationRailDestination(
                          icon: SvgImage(
                            SvgImages.ads,
                            height: 30,
                          ),
                          label: Text('الإعلانات'),
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
                        context
                            .read<HomeBloc>()
                            .add(PageIndexChanged(newIndex));
                        navigatorDelegate(newIndex);
                      },
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Scaffold(
                backgroundColor: colorScheme.surfaceVariant,
                body: body,
              ),
            ),
          ],
        );
      },
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
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        hoverColor: Colors.black12,
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
                                size: 30,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: Image(
                                image: const AssetImage(AppImages.logoImage),
                                color: colorScheme.onBackground,
                              ),
                            ),
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
