import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home_nav/home_nav_vmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_view_model.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapViewModel>.reactive(
        viewModelBuilder: () => MapViewModel(),
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
                 backgroundColor: XColors.highlightColor().withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
              title: buildField(
                context,
                viewModel,
                'Try gas station, repair shops',
                viewModel.search,
                () {},
                false,
                const GetSvgImage(
                  image: 'assets/images/search-icon.svg',
                  boxFit: BoxFit.scaleDown,
                ),
              ),
            ),
            body: const ContainerWidget(),
          );
        });
  }
}

Widget buildField(
    BuildContext context,
    MapViewModel model,
    String label,
    TextEditingController controller,
    Function() function,
    bool isReadOnly,
    Widget? preficIcon,
    [int? maxLine,
    Color? background]) {
  return TextFormField(
    decoration: InputDecoration(
      
   border: InputBorder.none,   
      hintText: label,
      prefixIcon: preficIcon,
      filled: true,
      fillColor: background ??  XColors.highlightColor().withOpacity(0.1),
    ),
    maxLines: maxLine,
    readOnly: isReadOnly,
    controller: controller,
    onTap: function,
  );
}
