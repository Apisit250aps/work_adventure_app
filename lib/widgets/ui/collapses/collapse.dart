import 'package:flutter/material.dart';
import 'package:work_adventure/constant.dart';

class CollapseContent extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;

  const CollapseContent({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.onDoubleTap,
    this.onLongPress,
  });

  @override
  State<CollapseContent> createState() => _CollapseContentState();
}

class _CollapseContentState extends State<CollapseContent> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          onDoubleTap: widget.onDoubleTap,
          onLongPress: widget.onLongPress,
          child: Container(
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  offset: Offset(0, 0), // corresponds to 0px 10px
                  blurRadius: 10, // corresponds to 50px
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isExpanded ? null : 0,
          child: AnimatedOpacity(
            opacity: _isExpanded ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 0,
              ),
              height: 200,
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}
