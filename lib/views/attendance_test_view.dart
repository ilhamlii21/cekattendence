import 'package:flutter/material.dart';
import '../controllers/attendance_controller.dart';
import '../controllers/auth_controller.dart';
import 'login_view.dart';
import 'qr_scanner_view.dart';

class AttendanceTestView extends StatefulWidget {
  const AttendanceTestView({Key? key}) : super(key: key);

  @override
  State<AttendanceTestView> createState() => _AttendanceTestViewState();
}

class _AttendanceTestViewState extends State<AttendanceTestView> {
  final AttendanceController _controller = AttendanceController();
  final TextEditingController _qrTokenController = TextEditingController(text: 'dummy-qr-token');

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _qrTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await AuthController().logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginView()),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Masukkan QR Token (Hasil scan):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _qrTokenController,
                    decoration: const InputDecoration(
                      hintText: 'QR Token string',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    final scannedQr = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QrScannerView(),
                      ),
                    );
                    if (scannedQr != null && scannedQr is String) {
                      _qrTokenController.text = scannedQr;
                    }
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (_controller.isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              ElevatedButton.icon(
                onPressed: () {
                  double dummyLat = -6.973000;
                  double dummyLon = 107.630000;
                  _controller.performCheckIn(_qrTokenController.text, dummyLat, dummyLon);
                },
                icon: const Icon(Icons.login),
                label: const Text('Test Check-In'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _controller.performCheckOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Test Check-Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _controller.message.isEmpty ? 'Status akan muncul di sini' : _controller.message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _controller.message.contains('❌') ? Colors.red : Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
