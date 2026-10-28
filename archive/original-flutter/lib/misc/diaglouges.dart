import 'dart:io';

import 'package:explorer/features/books/data/book_request_model.dart';
import 'package:explorer/features/core/data/stations_model.dart';
import 'package:explorer/misc/buttons.dart';
import 'package:explorer/misc/consts.dart';
import 'package:explorer/misc/firebase_constants.dart';
import 'package:explorer/misc/global_functions.dart';
import 'package:explorer/misc/state_widgets.dart';
import 'package:explorer/utils/context_less.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

void bookRequestDialoug(
  BuildContext context,
  GlobalKey<FormBuilderState> formKey,
) {
  showDialog(
    context: context,
    builder: (context) => Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Neumorphic(
          padding: EdgeInsets.all(20.r),
          margin: EdgeInsets.all(20.r),
          child: SizedBox(
            width: 340.w,
            child: FormBuilder(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Request A Book",
                    style: TextStyle(
                      color: KEltColor.txt,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacerH(20.h),
                  Neumorphic(
                    style: KEltDecoration.innerShadow,
                    child: FormBuilderTextField(
                      keyboardType: TextInputType.text,
                      name: 'bookName',
                      style: const TextStyle(
                        color: KEltColor.txt,
                      ),
                      decoration: KEltInputDecoration.inputDecoration.copyWith(
                        hintText: 'Book Name',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          context,
                        ),
                        FormBuilderValidators.minLength(
                          context,
                          6,
                        ),
                      ]),
                    ),
                  ),
                  AppSpacerH(10.h),
                  Neumorphic(
                    style: KEltDecoration.innerShadow,
                    child: FormBuilderTextField(
                      keyboardType: TextInputType.text,
                      name: 'author',
                      style: const TextStyle(
                        color: KEltColor.txt,
                      ),
                      decoration: KEltInputDecoration.inputDecoration.copyWith(
                        hintText: 'Author Name',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          context,
                        ),
                      ]),
                    ),
                  ),
                  AppSpacerH(10.h),
                  Neumorphic(
                    style: KEltDecoration.innerShadow,
                    child: FormBuilderTextField(
                      keyboardType: TextInputType.text,
                      name: 'edition',
                      style: const TextStyle(
                        color: KEltColor.txt,
                      ),
                      decoration: KEltInputDecoration.inputDecoration.copyWith(
                        hintText: 'Book Edition or Volume Number',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          context,
                        ),
                      ]),
                    ),
                  ),
                  AppSpacerH(20.h),
                  CustomButton(
                    title: "Request",
                    onTap: () {
                      if (formKey.currentState!.saveAndValidate()) {
                        FBC.bookRequestCollection.add({
                          ...formKey.currentState!.value,
                          'status': 0
                        }).then((value) {
                          formKey.currentState!.reset();
                          context.nav.pop();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void addBookDialoug(
  BuildContext context,
  GlobalKey<FormBuilderState> formKey,
  List<StationModel> stations,
  BookRequestModel? request,
) {
  File? file;
  File? book;
  showDialog(
    context: context,
    builder: (context) => Scaffold(
      backgroundColor: Colors.transparent,
      body: StatefulBuilder(
        builder: (context, StateSetter setState) {
          return Center(
            child: Neumorphic(
              padding: EdgeInsets.all(20.r),
              margin: EdgeInsets.all(20.r),
              child: SizedBox(
                width: 340.w,
                child: FormBuilder(
                  key: formKey,
                  initialValue: {
                    'bookName': request?.bookName,
                    'author': request?.author,
                    'edition': request?.edition,
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Add A Book",
                          style: TextStyle(
                            color: KEltColor.txt,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppSpacerH(20.h),
                        Text(
                          'Add Cover',
                          style: KEltTextStyle.normal14light,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 75.h,
                          width: 75.h,
                          child: Neumorphic(
                            child: file == null
                                ? GestureDetector(
                                    onTap: () async {
                                      final ImagePicker picker = ImagePicker();
                                      final XFile? image =
                                          await picker.pickImage(
                                        source: ImageSource.gallery,
                                      );
                                      if (image != null) {
                                        setState(
                                          () {
                                            file = File(image.path);
                                          },
                                        );
                                      }
                                    },
                                    child: LottieBuilder.asset(
                                      'assets/lotties/library.json',
                                    ),
                                  )
                                : Image.file(
                                    file!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        AppSpacerH(20.h),
                        Text(
                          'Add Book',
                          style: KEltTextStyle.normal14light,
                          textAlign: TextAlign.center,
                        ),
                        if (book == null)
                          SizedBox(
                            height: 75.h,
                            width: 75.h,
                            child: Neumorphic(
                              child: GestureDetector(
                                onTap: () async {
                                  final FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      'pdf',
                                    ],
                                  );

                                  if (result != null) {
                                    setState(
                                      () {
                                        book = File(result.files.single.path!);
                                      },
                                    );
                                  }
                                },
                                child: LottieBuilder.asset(
                                  'assets/lotties/library.json',
                                ),
                              ),
                            ),
                          )
                        else
                          Neumorphic(
                            style: KEltDecoration.innerShadow,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(book?.path.split('/').last ?? ''),
                            ),
                          ),
                        
                        AppSpacerH(20.h),
                        Neumorphic(
                          style: KEltDecoration.innerShadow,
                          child: FormBuilderTextField(
                            keyboardType: TextInputType.text,
                            name: 'bookName',
                            style: const TextStyle(
                              color: KEltColor.txt,
                            ),
                            decoration:
                                KEltInputDecoration.inputDecoration.copyWith(
                              hintText: 'Book Name',
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                context,
                              ),
                              FormBuilderValidators.minLength(
                                context,
                                6,
                              ),
                            ]),
                          ),
                        ),
                        AppSpacerH(10.h),
                        Neumorphic(
                          style: KEltDecoration.innerShadow,
                          child: FormBuilderTextField(
                            keyboardType: TextInputType.text,
                            name: 'author',
                            style: const TextStyle(
                              color: KEltColor.txt,
                            ),
                            decoration:
                                KEltInputDecoration.inputDecoration.copyWith(
                              hintText: 'Author Name',
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                context,
                              ),
                            ]),
                          ),
                        ),
                        AppSpacerH(10.h),
                        Neumorphic(
                          style: KEltDecoration.innerShadow,
                          child: FormBuilderTextField(
                            keyboardType: TextInputType.text,
                            name: 'edition',
                            style: const TextStyle(
                              color: KEltColor.txt,
                            ),
                            decoration:
                                KEltInputDecoration.inputDecoration.copyWith(
                              hintText: 'Book Edition or Volume Number',
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                context,
                              ),
                            ]),
                          ),
                        ),
                        AppSpacerH(20.h),
                        Neumorphic(
                          style: KEltDecoration.innerShadow,
                          child: FormBuilderDropdown(
                            name: 'stationID',
                            style: const TextStyle(
                              color: KEltColor.txt,
                            ),
                            decoration:
                                KEltInputDecoration.inputDecoration.copyWith(
                              hintText: 'Select Station',
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                context,
                              ),
                            ]),
                            items: stations
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        AppSpacerH(20.h),
                        CustomButton(
                          title: "Add Book",
                          onTap: () async {
                            if (formKey.currentState!.saveAndValidate()) {
                              if (file != null && book != null) {
                                final imageUrl = await uploadFile(
                                  collection: 'cover',
                                  file: file!,
                                );

                                final bookUrl = await uploadFile(
                                  collection: 'book',
                                  file: book!,
                                );
                                debugPrint("Got URL $imageUrl");
                                FBC.booksCollection.add({
                                  ...formKey.currentState!.value,
                                  'time': DateTime.now().millisecondsSinceEpoch,
                                  'cover': imageUrl,
                                  'book': bookUrl,
                                  'bookViews': 0
                                }).then((value) {
                                  if (request != null) {
                                    FBC.bookRequestCollection
                                        .doc(request.requestID)
                                        .update({'status': 1});
                                  }
                                  formKey.currentState!.reset();
                                  context.nav.pop();
                                });
                              } else {
                                EasyLoading.showError(
                                  'Please Select Cover Image',
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
