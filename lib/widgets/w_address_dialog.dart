import 'package:flutter/material.dart';
import 'package:otlop_1/AppStyle.dart';
import 'package:otlop_1/models/address_model.dart';

class AddressDialogWidget extends StatefulWidget {
  final AddressModel? initialAddress;
  final ValueChanged<AddressModel> onSave;

  const AddressDialogWidget({
    super.key,
    this.initialAddress,
    required this.onSave,
  });

  @override
  State<AddressDialogWidget> createState() => _AddressDialogWidgetState();
}

class _AddressDialogWidgetState extends State<AddressDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.initialAddress?.firstName ?? "");
    _lastNameController = TextEditingController(text: widget.initialAddress?.lastName ?? "");
    _streetController = TextEditingController(text: widget.initialAddress?.street ?? "");
    _cityController = TextEditingController(text: widget.initialAddress?.city ?? "Cairo");
    _countryController = TextEditingController(text: widget.initialAddress?.country ?? "Egypt");
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Delivery Address",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField("First Name", _firstNameController),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField("Last Name", _lastNameController),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField("Street Address", _streetController),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField("City", _cityController),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField("Country", _countryController),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appstyle.MainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final address = AddressModel(
                          firstName: _firstNameController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                          street: _streetController.text.trim(),
                          city: _cityController.text.trim(),
                          country: _countryController.text.trim(),
                        );
                        widget.onSave(address);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      "Save Address",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (val) => val == null || val.trim().isEmpty ? "Required" : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
