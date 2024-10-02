import 'package:flutter/material.dart';
import 'package:work_adventure/models/work_model.dart';
import 'package:work_adventure/widgets/cards/work_card.dart';

class WorkBuilder extends StatelessWidget {
  final List<Work> works;
  const WorkBuilder({super.key, required this.works});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), 
        itemCount: works.length,
        itemBuilder: (context, index) {
          return WorkCard(
            work: works[index],
            index: index,
          );
        },
      ),
    );
  }
}