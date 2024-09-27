import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/models/character_statistic_model.dart';
import 'package:work_adventure/widgets/sheets/sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CharacterController charController = Get.put(CharacterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 145.0, // ความสูงเมื่อขยายเต็มที่
            floating: true,
            pinned: true,
            snap: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            scrolledUnderElevation: 0,
            flexibleSpace: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              title: Text(
                'Characters',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: FlutterLogo(),
              ),
              stretchModes: [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Boxicons.bx_message_square_add,
                          size: 24,
                          color: Colors.white,
                        ),
                        onPressed: () => _showBottomSheet(context),
                        padding: EdgeInsets.zero,
                        // constraints: const BoxConstraints.tightFor(
                        // ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return CharacterCard(
                  character: charController.charactersSlot[index],
                );
              },
              childCount: charController.charactersSlot.length, // จำนวนรายการ
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return const SheetContents(
          children: [
            SheetHeader(
              title: "New Character",
            ),
            SheetBody(
              children: [],
            )
          ],
        );
      },
    );
  }
}

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      color: Colors.white,
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.person, size: 24),
                const SizedBox(width: 8),
                Text(
                  character.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              character.className,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.star, 'Level', character.level.toString()),
            _buildInfoRow(Icons.flash_on, 'EXP', character.exp.toString()),
            _buildInfoRow(
                Icons.favorite, 'Health', character.health.toString()),
            _buildInfoRow(Icons.bolt, 'Stamina', character.stamina.toString()),
            _buildInfoRow(
                Icons.monetization_on, 'Coins', character.coin.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
