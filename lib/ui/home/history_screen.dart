import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';
import 'package:mobile_auto_drive/ui/home/info_details_action/info_details_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    super.key,
    this.infoDetailsViewModel,
    this.noEmptyData = true
  });

  final InfoDetailsViewModel? infoDetailsViewModel;
  final bool? noEmptyData;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InfoDetailsViewModel>.reactive(
        viewModelBuilder: () => infoDetailsViewModel!,
        disposeViewModel: false,
        builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  popView(context);
                },
                child: Icon(Icons.arrow_back_ios_rounded, size: 18, color: XColors.black(),)
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
                        text: 'Total ${ model.currentBudgetTypeIndex == 4 ? 'breakdown' : 'expense' }',
                        textColor: XColors.textColor().withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      const YMargin(15),
                      NormalText(
                        text: model.currentBudgetTypeIndex != 4 ?
                            '₦${numberFormat(number: model.totalCostingAndValue![model.currentBudgetTypeIndex!].toDouble())}'
                            : model.totalCostingAndValue![model.currentBudgetTypeIndex!].toString(),
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
                    return HistoryListView(
                      body: 'Bought fuel for',
                      price: '₦${numberFormat(number: model.fueling![index].price!.toDouble())}',
                      date: model.fueling![index].date,
                    );
                    }),

                ]
                else if (model.currentBudgetTypeIndex == 1) ... [

                  ...List.generate(model.servicing!.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: HistoryListView(
                        body: model.servicing![index].condition,
                        price: '₦${numberFormat(number: model.servicing![index].price!.toDouble())}',
                        date: model.servicing![index].date ?? '',
                      ),
                    );
                  }),

                ]
                else if (model.currentBudgetTypeIndex == 2) ... [

                  ...List.generate(model.repairing!.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: HistoryListView(
                        body: model.repairing![index].condition,
                        price: '₦${numberFormat(number: model.repairing![index].price!.toDouble())}',
                        date: model.repairing![index].date ?? '',
                      ),
                    );
                  }),

                ]
                else if (model.currentBudgetTypeIndex == 4) ... [

                  ...List.generate(model.breakdowns!.length, (index) {
                    return HistoryListView(
                      body: 'Had breakdown',
                      price: 'at ${model.breakdowns![index].location}',
                      date: model.breakdowns![index].date,
                    );
                  }),
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
      child: Column(
        children: [
          Row(
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: Divider(thickness: 0.4, color: XColors.primaryColor2().withOpacity(0.3),),
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
