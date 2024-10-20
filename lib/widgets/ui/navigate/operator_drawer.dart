import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:work_adventure/screens/todo/work_screen.dart';

class OperatorDrawer extends GetWidget<UserController> {
  const OperatorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                        'assets/images/characters/wizard.png'), // ใส่รูปโปรไฟล์ของผู้ใช้ที่นี่
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.user.value?.username as String, // ชื่อผู้ใช้
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      // const Text(
                      //   'Level 42', // เลเวลของผู้ใช้
                      //   style: TextStyle(fontSize: 14, color: Colors.grey),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildStatTile(
                      'Focus points',
                      "${controller.currentUserStats?.totalFocusPoint}",
                      Boxicons.bx_time),
                  _buildStatTile(
                      'Coins',
                      "${controller.currentUserStats?.totalCoin}",
                      Boxicons.bx_coin_stack),
                  _buildStatTile(
                    'Scores',
                    "${(controller.currentUserStats!.totalFocusPoint * (controller.currentUserStats!.totalCoin * 0.2)).round()}",
                    Boxicons.bx_award,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildActionButton('Ranking', Boxicons.bx_award, () {
                    Get.bottomSheet(BottomSheetContent(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Boxicons.bx_award, size: 24,),
                                Text(
                                  "Ranking",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Obx(
                            () => ListView.builder(
                              physics:
                                  const NeverScrollableScrollPhysics(), // ปิดการ scroll ของ ListView
                              shrinkWrap: true, //
                              itemCount: controller.ranking.value.length,
                              itemBuilder: (context, index) {
                                UserStats user =
                                    controller.ranking.value[index];
                                return buildRankingItem(index, user);
                              },
                            ),
                          )
                        ],
                      ),
                    ));
                  }),
                  const SizedBox(height: 10),
                  
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Boxicons.bx_exit),
              title: const Text('Logout'),
              onTap: () {
                controller.logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRankingItem(int index, UserStats user) {
    bool isCurrentUser = user.userId == controller.user.value?.id as String;
    Color backgroundColor =
        isCurrentUser ? Colors.blue.withOpacity(0.1) : Colors.transparent;
    Color textColor = isCurrentUser ? Colors.blue : Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: _getRankColor(index),
          child: Text(
            '${index + 1}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          user.username,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'FP: ${user.totalFocusPoint}',
          style: TextStyle(color: textColor.withOpacity(0.7)),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            
            Text(
              '${user.totalCoin}',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              'Coins',
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber[700]!;
      case 1:
        return Colors.blueGrey[400]!;
      case 2:
        return Colors.brown[400]!;
      default:
        return Colors.blue[300]!;
    }
  }

  Widget _buildStatTile(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.pink[400]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String title, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        minimumSize: const Size(double.infinity, 40),
      ),
    );
  }
}
