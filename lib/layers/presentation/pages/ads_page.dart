import 'dart:typed_data';

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/core/layout/adaptive.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/ad/add_ad.dart';
import 'package:pharmacy_dashboard/layers/presentation/AppWidgetsDisplayer.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/ads/ads_bloc.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/app_text_button.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/loading_widget.dart';

import '../widgets/app_elevated_button.dart';

class AdsPage extends StatefulWidget {
  const AdsPage({super.key});
  static const routeName = 'ads';

  @override
  State<AdsPage> createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  late final AdsBloc _adsBloc;

  @override
  void initState() {
    super.initState();
    _adsBloc = AdsBloc();
    _adsBloc.add(AdsFetched());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // ignore: unused_local_variable
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = isDisplayDesktop(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorScheme.surfaceVariant,
        body: BlocConsumer<AdsBloc, AdsState>(
          listener: (context, state) {
            if (state.addingAdStatus == AddingAdStatus.failed) {
              AppWidgetsDisplayer.dispalyErrorSnackBar(
                context: context,
                message: 'فشل الإضافة يرجى التحقق من الإنترنت والمحاولة لاحقا',
              );
            }
            if (state.addingAdStatus == AddingAdStatus.success) {
              AppWidgetsDisplayer.dispalySuccessSnackBar(
                context: context,
                message: 'تم إضافة الإعلان بنجاح',
              );
            }
          },
          bloc: _adsBloc,
          builder: (context, state) {
            return state.adsFetchingStatus == AdsFetchingStatus.initial ||
                    state.adsFetchingStatus == AdsFetchingStatus.loading
                ? const LoadingWidget()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12, top: 12),
                        child: AppTextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return _AdAddDialog(adsBloc: _adsBloc);
                                });
                          },
                          text: 'إضافة إعلان',
                        ),
                      ),
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 20),
                              sliver: SliverGrid.count(
                                crossAxisCount: isDesktop ? 6 : 2,
                                children: [
                                  for (var ad in state.ads)
                                    Stack(
                                      children: [
                                        Image.network(
                                          ad.image,
                                          fit: BoxFit.fill,
                                          height: 80,
                                        ),
                                        Positioned(
                                          bottom: 6,
                                          right: 8,
                                          child: Switch(
                                            onChanged: (value) {},
                                            value: ad.isActive == 1,
                                            activeColor: colorScheme.primary,
                                          ),
                                        )
                                      ],
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class _AdAddDialog extends StatefulWidget {
  const _AdAddDialog({
    required this.adsBloc,
  });
  final AdsBloc adsBloc;
  @override
  State<_AdAddDialog> createState() => _AdAddDialogState();
}

class _AdAddDialogState extends State<_AdAddDialog> {
  late final ValueNotifier<Uint8List?> imageNotifier;
  String? imageExtension;
  @override
  void initState() {
    super.initState();
    imageNotifier = ValueNotifier(null);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = isDisplayDesktop(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      insetPadding: isDesktop
          ? const EdgeInsets.symmetric(horizontal: 300)
          : const EdgeInsets.symmetric(horizontal: 60),
      backgroundColor: colorScheme.background,
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: ValueListenableBuilder(
                valueListenable: imageNotifier,
                builder: (context, image, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'إضافة إعلان',
                        style: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 80),
                      if (image == null)
                        TextButton(
                          onPressed: () async {
                            final FilePickerResult? result =
                                await FilePickerWeb.platform.pickFiles(
                              type: FileType.image,
                            );
                            if (result != null) {
                              imageNotifier.value = result.files.first.bytes!;
                              imageExtension = result.files.first.extension;
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: colorScheme.primaryContainer,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'اختيار صورة',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.image,
                                color: colorScheme.onPrimaryContainer,
                              )
                            ],
                          ),
                        ),
                      if (image != null)
                        Center(
                          child: Stack(
                            children: [
                              Image.memory(
                                image,
                                width: 200,
                                height: 150,
                                fit: BoxFit.fill,
                              ),
                              Positioned(
                                left: 4,
                                top: 4,
                                child: Tooltip(
                                  message: 'حذف الصورة',
                                  child: InkWell(
                                    onTap: () {
                                      imageNotifier.value = null;
                                      imageExtension = null;
                                    },
                                    child: Icon(
                                      Icons.cancel,
                                      color: colorScheme.secondary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: Text(
                                'إلغاء',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            AppElevatedButton(
                              onPressed: () {
                                widget.adsBloc.add(AdAdded(
                                    addAdParams: AddAdParams(
                                  image: imageNotifier.value!,
                                  imageName: 'image.$imageExtension',
                                  title: '',
                                )));
                                context.pop();
                              },
                              text: 'إضافة',
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }),
          )),
    );
  }
}
