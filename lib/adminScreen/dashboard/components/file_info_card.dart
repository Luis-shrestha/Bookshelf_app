import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utility/constant/constant.dart' as constant;
import '../../constants.dart';
import '../../models/MyFiles.dart';

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final CloudStorageInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: constant.kBackGroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            spreadRadius: 3,
            blurRadius: 3,
            color: Colors.black12
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(defaultPadding * 0.75),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  // color: info.color!.withOpacity(0.1),
                  color: constant.kLightBlackColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: SvgPicture.asset(
                  info.svgSrc!,
                  colorFilter: ColorFilter.mode(
                      info.color ?? Colors.black, BlendMode.srcIn),
                ),
              ),
            ],
          ),
          Text(
            info.title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.black87),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${info.numOfFiles} Books",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.black87),
              ),

            ],
          )
        ],
      ),
    );
  }
}

