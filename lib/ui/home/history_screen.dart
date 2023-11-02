import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            ...List.generate(5, (index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: HistoryListView(
                      body: 'Oil servicing',
                      price: 'N 6,000',
                      date: '10-1-2024',
                    ),
                  );
              }
            ),
          ],
        ),
      ),
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
                textColor: XColors.textColor(),
                fontSize: 10,
              ),
              const YMargin(10),
              NormalText(
                text: body,
                textColor: XColors.textColor(),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          NormalText(
            text: price,
            textColor: XColors.textColor(),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
