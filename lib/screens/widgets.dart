import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GradientBackgroundScreen extends StatelessWidget {
  final Widget child;
final String? appBarText;
  GradientBackgroundScreen({super.key, required this.child,this.appBarText=''});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF092F1C), // Ending color of the gradient
              Colors.black, // Starting color of the gradient
            ],
            begin: Alignment.topRight, // Starting point of the gradient
            end: Alignment.center, // Ending point of the gradient
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: appBarText!.isEmpty ? 0 : 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              appBarText!.isEmpty ? SizedBox() :  IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    context.pop();
                  },
                ),
                Text(
                  appBarText!,
                  style: TextStyle(color: Colors.white,fontSize: 18),
                ),
                SizedBox(
                  width: 40,
                )
              ],
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
