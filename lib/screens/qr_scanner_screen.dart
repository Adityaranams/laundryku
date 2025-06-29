import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String? scannedData;
  bool isScanned = false;

  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: controller,
              onDetect: (BarcodeCapture barcodeCapture) {
                final Barcode? barcode = barcodeCapture.barcodes.first;
                final String? code = barcode?.rawValue;

                if (code != null && !isScanned) {
                  setState(() {
                    scannedData = code;
                    isScanned = true;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('QR Detected: $code')),
                  );
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: scannedData != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Hasil Scan:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          scannedData!,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        if (Uri.tryParse(scannedData!)?.hasAbsolutePath ?? false)
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Link Terdeteksi"),
                                  content: Text("URL: $scannedData"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Tutup"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text("Lihat Link"),
                          ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              scannedData = null;
                              isScanned = false;
                            });
                            controller.start();
                          },
                          child: const Text("Scan Ulang"),
                        ),
                      ],
                    )
                  : const Text(
                      'Arahkan kamera ke QR Code',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
