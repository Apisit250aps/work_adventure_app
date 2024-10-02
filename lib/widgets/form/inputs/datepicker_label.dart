import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:intl/intl.dart';

class DatePickerLabel extends StatelessWidget {
  final String label;
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate; // เพิ่มตัวแปร selectedDate

  const DatePickerLabel({
    super.key,
    required this.label,
    required this.onDateSelected,
    this.selectedDate, // รับ selectedDate จากภายนอก
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      onDateSelected(picked); // ส่งวันที่ที่เลือกออกไป
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade900,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate == null
                      ? 'Select date'
                      : DateFormat('MMM dd, yyyy').format(selectedDate!),
                  style: const TextStyle(fontSize: 16),
                ),
                Icon(Icons.calendar_today, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DateInputLabel extends StatelessWidget {
  final String label;
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate;
  final TextEditingController _controller = TextEditingController();

  DateInputLabel({
    super.key,
    required this.label,
    required this.onDateSelected,
    this.selectedDate,
  }) {
    // กำหนดค่าเริ่มต้นให้กับ TextField หากมี selectedDate
    if (selectedDate != null) {
      _controller.text = DateFormat('MMM dd, yyyy').format(selectedDate!);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black, // สีหลักของ datepicker
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // สีปุ่มยืนยัน
              onSurface: Colors.black, // สีของข้อความในตัวเลือก
            ),
            dialogBackgroundColor: Colors.white, // สีพื้นหลังของ dialog
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // ปรับขอบของ dialog
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // สีปุ่มใน dialog
              ),
            ),
            
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      _controller.text = DateFormat('MMM dd, yyyy').format(picked);
      onDateSelected(picked); // ส่งวันที่ที่เลือกออกไป
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade900,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: TextField(
            controller: _controller,
            readOnly: true, // ไม่ให้พิมพ์ใน TextField
            onTap: () => _selectDate(
                context), // เรียกการเลือกวันที่เมื่อคลิกที่ TextField
            decoration: InputDecoration(
              prefixIcon: const Icon(Boxicons.bx_calendar),
              hintText: 'Select date',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 3,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
