import 'package:flutter/material.dart';

/// Widget ModalForm — hiển thị một AlertDialog form có thể tái sử dụng
class ModalForm extends StatefulWidget {
  final String title; // Tiêu đề modal (VD: "Thêm danh mục")
  final List<FormFieldData>
  fields; // Danh sách các field (VD: name, description)
  final VoidCallback? onCancel; // Khi bấm Hủy
  final Future<void> Function() onSubmit; // Khi bấm Lưu

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
    return StatefulBuilder(
      builder: (context, setModalState) {
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
                    _buildField(field, setModalState),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: _isSubmitting
                  ? null
                  : widget.onCancel ?? () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: _isSubmitting
                  ? null
                  : () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        setState(() => _isSubmitting = true);

                        try {
                          await widget.onSubmit();
                        } finally {}
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
      },
    );
  }

  Widget _buildField(
    FormFieldData field,
    void Function(void Function()) setModalState,
  ) {
    if (field is FormFieldDataText) {
      return _buildTextField(field, setModalState);
    } else if (field is FormFieldDataDropDown) {
      return _buildDropdownField(field, setModalState);
    } else {
      return const SizedBox();
    }
  }

  Widget _buildTextField(
    FormFieldDataText field,
    void Function(void Function()) setModalState,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            field.label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: field.controller,
          keyboardType: field.keyboardType,
          enabled: field.disable ? !field.disable : !_isSubmitting,
          decoration: InputDecoration(
            hintText: field.hintText,
            border: const OutlineInputBorder(),
          ),
          // validator: (value) {
          //   if (field.isRequired && (value == null || value.isEmpty)) {
          //     return 'Vui lòng nhập ${field.label.toLowerCase()}';
          //   }
          //   return null;
          // },
          validator: field.validator,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdownField(
    FormFieldDataDropDown field,
    void Function(void Function())? setModalState,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: StreamBuilder<List>(
        stream: field.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
          return DropdownButtonFormField(
            
            value: field.selectedValue,
            hint: Text(field.hintText),
            decoration: InputDecoration(labelText: field.label),
            items: items.map((item) {
              return DropdownMenuItem(value: item.id, child: Text(item.name));
            }).toList(),
            onChanged: !_isSubmitting ? (value) {
              if (setModalState != null) {
                setModalState(() => field.selectedValue = value.toString());
                field.onChanged?.call(value);
              }
            } : null,
            validator: field.validator,
          );
        },
      ),
    );
  }
}

/// ==================
/// Base class
/// ==================
class FormFieldData {}

/// =======================
/// TEXT FIELD
/// =======================
class FormFieldDataText extends FormFieldData {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool disable;
  final String? Function(String?)? validator;

  FormFieldDataText({
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.disable = false,
    this.validator,
  });
}

/// =======================
/// DROPDOWN FIELD
/// =======================
class FormFieldDataDropDown<T> extends FormFieldData {
  final String label;
  final String hintText;
  final Stream<List<T>> stream;
  // final T Function(T) getValue;
  // final String Function(T) getLabel;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  T? selectedValue;

  FormFieldDataDropDown({
    required this.label,
    required this.hintText,
    required this.stream,
    // required this.getValue,
    // required this.getLabel,
    this.onChanged,
    this.validator,
    this.selectedValue,
  });
}