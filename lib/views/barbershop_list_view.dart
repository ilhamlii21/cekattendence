import 'package:flutter/material.dart';
import '../controllers/barbershop_controller.dart';

class BarbershopListView extends StatefulWidget {
  const BarbershopListView({Key? key}) : super(key: key);

  @override
  State<BarbershopListView> createState() => _BarbershopListViewState();
}

class _BarbershopListViewState extends State<BarbershopListView> {
  final BarbershopController _controller = BarbershopController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
    // Auto-fetch saat halaman dibuka (token sudah di secure storage)
    _controller.fetchBarbershops();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Barbershop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _controller.fetchBarbershops();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            if (_controller.message.isNotEmpty)
              Text(
                _controller.message,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _controller.message.contains('❌') ? Colors.red : Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 16),
            Expanded(
              child: _controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _controller.barbershops.length,
                      itemBuilder: (context, index) {
                        final shop = _controller.barbershops[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              child: Icon(Icons.store, color: Colors.white),
                            ),
                            title: Text(
                              shop.name.isNotEmpty ? shop.name : 'Tanpa Nama',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(shop.address.isNotEmpty ? shop.address : 'Alamat tidak tersedia'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
