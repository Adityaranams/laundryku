import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/order.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  String _selectedService = 'Cuci Kering';

  void _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      final newOrder = Order(
        name: _nameController.text,
        serviceType: _selectedService,
        weight: double.parse(_weightController.text),
        date: DateTime.now().toIso8601String(),
      );

      await DatabaseHelper.instance.insertOrder(newOrder);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil disimpan')),
      );

      _nameController.clear();
      _weightController.clear();
      setState(() {
        _selectedService = 'Cuci Kering';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'Form Pemesanan',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
              validator: (value) =>
                  value!.isEmpty ? 'Nama tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedService,
              items: const [
                DropdownMenuItem(value: 'Cuci Kering', child: Text('Cuci Kering')),
                DropdownMenuItem(value: 'Cuci Setrika', child: Text('Cuci Setrika')),
                DropdownMenuItem(value: 'Setrika Saja', child: Text('Setrika Saja')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedService = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Jenis Layanan'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Berat (kg)'),
              validator: (value) =>
                  value!.isEmpty ? 'Berat harus diisi' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitOrder,
              child: const Text('Kirim Pesanan'),
            )
          ],
        ),
      ),
    );
  }
}
