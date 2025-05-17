import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

void listHelperPicker({
  required List<String?> listString,
  String? title,
  Function(String? selected)? selected,
  double? height,
  bool searchEnabled = false,
  BuildContext? context}) {
  final TextEditingController searchController = TextEditingController();
  List<String?> filteredList = List.from(listString);

  modalBottomSheetMenu(
    context: context!,
    color: Colors.white,
    child: StatefulBuilder(
      builder: (context, setState) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const YMargin(20),
            if (searchEnabled) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      filteredList = listString
                          .where((element) => element?.toLowerCase().contains(value.toLowerCase()) ?? false)
                          .toList();
                    });
                  },
                ),
              ),
              const YMargin(20),
            ],
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 5, bottom: 8),
                  child: NormalText(
                    text: title,
                    fontWeight: FontWeight.w700,
                    textColor: XColors.black(),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const YMargin(20),
            ...List.generate(filteredList.length, (index) {
              return Padding(
                padding:
                const EdgeInsets.only(left: 24, top: 5, bottom: 18),
                child: InkWell(
                  onTap: () {
                    selected!(filteredList[index]);
                    Navigator.pop(context);
                  },
                  child: NormalText(
                    text: filteredList[index],
                    textColor: XColors.black(),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }),
            const YMargin(20),
          ],
        ),
      ),
    ),
  );
}
