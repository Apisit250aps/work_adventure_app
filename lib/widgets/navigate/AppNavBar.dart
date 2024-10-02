import 'package:flutter/material.dart';

class AppBarNav extends StatelessWidget {
  final List<Widget>?
      actions; // เปลี่ยนชนิดข้อมูลเป็น List<Widget> เพื่อความชัดเจน
  final String title;

  const AppBarNav({super.key, this.actions = const [], required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 145.0, // ความสูงเมื่อขยายเต็มที่
      floating: true,
      pinned: true,
      snap: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
        background: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: FlutterLogo(), // เปลี่ยนพื้นหลังหรือ widget ได้ตามที่ต้องการ
        ),
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
        ],
      ),
      actions:
          actions != null && actions!.isNotEmpty // ตรวจสอบว่ามี actions หรือไม่
              ? [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: Row(
                      children: actions!, // ใช้ actions ที่ผ่านการตรวจสอบแล้ว
                    ),
                  ),
                ]
              : null, // ถ้าไม่มี actions จะไม่แสดงอะไรเลย
    );
  }
}
