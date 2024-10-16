import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:intl/intl.dart';
import 'package:work_adventure/constant.dart';

class CustomDatePickerField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDatePickerField({
    super.key,
    required this.hintText,
    required this.controller,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  @override
  _CustomDatePickerFieldState createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: widget.hintText,
      controller: widget.controller,
      readOnly: true,
      onTap: () => _selectDate(context),
      suffixIcon: const Icon(Boxicons.bx_calendar),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        widget.controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final bool obscureText;
  final VoidCallback? onTogglePassword;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.obscureText = false,
    this.onTogglePassword,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon ??
            (isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Boxicons.bx_hide : Boxicons.bx_show,
                    ),
                    onPressed: onTogglePassword,
                  )
                : null),
      ),
    );
  }
}

class UsernameTextField extends StatelessWidget {
  final TextEditingController? controller;

  const UsernameTextField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: "Username",
      controller: controller,
    );
  }
}

class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;

  const EmailTextField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: "Email",
      controller: controller,
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  const PasswordTextField({super.key, this.controller});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: "Password",
      isPassword: true,
      obscureText: _obscureText,
      onTogglePassword: _togglePasswordVisibility,
      controller: widget.controller,
    );
  }
}

class CustomSingleSelectToggle extends StatefulWidget {
  final List<String> options;
  final void Function(int) onSelected;
  final bool isVertical;
  final TextStyle? labelStyle;
  final String? initValue;  // เพิ่ม initValue

  const CustomSingleSelectToggle({
    Key? key,
    required this.options,
    required this.onSelected,
    this.isVertical = false,
    this.labelStyle,
    this.initValue,  // เพิ่ม initValue ในคอนสตรัคเตอร์
  }) : super(key: key);

  @override
  _CustomSingleSelectToggleState createState() => _CustomSingleSelectToggleState();
}

class _CustomSingleSelectToggleState extends State<CustomSingleSelectToggle> {
  late List<bool> _selectedOptions;

  @override
  void initState() {
    super.initState();
    _initializeSelectedOptions();
  }

  void _initializeSelectedOptions() {
    _selectedOptions = List.generate(widget.options.length, (_) => false);
    if (widget.initValue != null) {
      final initIndex = widget.options.indexOf(widget.initValue!);
      if (initIndex != -1) {
        _selectedOptions[initIndex] = true;
      } else if (widget.options.isNotEmpty) {
        _selectedOptions[0] = true;  // Default to first option if initValue is not found
      }
    } else if (widget.options.isNotEmpty) {
      _selectedOptions[0] = true;  // Default to first option if initValue is not provided
    }
  }

  @override
  void didUpdateWidget(CustomSingleSelectToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initValue != widget.initValue || oldWidget.options != widget.options) {
      _initializeSelectedOptions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        ToggleButtons(
          direction: widget.isVertical ? Axis.vertical : Axis.horizontal,
          onPressed: (int index) {
            setState(() {
              for (int i = 0; i < _selectedOptions.length; i++) {
                _selectedOptions[i] = i == index;
              }
              widget.onSelected(index);
            });
          },
          isSelected: _selectedOptions,
          borderRadius: BorderRadius.circular(8),
          renderBorder: false,
          selectedColor: baseColor,
          fillColor: primaryColor,
          color: theme.hintColor,
          constraints: const BoxConstraints(
            minHeight: 40.0,
            minWidth: 80.0,
          ),
          children: widget.options.map((option) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(option, style: widget.labelStyle),
          )).toList(),
        ),
      ],
    );
  }
}