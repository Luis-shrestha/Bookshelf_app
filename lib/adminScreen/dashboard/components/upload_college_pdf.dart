import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shelf/adminScreen/dashboard/components/upload_book_update.dart';

import 'package:shelf/userScreen/model/bloc/uploadCollegePdf/upload_bloc.dart';
import 'package:shelf/userScreen/model/repository/uploadCollegePdf/upload_college_pdf_repo.dart';
import 'package:shelf/userScreen/model/repository/uploadCollegePdf/upload_subject_photo_repo.dart';
import 'package:shelf/utility/widget/form_widget/upload_book_form.dart';
import 'package:shelf/utility/widget/upload_file_widget/gesture_detector_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../utility/constant/constant.dart' as constant;
import '../../../../utility/widget/file_photo_picker/file_photo_picker.dart';
import '../../../helper/collegePdfUploadHelper/file_upload_helper.dart';
import '../../../helper/collegePdfUploadHelper/photo_upload_helper.dart';
import '../../main/components/side_menu.dart';

class UploadCollegePdfView extends StatelessWidget {
  const UploadCollegePdfView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          UploadCollegePdfBloc(UploadCollegePdfRepository(), UploadSubjectPhotoRepository()),
      child: const UploadCollegePdfViewPage(),
    );
  }
}

class UploadCollegePdfViewPage extends StatefulWidget {
  const UploadCollegePdfViewPage({super.key});

  @override
  State<UploadCollegePdfViewPage> createState() => _UploadCollegePdfViewPageState();
}

class _UploadCollegePdfViewPageState extends State<UploadCollegePdfViewPage> {
  String? pdfName;
  String? photoName;
  File? selectedFile;
  File? selectedPhoto;
  final UploadCollegePdfRepository uploadCollegePdfRepository = UploadCollegePdfRepository();
  final UploadSubjectPhotoRepository uploadSubjectPhotoRepository = UploadSubjectPhotoRepository();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late final CollegePdfUploadHelper collegePdfUploadHelper;
  late final SubjectPhotoUploadHelper subjectPhotoUploadHelper;

  final _formKey = GlobalKey<FormState>();

  final _focusAuthorName = FocusNode();
  final _focusChapterName = FocusNode();
  final _focusDescription = FocusNode();
  final _focusSubjectName = FocusNode();
  final _focusSemester = FocusNode();

