import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool? readOnly;
  final Function()? onTap;
  final String? initialValue;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator;
  final Color? labelColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? isVisible;
  final VoidCallback? onVisibilityToggle;
  final Icon? prefixIcon;

  const CustomTextField({
    super.key,
    this.label,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.prefixIcon,
    required this.controller,
    this.initialValue = '',
    this.obscureText = false,
    this.enabled = true,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.labelColor,
    this.isVisible,
    this.onVisibilityToggle,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.isVisible ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      readOnly: widget.readOnly!,
      controller: widget.controller,
      obscureText: widget.obscureText && !_isPasswordVisible,
      onChanged: widget.onChanged,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      style: TextStyle(color: Colors.white30),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(color: widget.labelColor ?? Color(0xffBAC0C6)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: customBlue, width: 2.0), // Ensure visibility
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffBAC0C6), width: 1.5), // Visible border
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffBAC0C6), width: 1.0), // Default border
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        filled: true,
        fillColor: Colors.transparent, // Try making it transparent if blending is an issue
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.onVisibilityToggle != null
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
            if (widget.onVisibilityToggle != null) {
              widget.onVisibilityToggle!();
            }
          },
        )
            : null,
      ),
    );
  }
}
