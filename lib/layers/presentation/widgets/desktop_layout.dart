import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_dashboard/core/constants/images/svg_images.dart';
import 'package:pharmacy_dashboard/core/global_functions/global_purpose_functions.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/auth/auth_bloc.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/svg_image.dart';

import 'dart:math' show pi;

import '../../../core/constants/images/app_images.dart';
import '../blocs/home/home_bloc.dart';
import 'logout_confirmation_dialog.dart';

class DesktopLayout extends StatefulWidget {
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
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  late final bool isUserSuperAdmin;

  @override
  void initState() {
    super.initState();
    isUserSuperAdmin = GlobalPurposeFunctions.getAdminModel()!.isSuperAdmin;
  }

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
                      backgroundColor: widget.colorScheme.background,
                      extended: state.isExtended,
                      destinations: [
                        if (isUserSuperAdmin)
                          const NavigationRailDestination(
                            icon: SvgImage(
                              SvgImages.statistics,
                              height: 25,
                            ),
                            label: Text('الإحصائيات'),
                          ),
                        if (isUserSuperAdmin)
                          const NavigationRailDestination(
                            icon: SvgImage(
                              SvgImages.qr,
                              height: 25,
                            ),
                            label: Text('الاشتراكات'),
                          ),
                        if (isUserSuperAdmin)
                          const NavigationRailDestination(
                            icon: SvgImage(
                              SvgImages.admin,
                              height: 25,
                            ),
                            label: Text('المسؤولين'),
                          ),
                        const NavigationRailDestination(
                          icon: SvgImage(
                            SvgImages.graduationHat,
                            height: 25,
                          ),
                          label: Text('الفصول'),
                        ),
                        const NavigationRailDestination(
                          icon: SvgImage(
                            SvgImages.books,
                            height: 25,
                          ),
                          label: Text('المواد'),
                        ),
                        const NavigationRailDestination(
                          icon: SvgImage(
                            SvgImages.notificationBell,
                            height: 25,
                          ),
                          label: Text('الإشعارات'),
                        ),
                        const NavigationRailDestination(
                          icon: SvgImage(
                            SvgImages.ads,
                            height: 25,
                          ),
                          label: Text('الإعلانات'),
                        ),
                      ],
                      selectedIndex: state.selectedIndex,
                      elevation: 4,
                      labelType: state.isExtended
                          ? NavigationRailLabelType.none
                          : NavigationRailLabelType.selected,
                      indicatorColor: widget.colorScheme.primaryContainer,
                      unselectedLabelTextStyle:
                          widget.textTheme.bodyLarge!.copyWith(
                        color: widget.colorScheme.onBackground,
                      ),
                      selectedLabelTextStyle:
                          widget.textTheme.bodyLarge!.copyWith(
                        color: widget.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      selectedIconTheme: IconThemeData(
                          color: widget.colorScheme.onPrimaryContainer),
                      leading: const _NavigationRailHeader(),
                      trailing: IconButton(
                        icon: const SvgImage(
                          SvgImages.logout,
                          height: 25,
                        ),
                        tooltip: 'تسجيل الخروج',
                        onPressed: () async {
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
                      useIndicator: true,
                      onDestinationSelected: (newIndex) {
                        log('Current Destination Index $newIndex');
                        context
                            .read<HomeBloc>()
                            .add(PageIndexChanged(newIndex));
                        widget.navigatorDelegate(newIndex);
                      },
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Scaffold(
                backgroundColor: widget.colorScheme.surfaceVariant,
                body: widget.body,
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
          child: Container(
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
            child: Column(
              children: [
                Row(
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
                                size: 25,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: Image(
                                image: const AssetImage(AppImages.logoImage),
                                color: colorScheme.onBackground,
                              ),
                            ),
                            const SizedBox(width: 25),
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
                  ],
                ),
                if (animation.value > 0)
                  Align(
                    alignment: AlignmentDirectional.center,
                    widthFactor: animation.value,
                    child: Opacity(
                      opacity: animation.value,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgImage(
                            SvgImages.user,
                            height: 20,
                            color: colorScheme.onBackground,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            GlobalPurposeFunctions.getAdminModel()!.username,
                            style: textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
