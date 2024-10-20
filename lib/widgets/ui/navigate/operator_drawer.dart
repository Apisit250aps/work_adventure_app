import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/user_controller.dart';

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
                      const Text(
                        'Level 42', // เลเวลของผู้ใช้
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
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
                  _buildStatTile('Focus points', '12,345', Boxicons.bx_time),
                  _buildStatTile('Coins', '87', Boxicons.bx_coin_stack),
                  _buildStatTile('Items Collected', '254', Icons.category),
                  const SizedBox(height: 20),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildActionButton('Daily Reward', Icons.card_giftcard, () {
                    // โค้ดสำหรับรับรางวัลประจำวัน
                  }),
                  const SizedBox(height: 10),
                  _buildActionButton('Inventory', Icons.inventory, () {
                    // โค้ดสำหรับเปิดหน้า Inventory
                  }),
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

  Widget _buildStatTile(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: secondaryColor),
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
