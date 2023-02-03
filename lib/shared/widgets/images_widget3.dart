import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

class ImagesWidget3 extends StatelessWidget {
  const ImagesWidget3({
    Key key,
    @required this.images,
    this.isExpanded = false,
    this.heightImages = 150,
    this.heroTag,
  }) : super(key: key);

  final List<String> images;
  final String heroTag;
  final bool isExpanded;
  final double heightImages;

  @override
  Widget build(BuildContext context) {
    return isExpanded
        ? Expanded(child: buildBody(context))
        : buildBody(context);
  }

  ValueBuilder<int> buildBody(context) {
    return ValueBuilder<int>(
      initialValue: 0,
      builder: (currentImage, updateFn) => Stack(
        children: [
          isExpanded
              ? Expanded(child: buildImagesPage(updateFn))
              : buildImagesPage(updateFn),
          IgnorePointer(
            child: Container(
              height: 300,
              width: double.infinity,
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          images.length > 1
              ? Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: images
                            .map((image) => _buildIndicator(
                                images.indexOf(image) == currentImage))
                            .toList(),
                      ),
                    ),
                  ),
                )
              : Container(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: EdgeInsets.all(10.0),
              height: 40,
              width: 40,
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black.withOpacity(0.5)),
              child: Icon(
                FeatherIcons.chevronLeft,
                color: Colors.white,
                size: 35.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImagesPage(ValueBuilderUpdateCallback<int> updateFn) {
    return Container(
      height: 300.0,
      child: PageView(
        physics: BouncingScrollPhysics(),
        onPageChanged: updateFn,
        children: images.map((path) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: heroTag != null && images.indexOf(path) == 0
                ? Hero(
                    tag: heroTag,
                    child: Image.network(
                      path,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            backgroundColor: Colors.white,
                            valueColor: new AlwaysStoppedAnimation<Color>(
                              Color(0xff333D55),
                            ),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                      //height: 100.0,
                    ))
                : Image.network(
                    path,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          backgroundColor: Colors.white,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            Color(0xff333D55),
                          ),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                    //height: 100.0,
                  ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 6),
      height: 8,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}
