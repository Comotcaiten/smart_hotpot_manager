import 'package:flutter/material.dart';

/// Widget ModalForm — hiển thị một AlertDialog form có thể tái sử dụng
class ModalForm extends StatefulWidget {
  final String title; // Tiêu đề modal (VD: "Thêm danh mục")
  final List<FormFieldData> fields; // Danh sách các field (VD: name, description)
  final VoidCallback? onCancel; // Khi bấm Hủy
  final  Future<void> Function() onSubmit; // Khi bấm Lưu

  const ModalForm({
    super.key,
    required this.title,
    required this.fields,
    required this.onSubmit,
    this.onCancel,
  });

  @override
  State<ModalForm> createState() => _ModalFormState();
}

class _ModalFormState extends State<ModalForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          ),
        ],
      ),
      content: Container(
        width: 500,
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final field in widget.fields) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    field.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: field.controller,
                  keyboardType: field.keyboardType,
                  enabled: !_isSubmitting,
                  decoration: InputDecoration(
                    hintText: field.hintText,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (field.isRequired && (value == null || value.isEmpty)) {
                      return 'Vui lòng nhập ${field.label.toLowerCase()}';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : widget.onCancel ?? () => Navigator.pop(context),
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : () async {
            if (_formKey.currentState?.validate() ?? false) {
              setState(() => _isSubmitting = true);
              
              try {
               await widget.onSubmit();
              }
              finally {}
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          child: const Text("Lưu"),
        ),
      ],
    );
  }
}

/// Mô tả 1 field trong form
class FormFieldData {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isRequired;

  FormFieldData({
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isRequired = true,
  });
}
