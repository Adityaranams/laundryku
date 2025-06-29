import 'package:flutter/material.dart';
import '../models/order.dart';
import '../db/database_helper.dart';

class EditOrderScreen extends StatefulWidget {
  final Order order;
  const EditOrderScreen({super.key, required this.order});

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _serviceController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.order.name);
    _serviceController = TextEditingController(text: widget.order.serviceType);
    _weightController = TextEditingController(text: widget.order.weight.toString());
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedOrder = Order(
        id: widget.order.id,
        name: _nameController.text,
        serviceType: _serviceController.text,
        weight: double.tryParse(_weightController.text) ?? 0.0,
        date: widget.order.date, // atau DateTime.now().toIso8601String()
      );

      await DatabaseHelper.instance.updateOrder(updatedOrder);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pesanan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _serviceController,
                decoration: const InputDecoration(labelText: 'Jenis Layanan'),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Berat (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  final num = double.tryParse(value);
                  if (num == null || num <= 0) return 'Masukkan angka yang valid';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
