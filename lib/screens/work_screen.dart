import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:work_adventure/widgets/base/work/create_work_sheet.dart';
import 'package:work_adventure/widgets/navigate/BottomNavBar.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                'Works',
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
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Your content goes here'),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Card.outlined(
                  color: Colors.white,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Title',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '1 day ago',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This is a brief description of the work item. It provides a quick overview of the task or project.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: 50, // จำนวนรายการ
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(
        selectedIndex: 0,
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
        return const CreateWorkSheet();
      },
    );
  }
}
