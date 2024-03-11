import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, this.homeViewModel, this.noEmptyData = true});

  final HomeViewModel? homeViewModel;
  final bool? noEmptyData;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => homeViewModel!,
        disposeViewModel: false,
        builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  popView(context);
                },
                child: Icon(Icons.arrow_back_ios_rounded, size: 18, color: XColors.black(),)
            ),
          ),
          floatingActionButton: Container(
            height: 60,
            width: 100,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecorators.containerDecoration(
              hasOutline: false,
              color: XColors.primaryColor(),
              outlineWidth: 2,
              radius: 32,
            ),
            child: NormalText(
              text: 'Add',
              textColor: XColors.white(),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [

                if(noEmptyData == false) ... [

                  const EmptyView(),

                ] else ... [

                  Column(
                    children: [
                      NormalText(
                        text: 'Total expense',
                        textColor: XColors.textColor().withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      NormalText(
                        text: 'N ${numberFormat(number: model.totalCostingAndValue![model.currentBudgetTypeIndex!].toDouble())}',
                        textColor: XColors.textColor(),
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  const YMargin(25),

                ],

                if(model.currentBudgetTypeIndex == 0) ... [

                  ...List.generate(model.fueling!.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: HistoryListView(
                        body: 'Bought fuel for',
                        price: 'N ${numberFormat(number: model.fueling![index].price!.toDouble())}',
                        date: model.fueling![index].date,
                      ),
                    );
                    }
                  ),

                ]
                else if (model.currentBudgetTypeIndex == 1) ... [

                  ...List.generate(model.servicing!.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: HistoryListView(
                        body: model.servicing![index].condition,
                        price: 'N ${numberFormat(number: model.servicing![index].price!.toDouble())}',
                        date: model.servicing![index].date ?? '',
                      ),
                    );
                  }
                  ),

                ]
                else if (model.currentBudgetTypeIndex == 2) ... [

                  ...List.generate(model.repairing!.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: HistoryListView(
                        body: model.repairing![index].condition,
                        price: 'N ${numberFormat(number: model.repairing![index].price!.toDouble())}',
                        date: model.repairing![index].date ?? '',
                      ),
                    );
                  }
                  ),

                ]
                else if (model.currentBudgetTypeIndex == 4) ... [

                  ...List.generate(model.breakdowns!.length, (index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: HistoryListView(
                        body: 'Had breakdown',
                        price: '',
                        date: '10-1-2024',
                      ),
                    );
                  }
                  ),

                ],

              ],
            ),
          ),
        );
      }
    );
  }
}

class HistoryListView extends StatelessWidget {
  const HistoryListView({super.key, this.body, this.price, this.date});

  final String? body;
  final String? price;
  final String? date;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalText(
                text: date,
                textColor: XColors.textColor().withOpacity(0.6),
                fontSize: 10,
              ),
              const YMargin(10),
              NormalText(
                text: body,
                textColor: XColors.textColor(),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          NormalText(
            text: price,
            textColor: XColors.textColor(),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: NormalText(
      text: 'No entries made yet for this section',
      textColor: XColors.textColor(),
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),);
  }

}
