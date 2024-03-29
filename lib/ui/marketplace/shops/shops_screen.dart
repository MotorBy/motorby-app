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
import 'package:mobile_auto_drive/widgets/loader.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class ShopsScreen extends StatelessWidget {
  ShopsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShopViewModel>.reactive(
        viewModelBuilder: () => ShopViewModel(),
        onViewModelReady: (model) => model.initialise(),
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
                  XMargin(20),
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
                      ...List.generate(model.shopTypes.length, (index) => Padding(
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
                            text: model.shopTypes[index],
                            textColor: XColors.textColor().withOpacity(0.4),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      )),
                    ],),
                  ),
                  if(model.busy('shops')) ... [

                    SizedBox(
                      height: MediaQuery.of(context).size.height - 350,
                      child: const Center(
                          child: Loader()
                      ),
                    ),

                  ] else if(!model.busy('shops') && model.shops!.isNotEmpty) ... [

                    const YMargin(20),
                    ...List.generate(model.shops!.length, (index) {
                      return GestureDetector(
                        onTap: (){
                          model.updateCurrentShop(model.shops![index]);
                          navigate(context, ShopDetailsScreen(
                            shopViewModel: model,
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ShopListItem(
                            name: model.shops![index].name,
                          ),
                        ),
                      );
                    }),
                  ]
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
  const ShopListItem({
    super.key,
    this.name,
    this.logo,
    this.distance
  });

  final String? name;
  final String? distance;
  final String? logo;

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
            height: 23,
            width: 23,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                32,
              ),
            ),
            child: Image.asset('assets/images/icons/online_store.png'),
          ),
          const XMargin(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalText(
                text: name ?? 'Auto shop',
                textColor: XColors.textColor(),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              Row(
                children: [
                  NormalText(
                    text: distance ?? 'some kms away',
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