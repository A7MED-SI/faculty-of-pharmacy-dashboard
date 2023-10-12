import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/core/layout/adaptive.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/ad/add_ad.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/ad/update_ad.dart';
import 'package:pharmacy_dashboard/layers/presentation/AppWidgetsDisplayer.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/ads/ads_bloc.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/app_error_widget.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/app_text_button.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/delete_confirmation_dialog.dart';
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
              AppWidgetsDisplayer.displayErrorSnackBar(
                context: context,
                message: state.errorMessage ??
                    'فشل الإضافة يرجى التحقق من الإنترنت والمحاولة لاحقا',
              );
            }
            if (state.addingAdStatus == AddingAdStatus.success) {
              AppWidgetsDisplayer.displaySuccessSnackBar(
                context: context,
                message: 'تم إضافة الإعلان بنجاح',
              );
            }
            if (state.deletingAdStatus == DeletingAdStatus.failed) {
              AppWidgetsDisplayer.displayErrorSnackBar(
                context: context,
                message: state.errorMessage ??
                    'فشل الحذف يرجى التحقق من الإنترنت والمحاولة لاحقا',
              );
            }
            if (state.deletingAdStatus == DeletingAdStatus.success) {
              AppWidgetsDisplayer.displaySuccessSnackBar(
                context: context,
                message: 'تم حذف الإعلان بنجاح',
              );
            }
            if (state.togglingAdStatus == TogglingAdStatus.failed) {
              AppWidgetsDisplayer.displayErrorSnackBar(
                context: context,
                message: state.errorMessage ??
                    'يرجى التحقق من الإنترنت والمحاولة لاحقا',
              );
            }
            if (state.updatingAdStatus == UpdatingAdStatus.failed) {
              AppWidgetsDisplayer.displayErrorSnackBar(
                context: context,
                message: state.errorMessage ??
                    'فشل التعديل يرجى التحقق من الإنترنت والمحاولة لاحقا',
              );
            }
            if (state.updatingAdStatus == UpdatingAdStatus.success) {
              AppWidgetsDisplayer.displaySuccessSnackBar(
                context: context,
                message: 'تم تعديل الإعلان بنجاح',
              );
            }
          },
          bloc: _adsBloc,
          builder: (context, state) {
            return state.adsFetchingStatus == AdsFetchingStatus.initial ||
                    state.adsFetchingStatus == AdsFetchingStatus.loading
                ? const LoadingWidget()
                : state.adsFetchingStatus == AdsFetchingStatus.failed
                    ? AppErrorWidget(
                        onRefreshPressed: () {
                          _adsBloc.add(AdsFetched());
                        },
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 12, top: 12, left: 12),
                            child: Row(
                              children: [
                                const Spacer(),
                                AppTextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return _AdAddDialog(
                                              adsBloc: _adsBloc);
                                        });
                                  },
                                  text: 'إضافة إعلان',
                                ),
                              ],
                            ),
                          ),
                          state.ads.isEmpty
                              ? const Expanded(
                                  child: Center(
                                    child: Text('لا يوجد إعلانات مضافة حاليا'),
                                  ),
                                )
                              : Expanded(
                                  child: CustomScrollView(
                                    slivers: [
                                      SliverPadding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 20),
                                        sliver: SliverGrid.count(
                                          crossAxisCount: isDesktop ? 6 : 2,
                                          childAspectRatio: 1.6,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 2,
                                          children: [
                                            for (var ad in state.ads)
                                              Stack(
                                                children: [
                                                  ExtendedImage.network(
                                                    ad.image,
                                                    fit: BoxFit.fill,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    cache: true,
                                                  ),
                                                  Positioned(
                                                    bottom: 6,
                                                    left: 8,
                                                    child: Switch(
                                                      onChanged: (value) {
                                                        _adsBloc.add(
                                                            AdActiveToggled(
                                                                adId: ad.id));
                                                      },
                                                      value: ad.isActive == 1,
                                                      activeColor:
                                                          colorScheme.primary,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 6,
                                                    right: 8,
                                                    child:
                                                        PopupMenuButton<String>(
                                                      padding: EdgeInsets.zero,
                                                      tooltip: 'خيارات',
                                                      onSelected:
                                                          (value) async {
                                                        if (value == 'edit') {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return _AdAddDialog(
                                                                  adsBloc:
                                                                      _adsBloc,
                                                                  isUpdate:
                                                                      true,
                                                                  adId: ad.id,
                                                                );
                                                              });
                                                        } else {
                                                          final result =
                                                              await showDialog<
                                                                  bool?>(
                                                            context: context,
                                                            builder: (context) {
                                                              return const DeleteConfirmationDialog(
                                                                text:
                                                                    'هل أنت متأكد أنك تريد حذف هذا الإعلان؟',
                                                              );
                                                            },
                                                          );
                                                          if (result != null &&
                                                              result) {
                                                            _adsBloc.add(
                                                                AdDeleted(
                                                                    adId:
                                                                        ad.id));
                                                          }
                                                        }
                                                      },
                                                      splashRadius: 30,
                                                      itemBuilder: (context) =>
                                                          <PopupMenuItem<
                                                              String>>[
                                                        const PopupMenuItem<
                                                            String>(
                                                          value: 'edit',
                                                          child: Text(
                                                            'تعديل',
                                                          ),
                                                        ),
                                                        const PopupMenuItem<
                                                            String>(
                                                          value: 'delete',
                                                          child: Text(
                                                            'حذف',
                                                          ),
                                                        ),
                                                      ],
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2),
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.black38,
                                                        ),
                                                        child: const Icon(
                                                          Icons
                                                              .more_vert_outlined,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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
    this.isUpdate = false,
    this.adId,
  });
  final AdsBloc adsBloc;
  final bool isUpdate;
  final int? adId;
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
          ? const EdgeInsets.symmetric(horizontal: 350)
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
                        widget.isUpdate ? 'تعديل إعلان' : 'إضافة إعلان',
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
                                widget.isUpdate
                                    ? 'اختيار صورة جديدة'
                                    : 'اختيار صورة',
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
                                if (imageNotifier.value == null) {
                                  return;
                                }
                                widget.isUpdate
                                    ? widget.adsBloc.add(AdUpdated(
                                        updateAdParams: UpdateAdParams(
                                        image: imageNotifier.value!,
                                        adId: widget.adId!,
                                        imageName: 'image.$imageExtension',
                                      )))
                                    : widget.adsBloc.add(AdAdded(
                                        addAdParams: AddAdParams(
                                        image: imageNotifier.value!,
                                        imageName: 'image.$imageExtension',
                                      )));
                                context.pop();
                              },
                              text: widget.isUpdate ? 'حفظ' : 'إضافة',
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
