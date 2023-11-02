import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/marketplace/shops/create_shop_screen.dart';
import 'package:mobile_auto_drive/ui/marketplace/shops/shop_details_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class ShopsScreen extends StatelessWidget {
  ShopsScreen({super.key});

  final List<String> shopTypes = ["All", "Dealer", "Repair", "Detailing", "Servicing"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            popView(context);
          },
          child: const Icon(Icons.arrow_back_ios_rounded, size: 21, color: Colors.purpleAccent,),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: (){
          navigate(context, CreateShopScreen());
        },
        child: Container(
          height: 60,
          width: 200,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecorators.containerDecoration(
            hasOutline: false,
            color: XColors.primaryColor(),
            outlineWidth: 2,
            radius: 32,
          ),
          child: NormalText(
            text: 'Create shop',
            textColor: XColors.white(),
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
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
              Container(
                height: MediaQuery.of(context).size.height - 50,
                child: GridView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 21,
                      mainAxisSpacing: 20,
                      mainAxisExtent: 171),
                  itemBuilder: (BuildContext context, int position) {
                    return GestureDetector(
                      onTap: (){
                        navigate(context, const ShopDetailsScreen());
                      },
                        child: const ShopListItem(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShopListItem extends StatelessWidget {
  const ShopListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecorators.containerDecoration(
          hasOutline: true,
          outlineWidth: 2,
          radius: 26,
          outlineColor: Colors.purpleAccent.withOpacity(0.2)
      ),
      child: Column(
        children: [
          const YMargin(20),
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                32,
              ),
            ),
            child: Image.asset('assets/images/auto/bmw_logo.jpeg'),
          ),
          const YMargin(20),
          NormalText(
            text: 'Auto shop',
            textColor: XColors.textColor(),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          )
        ],
      ),
    );
  }
}