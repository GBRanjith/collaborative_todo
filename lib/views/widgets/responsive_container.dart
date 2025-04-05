
// views/widgets/responsive_container.dart
import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
 final Widget child;
 final double maxWidth;
 final EdgeInsetsGeometry padding;

 const ResponsiveContainer({
 Key? key,
 required this.child,
 this.maxWidth = 768,
 this.padding = EdgeInsets.zero,
 }) : super(key: key);

 @override
 Widget build(BuildContext context) {
 return Center(
 child: ConstrainedBox(
 constraints: BoxConstraints(
 maxWidth: maxWidth,
 ),
 child: Padding(
 padding: padding,
 child: child,
 ),
 ),
 );
 }
}