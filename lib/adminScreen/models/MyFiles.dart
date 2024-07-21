import 'package:flutter/material.dart';
import '../../../utility/constant/color.dart';

class CloudStorageInfo {
  final String? svgSrc, title;
  final int? numOfFiles;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.numOfFiles,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Spirituality",
    numOfFiles: 1,
    svgSrc: "assets/adminSide/icons/Documents.svg",
    color: primaryColor,
  ),
  CloudStorageInfo(
    title: "Fantasy",
    numOfFiles: 4,
    svgSrc: "assets/adminSide/icons/Documents.svg",
    color: Color(0xFFFFA113),
  ),
  CloudStorageInfo(
    title: "Coding",
    numOfFiles: 1,
    svgSrc: "assets/adminSide/icons/Documents.svg",
    color: Color(0xFFA4CDFF),
  ),
  CloudStorageInfo(
    title: "Fairy Tail",
    numOfFiles: 3,
    svgSrc: "assets/adminSide/icons/Documents.svg",
    color: Color(0xFF007EE5),
  ),
  CloudStorageInfo(
    title: "Psychology",
    numOfFiles: 1,
    svgSrc: "assets/adminSide/icons/Documents.svg",
    color: Color(0xFF007EE5),
  ),
  CloudStorageInfo(
    title: "Biography",
    numOfFiles: 2,
    svgSrc: "assets/adminSide/icons/Documents.svg",
    color: Color(0xFF007EE5),
  ),
  CloudStorageInfo(
    title: "Romance",
    numOfFiles: 1,
    svgSrc: "assets/adminSide/icons/Documents.svg",
    color: Color(0xFF007EE5),
  ),
  CloudStorageInfo(
    title: "Personal Development",
    numOfFiles: 2,
    svgSrc: "assets/adminSide/icons/Documents.svg",
    color: Color(0xFF007EE5),
  ),
];
