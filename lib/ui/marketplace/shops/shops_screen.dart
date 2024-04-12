import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'package:mobile_auto_drive/widgets/shimmer_loader.dart';
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

                  if(model.hasData != true && model.busy('shops') == false) ... [

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                      child: NormalText(
                        text: 'No shops opened for now, check back later.',
                        textColor: XColors.black(),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),

                  ],

                  ...List.generate(
                    model.hasData == true ? model.shops!.length : 6,
                        (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          model.updateCurrentShop(model.shops![index]);
                          navigate(context, ShopDetailsScreen(
                            shopViewModel: model,
                          ));
                        },
                        child: Shimmer(
                          child: ShimmerLoading(
                            isLoading: model.busy('shops') || model.hasData != true,
                            child: _buildItem(
                                isLoading: model.busy('shops') || model.hasData != true,
                                model: model,
                                currentIndex: index
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildItem({
    bool? isLoading = false,
    ShopViewModel? model,
    int? currentIndex
  }) {
    if (isLoading!) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 34,
                  width: 34,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      width: 230,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 24,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ShopListItem(
            name: model!.shops![currentIndex!].name,
          ),
        ),
      );
    }
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