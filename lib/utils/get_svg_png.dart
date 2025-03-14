import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GetSvgImage extends StatelessWidget {
  const GetSvgImage({super.key,required this.image,this.boxFit= BoxFit.contain,this.color,this.width,this.height});
final double? width;
 final Color? color;
 final BoxFit boxFit;
final String image;
final  double? height;
  @override
  Widget build(BuildContext context) {
     return SvgPicture.asset(
   image,
    colorFilter:
        color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    width: width,
    height: height,
    fit: boxFit,
  );
}}

class GetPngImage extends StatelessWidget {
  const GetPngImage({super.key,required this.image,this.boxFit= BoxFit.contain,this.color,this.width,this.height});
final double? width;
 final Color? color;
 final BoxFit boxFit;
final String image;
final  double? height;
  @override
  Widget build(BuildContext context) {
return Image.asset(
   image,
    color: color,
    width: width,
    height: height,
    fit: boxFit,
  );
}}
