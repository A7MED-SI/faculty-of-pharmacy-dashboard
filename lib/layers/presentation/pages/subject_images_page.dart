import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pharmacy_dashboard/core/apis/images_pdf_api.dart';
import 'package:pharmacy_dashboard/core/layout/adaptive.dart';
import 'package:pharmacy_dashboard/layers/data/models/subject_image/subject_image.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/images/add_image.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/images/get_image.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/images/update_image.dart';
import 'package:pharmacy_dashboard/layers/presentation/AppWidgetsDisplayer.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/image/image_bloc.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/app_error_widget.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/app_text_button.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/loading_widget.dart';

import '../widgets/app_elevated_button.dart';

class SubjectImagesPage extends StatefulWidget {
  const SubjectImagesPage({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });
  static const routeName = 'images';

  final int subjectId;
  final String subjectName;

  @override
  State<SubjectImagesPage> createState() => _SubjectImagesPageState();
}

class _SubjectImagesPageState extends State<SubjectImagesPage> {
  late final ImageBloc _imagesBloc;

  @override
  void initState() {
    super.initState();
    _imagesBloc = ImageBloc();
    _imagesBloc.add(ImagesFetched(
        getImagesParams: GetImagesParams(subjectId: widget.subjectId)));
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
        body: BlocConsumer<ImageBloc, ImageState>(
          listener: (context, state) {
            if (state.addingImageStatus == AddingImageStatus.failed) {
              AppWidgetsDisplayer.displayErrorSnackBar(
                context: context,
                message: state.errorMessage ??
                    'فشل الإضافة يرجى التحقق من الإنترنت والمحاولة لاحقا',
              );
            }
            if (state.addingImageStatus == AddingImageStatus.success) {
              AppWidgetsDisplayer.displaySuccessSnackBar(
                context: context,
                message: 'تم إضافة الصورة بنجاح',
              );
            }
            if (state.deletingImageStatus == DeletingImageStatus.failed) {
              AppWidgetsDisplayer.displayErrorSnackBar(
                context: context,
                message: state.errorMessage ??
                    'فشل الحذف يرجى التحقق من الإنترنت والمحاولة لاحقا',
              );
            }
            if (state.deletingImageStatus == DeletingImageStatus.success) {
              AppWidgetsDisplayer.displaySuccessSnackBar(
                context: context,
                message: 'تم حذف الصورة بنجاح',
              );
            }
            if (state.updatingImageStatus == UpdatingImageStatus.failed) {
              AppWidgetsDisplayer.displayErrorSnackBar(
                context: context,
                message: state.errorMessage ??
                    'فشل التعديل يرجى التحقق من الإنترنت والمحاولة لاحقا',
              );
            }
            if (state.updatingImageStatus == UpdatingImageStatus.success) {
              AppWidgetsDisplayer.displaySuccessSnackBar(
                context: context,
                message: 'تم تعديل الصورة بنجاح',
              );
            }
          },
          bloc: _imagesBloc,
          builder: (context, state) {
            return state.imagesFetchingStatus == ImagesFetchingStatus.initial ||
                    state.imagesFetchingStatus == ImagesFetchingStatus.loading
                ? const LoadingWidget()
                : state.imagesFetchingStatus == ImagesFetchingStatus.failed
                    ? AppErrorWidget(
                        onRefreshPressed: () {
                          _imagesBloc.add(ImagesFetched(
                              getImagesParams: GetImagesParams(
                                  subjectId: widget.subjectId)));
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
                                          return _AdImageDialog(
                                            imageBloc: _imagesBloc,
                                            subjectId: widget.subjectId,
                                          );
                                        });
                                  },
                                  text: 'إضافة صورة',
                                ),
                                if (state.images.isNotEmpty)
                                  const SizedBox(width: 10),
                                if (state.images.isNotEmpty)
                                  AppTextButton(
                                    onPressed: () async {
                                      BotToast.showLoading();
                                      await ImagesPdfApi.generateThenDownload(
                                        images: state.images,
                                        subjectName: widget.subjectName,
                                      );
                                      BotToast.closeAllLoading();
                                    },
                                    text: 'تحميل كملف',
                                  )
                              ],
                            ),
                          ),
                          state.images.isEmpty
                              ? const Expanded(
                                  child: Center(
                                    child: Text('لا يوجد صور مضافة حاليا'),
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
                                          childAspectRatio: 1.4,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 6,
                                          children: [
                                            for (var image in state.images)
                                              Column(
                                                children: [
                                                  Expanded(
                                                    flex: 5,
                                                    child: Stack(
                                                      children: [
                                                        ExtendedImage.network(
                                                          image.image,
                                                          fit: BoxFit.fill,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          cache: true,
                                                        ),
                                                        Positioned(
                                                          top: 6,
                                                          right: 8,
                                                          child:
                                                              PopupMenuButton<
                                                                  String>(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            tooltip: 'خيارات',
                                                            onSelected:
                                                                (value) async {
                                                              if (value ==
                                                                  'edit') {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return _AdImageDialog(
                                                                        imageBloc:
                                                                            _imagesBloc,
                                                                        isUpdate:
                                                                            true,
                                                                        image:
                                                                            image,
                                                                        subjectId:
                                                                            widget.subjectId,
                                                                      );
                                                                    });
                                                              } else {
                                                                final result =
                                                                    await showDialog<
                                                                        bool?>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return const DeleteConfirmationDialog(
                                                                      text:
                                                                          'هل أنت متأكد أنك تريد حذف هذه الصورة؟',
                                                                    );
                                                                  },
                                                                );
                                                                if (result !=
                                                                        null &&
                                                                    result) {
                                                                  _imagesBloc.add(
                                                                      ImageDeleted(
                                                                          imageIds: [
                                                                        image.id
                                                                      ]));
                                                                }
                                                              }
                                                            },
                                                            splashRadius: 30,
                                                            itemBuilder:
                                                                (context) =>
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
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .black38,
                                                              ),
                                                              child: const Icon(
                                                                Icons
                                                                    .more_vert_outlined,
                                                                color: Colors
                                                                    .white,
                                                                size: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '${image.title} (',
                                                          style: textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SelectableText(
                                                          image.id.toString(),
                                                          style: textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          ' )',
                                                          style: textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
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

class _AdImageDialog extends StatefulWidget {
  const _AdImageDialog({
    required this.imageBloc,
    required this.subjectId,
    this.isUpdate = false,
    this.image,
  });
  final ImageBloc imageBloc;
  final bool isUpdate;
  final SubjectImage? image;
  final int subjectId;
  @override
  State<_AdImageDialog> createState() => _AdImageDialogState();
}

class _AdImageDialogState extends State<_AdImageDialog> {
  late final ValueNotifier<Uint8List?> imageNotifier;
  late final TextEditingController titleController;
  String? imageExtension;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.image?.title);
    imageNotifier = ValueNotifier(null);
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
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
                        widget.isUpdate ? 'تعديل صورة' : 'إضافة صورة',
                        style: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 80),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'العنوان:',
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: colorScheme.onBackground),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: titleController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              maxLines: null,
                              style: textTheme.bodyLarge,
                              decoration: const InputDecoration(
                                isCollapsed: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 11),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
                                if (!widget.isUpdate &&
                                    imageNotifier.value == null) {
                                  showToast(
                                    'يجب اختيار صورة قبل الإضافة',
                                    position: const ToastPosition(
                                        align: Alignment.bottomCenter),
                                  );
                                  return;
                                }
                                widget.isUpdate
                                    ? widget.imageBloc.add(ImageUpdated(
                                        updateImageParams: UpdateImageParams(
                                        image: imageNotifier.value,
                                        imageId: widget.image!.id,
                                        imageName: 'image.$imageExtension',
                                        title: titleController.text.isEmpty
                                            ? null
                                            : titleController.text,
                                      )))
                                    : widget.imageBloc.add(ImageAdded(
                                        addImageParams: AddImageParams(
                                        image: imageNotifier.value!,
                                        imageName: 'image.$imageExtension',
                                        subjectId: widget.subjectId,
                                        title: titleController.text.isEmpty
                                            ? null
                                            : titleController.text,
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
