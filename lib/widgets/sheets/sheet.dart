import 'package:flutter/material.dart';

class SheetHeader extends StatelessWidget {
  final String title;
  const SheetHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class SheetBody extends StatelessWidget {
  final List<Widget> children;
  const SheetBody({super.key, this.children = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: children,
      ),
    );
  }
}

class SheetContents extends StatelessWidget {
  final List<Widget> children;

  const SheetContents({super.key, this.children = const []});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        children: children,
      ),
    );
  }
}
