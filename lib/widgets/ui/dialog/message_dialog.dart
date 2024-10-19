import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageDialog extends StatelessWidget {
  final String? title;
  final String message;
  final String icon;
  final String? btnText;

  const MessageDialog({
    Key? key,
    this.title,
    required this.message,
    required this.icon,
    this.btnText = "Okay",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: Get.width * 0.75,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          iconDialog(),
          if (title != null) titleDialog(),
          Text(
            message,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getColor(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () => Get.back(),
                  child: Text(
                    btnText!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget iconDialog() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getColor().withOpacity(0.1),
          ),
          child: Icon(
            _getIconData(),
            color: _getColor(),
            size: 30,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget titleDialog() {
    return Column(
      children: [
        Text(
          title!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Color _getColor() {
    switch (icon) {
      case 'error':
        return Colors.red;
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconData() {
    switch (icon) {
      case 'error':
        return Icons.error_outline;
      case 'success':
        return Icons.check_circle_outline;
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'info':
        return Icons.info_outline;
      default:
        return Icons.help_outline;
    }
  }
}
