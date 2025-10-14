// import 'package:flutter/material.dart';

// class MyButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final Color color; 
//   final double? width;
//   final double? height;

//   const MyButton({
//     Key? key,
//     required this.text,
//     required this.onPressed,
//     this.color = Colors.black,
//     this.width,
//     this.height,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width ?? double.infinity, 
//       height: height ?? 50,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(25),
//           ),
//         ),
//         onPressed: onPressed,
//         child: Text(
//           text,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w900,
//           ),
//           textScaler: TextScaler.linear(1),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final double? width;
  final double? height;
  final bool isLoading;

  const MyButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.black,
    this.width,
    this.height,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading ? color.withOpacity(0.7) : color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
                textScaler: TextScaler.linear(1),
              ),
      ),
    );
  }
}