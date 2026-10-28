import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key, this.size}) : super(key: key);
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size ?? 100,
        child: Lottie.asset('assets/lotties/books.json'),
      ),
    );
  }
}

class AppSpacerH extends StatelessWidget {
  const AppSpacerH(
    this.height, {
    Key? key,
  }) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class AppSpacerW extends StatelessWidget {
  const AppSpacerW(
    this.width, {
    Key? key,
  }) : super(key: key);
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}

class NoRecordWidget extends StatelessWidget {
  const NoRecordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No Record Found'),
    );
  }
}

class ErrorHandleWidget extends StatelessWidget {
  const ErrorHandleWidget({Key? key, required this.error}) : super(key: key);
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}
