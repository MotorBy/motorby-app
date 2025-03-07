import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/marketplace/shops/shop_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/list_selector.dart';
import 'package:mobile_auto_drive/widgets/snackbar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class CreateShopScreen extends StatelessWidget {
  const CreateShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShopViewModel>.reactive(
        viewModelBuilder: () => ShopViewModel(),
        disposeViewModel: false,
        builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: XColors.white(),
            surfaceTintColor: XColors.white(),
            leading: GestureDetector(
                onTap: () {
                  popView(context);
                },
                child: Icon(Icons.arrow_back_ios_rounded, size: 18, color: XColors.black(),)
            ),
          ),
          floatingActionButton: XButton(
              onPressed: () {
                model.createShop(
                    onCallBack: (){
                      showSnackBar(
                          context: context,
                          message: 'Successfully created a shop'
                      );
                    },
                    onErrorCallBack: (){}
                );
              },
              text: 'Create',
              isLoading: model.isBusy,
              buttonColor: XColors.primaryColor(),
              width: 120,
            ),
            body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        model.pickImages();
                      },
                      child: Container(
                        decoration: BoxDecorators.containerDecoration(
                            hasOutline: true,
                            outlineWidth: 2,
                            radius: 32,
                            outlineColor: Colors.purpleAccent.withOpacity(0.2)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              NormalText(
                                text: 'Add Logo',
                                textColor: XColors.black(),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const YMargin(20),
                MainInputField(
                  label: "Shop name",
                  isEnabled: true,
                  onChanged: (s){
                    model.updateSetupData(data: s, type: 'name');
                  },
                ),
                const YMargin(20),
                MainInputField(
                  label: "Description",
                  isEnabled: true,
                  maxLines: 5,
                  onChanged: (s){
                    model.updateSetupData(data: s, type: 'description');
                  },
                ),
                const YMargin(20),
                MainInputField(
                  label: "Contact (phone number)",
                  isEnabled: true,
                  onChanged: (s){
                    model.updateSetupData(data: s, type: 'contact');
                  },
                ),
                const YMargin(20),
                MainInputField(
                  label: "Address",
                  isEnabled: true,
                  onChanged: (s){
                    model.updateSetupData(data: s, type: 'address');
                  },
                ),
                const YMargin(20),
                MainInputField(
                  label: "Email address",
                  isEnabled: true,
                  onChanged: (s){
                    model.updateSetupData(data: s, type: 'email');
                  },
                ),
                const YMargin(25),
                Column(
                  children: [
                    if(model.intoPicks.isNotEmpty) ... [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ...List.generate(model.intoPicks.length, (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Container(
                                  decoration: BoxDecorators.containerDecoration(
                                      hasOutline: true,
                                      outlineWidth: 1,
                                      radius: 32,
                                      outlineColor: Colors.purpleAccent.withOpacity(0.2)
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                                  child: Row(
                                    children: [
                                      NormalText(
                                        text: model.intoPicks[index],
                                        textColor: XColors.black(),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                      const XMargin(5),
                                      GestureDetector(
                                        onTap: (){
                                          model.updateSelections(picks: model.intoPicks[index], type: 'into', remove: true);
                                        },
                                        child: const Icon(Icons.close_rounded, size: 16,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),)
                            ],
                          ),
                        ),
                      ),
                    ] else ... [
                      NormalText(
                        text: 'Select what service your shop is into',
                        textColor: XColors.black(),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ],

                    const YMargin(10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            listHelperPicker(
                              context: context,
                              height: 300,
                              title: 'Services Provided',
                              listString: [
                                "Dealership",
                                "Repair and Servicing",
                                "Servicing",
                                "Repair",
                                "Detailing",
                                "Part sales",
                                ],
                              selected: (s) {
                                model.updateSelections(picks: s, type: 'into');
                              },
                            );
                          },
                          child: NormalTextWithContainer(
                            text: 'Pick',
                            textColor: XColors.black(),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const YMargin(30),
                Column(
                  children: [
                    if(model.carMakePicks.isNotEmpty) ... [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...List.generate(model.carMakePicks.length, (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Container(
                                  decoration: BoxDecorators.containerDecoration(
                                      hasOutline: true,
                                      outlineWidth: 1,
                                      radius: 32,
                                      outlineColor: Colors.purpleAccent.withOpacity(0.2)
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                                  child: Row(
                                    children: [
                                      NormalText(
                                        text: model.carMakePicks[index],
                                        textColor: XColors.black(),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                      const XMargin(5),
                                      GestureDetector(
                                        onTap: (){
                                          model.updateSelections(picks: model.carMakePicks[index], type: 'make', remove: true);
                                        },
                                        child: const Icon(Icons.close_rounded, size: 16,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),)
                            ],
                          ),
                        ),
                      ),
                    ] else ... [
                      NormalText(
                        text: 'Select car makes your shop is into',
                        textColor: XColors.black(),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ],
                    const YMargin(10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            listHelperPicker(
                              context: context,
                              height: 500,
                              title: 'Car make',
                              listString: carMakeDataList!,
                              selected: (s) {
                                model.updateSelections(picks: s, type: 'make');
                              },
                            );
                          },
                          child: NormalTextWithContainer(
                            text: 'Pick',
                            textColor: XColors.black(),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const YMargin(110),
              ],),
            ),
          ),
        );
      }
    );
  }

}