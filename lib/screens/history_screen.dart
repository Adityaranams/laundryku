import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/order.dart';
import 'edit_order_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final orders = await DatabaseHelper.instance.getOrders();
    setState(() {
      _orders = orders;
    });
  }

  Future<void> _deleteOrder(int id) async {
    await DatabaseHelper.instance.deleteOrder(id);
    _loadOrders();

    // 🔔 Tampilkan notifikasi setelah hapus
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil dihapus')),
      );
    }
  }

  void _editOrder(Order order) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditOrderScreen(order: order),
      ),
    );
    _loadOrders();

    // Tampilkan notifikasi setelah edit
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil diperbarui')),
      );
    }
  }

  Future<void> _confirmDelete(Order order) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin menghapus pesanan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _deleteOrder(order.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Pesanan")),
      body: _orders.isEmpty
          ? const Center(child: Text('Belum ada pesanan.'))
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(order.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${order.serviceType} - ${order.weight} kg'),
                        Text(order.date),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editOrder(order),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(order),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
