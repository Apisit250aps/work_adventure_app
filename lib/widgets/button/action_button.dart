import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon; // ไอคอนที่ต้องการแสดง
  final VoidCallback onPressed; // ฟังก์ชันที่จะถูกเรียกเมื่อกดปุ่ม

  const ActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 0), // กำหนด Margin
      decoration: BoxDecoration(
        color: Colors.black, // สีพื้นหลังของปุ่ม
        borderRadius: BorderRadius.circular(15), // มุมโค้งของปุ่ม
      ),
      child: IconButton(
        icon: Icon(
          icon, // ใช้ไอคอนที่ส่งเข้ามา
          size: 24,
          color: Colors.white, // สีของไอคอน
        ),
        onPressed: onPressed, // ฟังก์ชันที่ส่งเข้ามาเมื่อกดปุ่ม
        padding: EdgeInsets.zero, // ไม่ใช้ Padding
      ),
    );
  }
}