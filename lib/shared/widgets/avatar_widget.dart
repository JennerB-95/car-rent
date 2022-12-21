import 'dart:math';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    this.photoURL,
    this.membership,
    this.progress = 0,
    this.color,
    this.isHideProgressBar = false,
    this.width = 85,
    this.heroTag,
    Key key,
  }) : super(key: key);

  final String photoURL;
  final String heroTag;
  final String membership;
  final int progress;
  final Color color;
  final bool isHideProgressBar;
  final double width;

  Widget emptyPhoto() {
    return Hero(
      tag: "empty-avatar" + (heroTag ?? Random().nextInt(100).toString()),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 70,
        child: Center(
          child: Icon(
            LineIcons.alternateUser,
            size: 50,
            color: Get.theme.accentColor,
          ),
        ),
      ),
    );
  }

  Widget emptyPhotoBorder() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Get.theme.accentColor,
            width: 1,
          )),
      child: Hero(
        tag: "empty-avatar-border" +
            (heroTag ?? Random().nextInt(100).toString()),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 70,
          child: Center(
            child: Icon(
              LineIcons.alternateUser,
              size: 70,
              color: Get.theme.accentColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: isHideProgressBar
          ? photoURL?.isEmpty ?? true
              ? emptyPhotoBorder()
              : Hero(
                  tag: "avatar" + (heroTag ?? Random().nextInt(100).toString()),
                  child: CircleAvatar(
                    maxRadius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(photoURL),
                  ),
                )
          : Stack(
              children: [
                CircularStepProgressIndicator(
                  padding: 0,
                  currentStep: progress,
                  totalSteps: 100,
                  selectedStepSize: 3.7,
                  width: 70,
                  height: 70,
                  startingAngle: 2.3,
                  selectedColor: color ?? Colors.yellow[600],
                  unselectedColor: Colors.white,
                  roundedCap: (_, __) => true,
                  child: Center(
                    child: photoURL?.isEmpty ?? true
                        ? emptyPhoto()
                        : Hero(
                            tag: "avatar" +
                                (heroTag ?? Random().nextInt(100).toString()),
                            child: CircleAvatar(
                              maxRadius: 27,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(photoURL),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 0,
                  child: Badge(
                    shape: BadgeShape.square,
                    animationType: BadgeAnimationType.scale,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2.2),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                    badgeColor: color ?? Colors.yellow[600],
                    borderRadius: BorderRadius.circular(13),
                    elevation: 0,
                    badgeContent: Text(
                      membership ?? "Free",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
