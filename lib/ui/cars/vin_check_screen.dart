import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/cars/add_car_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/snackbar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class VinCheckScreen extends StatelessWidget {
  const VinCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddCarViewModel>.reactive(
        viewModelBuilder: () => AddCarViewModel(),
        disposeViewModel: false,
        builder: (context, model, child) {
        return Scaffold(
          backgroundColor: XColors.white(),
          appBar: AppBar(
            backgroundColor: XColors.white(),
            surfaceTintColor: XColors.white(),
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () {
                popView(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 21,
                  color: Colors.purpleAccent,
                ),
              ),
            ),
            title: NormalText(
              text: '',
              textColor: XColors.textColor(),
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          floatingActionButton: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const XMargin(32),
              XButton(
                onPressed: () {
                  model.makeVinCheck(
                    onCallBack: (){

                    },
                    onErrorCallBack: (e){
                      showSnackBar(
                          error: true,
                          context: context,
                          message: e
                      );
                    }
                  );
                },
                text: 'Check',
                isLoading: model.isBusy,
                buttonColor: XColors.primaryColor(),
                width: 120,
              ),
              // const XMargin(12),
              // XButton(
              //   onPressed: () {
              //
              //   },
              //   text: 'Compare',
              //   isLoading: false,
              //   buttonColor: XColors.primaryColor().withOpacity(0.2),
              //   width: 120,
              // ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Column(
                    children: [

                      const YMargin(15),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        NormalText(
                          text: 'This process will help tell the true state of your car and its make',
                          textColor: XColors.black(),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        const YMargin(25),
                        NormalText(
                          text: model.vinNumber!.isNotEmpty ? model.vinNumber : '000000',
                          textColor: XColors.black(),
                          fontWeight: FontWeight.w700,
                          fontSize: 21,
                        ),
                      ],),

                      const YMargin(25),

                      MkInputField2(
                        label: "Vin number",
                        isEnabled: true,
                        onChanged: (s){
                          model.updateVinNumber(s);
                        },
                      ),

                    ],
                  ),
                  const YMargin(60),
                  Container(
                    height: 350,
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      children: List.generate(model.vinDataLabel.length, (index) {
                        return Container(
                          height: 50,
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  model.vinDataLabel[index],
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                    fontSize: 12
                                  ),
                                ),
                                const YMargin(15),
                                Text(
                                  '-',
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                      fontSize: 15,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
