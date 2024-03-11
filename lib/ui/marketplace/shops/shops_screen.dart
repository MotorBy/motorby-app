import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/marketplace/shops/create_shop_screen.dart';
import 'package:mobile_auto_drive/ui/marketplace/shops/shop_details_screen.dart';
import 'package:mobile_auto_drive/ui/marketplace/shops/shop_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class ShopsScreen extends StatelessWidget {
  ShopsScreen({super.key});

  final List<String> shopTypes = ["All", "Dealer", "Repair", "Detailing", "Servicing", "Parts"];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShopViewModel>.reactive(
        viewModelBuilder: () => ShopViewModel(),
        disposeViewModel: false,
        builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: (){
                popView(context);
              },
              child: const Row(
                children: [
                  Icon(Icons.arrow_back_ios_rounded, size: 21, color: Colors.purpleAccent,),
                ],
              ),
            ),
          ),
          floatingActionButton: !isBusiness ? XButton(
            onPressed: () {
              navigate(context, const CreateShopScreen());
            },
            text: 'Create shop',
            isLoading: model.isBusy,
            buttonColor: XColors.primaryColor(),
            width: 120,
          ) : null,
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                      ...List.generate(shopTypes.length, (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecorators.containerDecoration(
                              hasOutline: true,
                              outlineWidth: 2,
                              radius: 32,
                              outlineColor: Colors.purpleAccent.withOpacity(0.2)
                          ),
                          child: NormalText(
                            text: shopTypes[index],
                            textColor: XColors.textColor().withOpacity(0.4),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      )),
                    ],),
                  ),
                  const YMargin(20),
                  ...List.generate(5, (index) {
                    return GestureDetector(
                      onTap: (){
                        navigate(context, const ShopDetailsScreen());
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ShopListItem(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

class ShopListItem extends StatelessWidget {
  const ShopListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecorators.containerDecoration(
          hasOutline: false,
      ),
      child: Row(
        children: [
          const YMargin(20),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                32,
              ),
            ),
            child: Image.asset('assets/images/auto/bmw_logo.jpeg'),
          ),
          const XMargin(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalText(
                text: 'Auto shop',
                textColor: XColors.textColor(),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              Row(
                children: [
                  NormalText(
                    text: 'Few kms away',
                    textColor: XColors.textColor(),
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}