  final _authorNameController = TextEditingController();
  final _ChapterNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _subjectNameController = TextEditingController();
  final _semesterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    collegePdfUploadHelper = CollegePdfUploadHelper(
      uploadCollegePdfRepository: uploadCollegePdfRepository,
      firebaseFirestore: _firebaseFirestore,
    );
    subjectPhotoUploadHelper = SubjectPhotoUploadHelper(
      firebaseFirestore: _firebaseFirestore,
      uploadSubjectPhotoRepository: uploadSubjectPhotoRepository,
    );
  }

  @override
  void dispose() {
    _focusAuthorName.dispose();
    _focusChapterName.dispose();
    _focusDescription.dispose();
    _focusSubjectName.dispose();
    _focusSemester.dispose();
    _authorNameController.dispose();
    _ChapterNameController.dispose();
    _descriptionController.dispose();
    _semesterController.dispose();
    super.dispose();
  }

  void resetSelection() {
    setState(() {
      pdfName = null;
      photoName = null;
      selectedFile = null;
      selectedPhoto = null;
      _authorNameController.clear();
      _ChapterNameController.clear();
      _subjectNameController.clear();
      _descriptionController.clear();
      print('Selection reset');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusAuthorName.unfocus();
        _focusChapterName.unfocus();
        _focusDescription.unfocus();
        _focusSemester.unfocus();
      },
      child: Scaffold(
        backgroundColor: constant.kBackGroundColor,
        appBar: AppBar(
          backgroundColor: constant.kBackGroundColor,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        drawer: SideMenu(),
        body: BlocListener<UploadCollegePdfBloc, UploadCollegePdfState>(
          listener: (context, state) {
            if (state is UploadSuccessState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.successMessage)));
              resetSelection();
            }
          },
          child:
          BlocBuilder<UploadCollegePdfBloc, UploadCollegePdfState>(builder: (context, state) {
            if (state is UploadLoadingState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(constant.pedroGif),
                    Text(
                      "Uploading file \n Please wait a moment",
                      style: constant.kHeading2TextStyle.textTheme.titleLarge,
                    ),
                  ],
                ),
              );
            }
            return Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(constant.bg),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            "Upload College Pdf",
                            textAlign: TextAlign.center,
                            style: constant
                                .kHeading2TextStyle.textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<UploadCollegePdfBloc, UploadCollegePdfState>(
                            builder: (context, state) {
                              if (state is UploadErrorState) {
                                return Center(
                                  child: Text(state.errorUploadMessage),
                                );
                              }
                              return Container();
                            }),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              UploadBookForm(
                                focusNode: _focusAuthorName,
                                controller: _authorNameController,
                                labelText: 'Author Name',
                                prefixIcon: Icons.person,
                                func: (String value) {},
                              ),
                              const SizedBox(height: 10),
                              UploadBookForm(
                                focusNode: _focusChapterName,
                                controller: _ChapterNameController,
                                labelText: 'Chapter Name with unit',
                                prefixIcon: Icons.menu_book_outlined,
                                func: (String value) {},
                              ),
                              const SizedBox(height: 10),
                              UploadBookForm(
                                focusNode: _focusSubjectName,
                                controller: _subjectNameController,
                                labelText: 'Subject Name',
                                prefixIcon: Icons.category_rounded,
                                func: (String value) {},
                              ),
                              const SizedBox(height: 10),
                              UploadBookForm(
                                focusNode: _focusSemester,
                                controller: _semesterController,
                                labelText: 'Semester',
                                prefixIcon: Icons.category_rounded,
                                func: (String value) {},
                              ),
                              const SizedBox(height: 10),
                              UploadBookForm(
                                focusNode: _focusDescription,
                                controller: _descriptionController,
                                labelText: 'Description of Book',
                                prefixIcon: Icons.description,
                                func: (String value) {},
                              ),
                            ],
                          ),
                        ),
                        // For upload File/PDF
                        const SizedBox(height: 20),
                        if (pdfName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                            ),
                            width: 300,
                            child: Text('Selected file: $pdfName'),
                          ),
                        const SizedBox(height: 5),
                        CustomButtonWidget(
                          label: "Select file",
                          icon: Icons.upload_file,
                          color: Colors.orange,
                          onTap: () => pickFile(context, (name, file) {
                            setState(() {
                              pdfName = name;
                              selectedFile = file;
                            });
                          }),
                        ),
                        const SizedBox(height: 20),

                        // For Upload Cover Photo
                        if (photoName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                            ),
                            width: 300,
                            child: Text('Selected photo: $photoName'),
                          ),
                        const SizedBox(height: 5),
                        CustomButtonWidget(
                          label: "Select cover photo",
                          icon: Icons.upload_file_rounded,
                          color: Colors.orange,
                          onTap: () => pickPhoto(context, (name, photo) {
                            setState(() {
                              photoName = name;
                              selectedPhoto = photo;
                            });
                          }),
                        ),
                        if (pdfName != null && photoName != null) ...[
                          const SizedBox(height: 20),
                          CustomButtonWidget(
                            label: "Upload file",
                            icon: Icons.upload,
                            color: Colors.orange,
                            onTap: () {
                              if (selectedFile != null &&
                                  selectedPhoto != null &&
                                  _subjectNameController != '' &&
                                  _authorNameController != '' &&
                                  _ChapterNameController != '' &&
                                  _semesterController != '' &&
                                  _descriptionController != '') {
                                context.read<UploadCollegePdfBloc>().add(
                                  UploadButtonPressEvent(
                                    pdfName: pdfName!,
                                    pdf: selectedFile!,
                                    photoName: photoName!,
                                    photo: selectedPhoto!,
                                    authorName: _authorNameController.text,
                                    chapterName: _ChapterNameController.text,
                                    description:
                                    _descriptionController.text,
                                    subjectName: _subjectNameController.text,
                                    semester: _semesterController.text,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                        if (pdfName != null ||
                            selectedFile != null ||
                            photoName != null ||
                            selectedPhoto != null) ...[
                          const SizedBox(height: 20),
                          CustomButtonWidget(
                            label: "Cancel",
                            icon: Icons.cancel,
                            color: Colors.red,
                            onTap: resetSelection,
                          ),
                        ],

                        const SizedBox(height: 45),
                        CustomButtonWidget(
                          label: "Upload Book",
                          icon: Icons.swap_horiz_rounded,
                          color: Colors.orange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadBookUpdatedView(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
