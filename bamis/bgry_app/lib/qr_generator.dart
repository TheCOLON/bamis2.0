import 'package:bgry_app/api_response.dart';
import 'package:bgry_app/attendanceForm.dart';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:http/http.dart' as http;

class QrCodeGen extends StatefulWidget {
  const QrCodeGen({super.key});

  @override
  _QrCodeGenState createState() => _QrCodeGenState();
}

class _QrCodeGenState extends State<QrCodeGen> {
  final _formKey = GlobalKey<FormState>();
  String _qrCodeValue = '';

  Future<void> saveQRCode(String qrCodeValue) async {
    try {
      final Map<String, dynamic> data = {
        'qr_code_value': qrCodeValue,
      };

      final response = await CallApi().postData(data, 'saveQRCode');

      if (response.statusCode == 201) {
        // QR code saved successfully
        print('QR code saved successfully');
      } else {
        // Handle the error
        print('Failed to save QR code');
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AttendanceForm()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('QR Code Generator',
            style: TextStyle(
              fontSize: 35,
            )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Resident ID',
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a Resident ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _qrCodeValue = value!;
                  });
                },
              ),
              const SizedBox(height: 30.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'QR Code Value',
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a QR code value';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _qrCodeValue = value!;
                  });
                },
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    saveQRCode(
                        _qrCodeValue); // Pass the QR code value to the function
                  }
                },
                child: const Text('Generate QR Code',
                    style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 30.0),
              if (_qrCodeValue.isNotEmpty)
                BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: _qrCodeValue,
                  width: 200.0,
                  height: 200.0, // Increase the height for QR codes
                ),
            ],
          ),
        ),
      ),
    );
  }
}
