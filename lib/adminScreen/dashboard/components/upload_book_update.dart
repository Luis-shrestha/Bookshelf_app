import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shelf/adminScreen/dashboard/components/upload_college_pdf.dart';
import 'package:shelf/utility/widget/form_widget/upload_book_form.dart';
import 'package:shelf/utility/widget/upload_file_widget/gesture_detector_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../utility/constant/constant.dart' as constant;
import '../../../../utility/widget/file_photo_picker/file_photo_picker.dart';
import '../../../helper/upload_helper/file_upload_helper.dart';
import '../../../helper/upload_helper/photo_upload_helper.dart';
import '../../../userScreen/model/bloc/upload_pdf_bloc/upload_bloc.dart';
import '../../../userScreen/model/repository/upload_repo/upload_book_repo.dart';
import '../../../userScreen/model/repository/upload_repo/upload_photo_repo.dart';
import '../../main/components/side_menu.dart';

class UploadBookUpdatedView extends StatelessWidget {
  const UploadBookUpdatedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          UploadBloc(UploadBookRepository(), UploadPhotoRepository()),
      child: const UploadBook(),
    );
  }
}

class UploadBook extends StatefulWidget {
  const UploadBook({super.key});

  @override
  State<UploadBook> createState() => _UploadBookState();
}

class _UploadBookState extends State<UploadBook> {
  String? pdfName;
  String? photoName;
  File? selectedFile;
  File? selectedPhoto;
  final UploadBookRepository uploadPdfRepository = UploadBookRepository();
  final UploadPhotoRepository uploadPhotoRepository = UploadPhotoRepository();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late final FileUploadHelper fileUploadHelper;
  late final PhotoUploadHelper photoUploadHelper;

  final _formKey = GlobalKey<FormState>();

  final _focusAuthorName = FocusNode();
  final _focusBookName = FocusNode();
  final _focusDescription = FocusNode();
  final _focusCategories = FocusNode();

  final _authorNameController = TextEditingController();
  final _bookNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoriesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fileUploadHelper = FileUploadHelper(
      uploadPdfRepository: uploadPdfRepository,
      firebaseFirestore: _firebaseFirestore,
    );
    photoUploadHelper = PhotoUploadHelper(
      firebaseFirestore: _firebaseFirestore,
      uploadPhotoRepository: uploadPhotoRepository,
    );
  }

  @override
  void dispose() {
    _focusAuthorName.dispose();
    _focusBookName.dispose();
    _focusDescription.dispose();
    _focusCategories.dispose();
    _authorNameController.dispose();
    _bookNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void resetSelection() {
    setState(() {
      pdfName = null;
      photoName = null;
      selectedFile = null;
      selectedPhoto = null;
      _authorNameController.clear();
      _bookNameController.clear();
      _categoriesController.clear();
      _descriptionController.clear();
      print('Selection reset');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusAuthorName.unfocus();
        _focusBookName.unfocus();
        _focusDescription.unfocus();
      },
      child: Scaffold(
        backgroundColor: constant.kBackGroundColor,
        appBar: AppBar(
          backgroundColor: constant.kBackGroundColor,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        drawer: SideMenu(),
        body: BlocListener<UploadBloc, UploadState>(
          listener: (context, state) {
            if (state is UploadSuccessState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.successMessage)));
              resetSelection();
            }
          },
          child:
              BlocBuilder<UploadBloc, UploadState>(builder: (context, state) {
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
                            "Do you want to upload a book? Updated page",
                            textAlign: TextAlign.center,
                            style: constant
                                .kHeading2TextStyle.textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<UploadBloc, UploadState>(
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
                                focusNode: _focusBookName,
                                controller: _bookNameController,
                                labelText: 'Book Name',
                                prefixIcon: Icons.menu_book_outlined,
                                func: (String value) {},
                              ),
                              const SizedBox(height: 10),
                              UploadBookForm(
                                focusNode: _focusCategories,
                                controller: _categoriesController,
                                labelText: 'Categories of Book',
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
                                  _categoriesController != '' &&
                                  _authorNameController != '' &&
                                  _bookNameController != '' &&
                                  _descriptionController != '') {
                                context.read<UploadBloc>().add(
                                      UploadButtonPressEvent(
                                        pdfName: pdfName!,
                                        pdf: selectedFile!,
                                        photoName: photoName!,
                                        photo: selectedPhoto!,
                                        authorName: _authorNameController.text,
                                        bookName: _bookNameController.text,
                                        description:
                                            _descriptionController.text,
                                        category: _categoriesController.text,
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
                          label: "Upload College Pdf",
                          icon: Icons.swap_horiz_rounded,
                          color: Colors.orange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadCollegePdfView(),
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
