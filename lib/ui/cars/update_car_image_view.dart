import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_auto_drive/ui/cars/add_car_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class UpdateCarImage extends StatelessWidget {

  UpdateCarImage({super.key,
    this.setImages,
    this.onCompleteImageUpload,
    this.fromSale = false
  });

  List<String>? setImages;
  Function(bool)? onCompleteImageUpload;
  bool? fromSale;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddCarViewModel>.reactive(
        viewModelBuilder: () => AddCarViewModel(),
        disposeViewModel: false,
        onViewModelReady: (model) => model.setUrlImage(urlImageList: setImages),
        builder: (context, model, child) {
        return Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    text: 'Update your car images here',
                    textColor: XColors.black(),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  const XMargin(45),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close_rounded, size: 31,),
                  ),
                ],
              ),

              const YMargin(25),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      model.pickImages();
                    },
                    child: Container(
                      decoration: BoxDecorators.containerDecoration(
                          hasOutline: true,
                          outlineWidth: 1,
                          radius: 32,
                          outlineColor: Colors.purpleAccent.withOpacity(0.2)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            NormalText(
                              text: 'Add new images',
                              textColor: XColors.black(),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                            const XMargin(10),
                            Icon(Icons.add, size: 17, color: XColors.primaryColor(),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const YMargin(25),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            ...List.generate(
                              model.addImagesList.length, (index) =>
                                ImageDisplay(
                                  imageFile: model.addImagesList.reversed.toList()[index],
                                  onRemove: (){
                                    model.updateImagePicks(index: index, type: 'file');
                                  },
                                ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                          ...List.generate(
                            model.addedImagesUrlList.length, (index) =>
                              ImageDisplay(
                                image: setImages![index],
                                onRemove: (){
                                  model.updateImagePicks(index: index, type: 'url');
                                },
                              ),
                          )
                        ],),
                      ],
                    ),
                  ],
                ),
              ),

              const YMargin(25),

              XButton(
                onPressed: model.addImagesList.isNotEmpty ? !model.isBusy ? () {
                  model.updateCarImage(
                    fromSale: fromSale,
                    onCallBack: () {
                      onCompleteImageUpload!(true);
                    },
                    onErrorCallBack: (){
                      onCompleteImageUpload!(false);
                    }
                  );
                } : (){} : (){},
                text: "Update images",
                height: 56,
                textColor: Colors.white,
                buttonColor: model.addImagesList.isNotEmpty ? XColors.primaryColor() : XColors.primaryColor().withOpacity(0.4),
                progressColor: Colors.white,
                isLoading: model.isBusy,
                radius: 26,
                width: SizeConfig().sw(400) as double?,
              ),

              const YMargin(30),

            ],
          ),
        );
      }
    );
  }
}

class ImageDisplay extends StatelessWidget {
  const ImageDisplay({super.key, this.image, this.onRemove, this.imageFile});

  final String? image;
  final File? imageFile;
  final Function? onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            width: 260,
            height: 320,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageFile == null ? Image.network(
                image!,
                fit: BoxFit.cover,
              ) : Image.file(
                imageFile!,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  onRemove!();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.cancel_rounded,
                      color: XColors.red(),
                      size: 32,
                    )
                  ],
                ),
              ),
          )
        ],
      ),
    );
  }
}
