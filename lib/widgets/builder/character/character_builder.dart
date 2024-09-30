import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/models/character_model.dart';
import 'package:work_adventure/widgets/cards/character_card.dart';
import 'package:work_adventure/widgets/loading/slime_loading.dart';

class CharacterBuilder extends StatefulWidget {
  final Future<List<Character>> characters;
  const CharacterBuilder({super.key, required this.characters});

  @override
  State<CharacterBuilder> createState() => _CharacterBuilderState();
}

class _CharacterBuilderState extends State<CharacterBuilder> {
  final CharacterController characterController = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Character>>(
      future: widget.characters, // Call the future function
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the data, show a loading spinner
          return const SliverToBoxAdapter(
            child: Center(
                child: SlimeLoading(
              width: 32,
            )),
          );
        } else if (snapshot.hasError) {
          // If an error occurred, display an error message
          return SliverToBoxAdapter(
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          // If data is available, build the SliverList
          final characters = snapshot.data!;
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return CharacterCard(
                  character: characters[index],
                  index: index,
                );
              },
              childCount:
                  characters.length, // Use the length of the fetched data
            ),
          );
        } else {
          return const SliverToBoxAdapter(
            child: Center(child: Text('No data available.')),
          );
        }
      },
    );
  }
}