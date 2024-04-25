import 'dart:math';

import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OTPVerificationScreen(),
    );
  }
}

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({Key? key}) : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State
{
  late TextEditingController _controllerPhoneNumber, _controllerOTP;
  String? _message;
  Telephony telephony = Telephony.instance;
  String _generatedOTP = '';

  @override
  void initState() {
    super.initState();
    _controllerPhoneNumber = TextEditingController();
    _controllerOTP = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificación OTP y SMS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controllerPhoneNumber,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Ingresar número de teléfono',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _controllerOTP,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ingresar OTP',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _sendOTP,
              child: const Text('Enviar OTP'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _verifyOTP,
              child: const Text('Verificar OTP'),
            ),
            const SizedBox(height: 16.0),
            if (_message != null)
              Text(
                _message!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendOTP() async {
    String phoneNumber = _controllerPhoneNumber.text;
    _generatedOTP = _generateOTP(6);
    String responseMessage = await _sendOTPMessage(phoneNumber, _generatedOTP);

    setState(() {
      _message = responseMessage;
    });
  }

  Future<void> _verifyOTP() async {
    String enteredOTP = _controllerOTP.text;

    if (enteredOTP == _generatedOTP) {
      setState(() {
        _message = 'OTP verificado con éxito!';
      });
    } else {
      setState(() {
        _message = 'OTP Incorrecto. Ingrese nuevamente.';
      });
    }
  }

  Future<String> _sendOTPMessage(String phoneNumber, String otp) async {
    try {
      await telephony.sendSms(
        to: phoneNumber,
        message: "Tu OTP es: $otp",
      );

      return 'OTP enviado correctamente!';
    } catch (error) {
      print('Error al enviar OTP: $error');
      throw 'Error al enviar OTP: $error';
    }
  }

  String _generateOTP(int length) {
    const chars = '0123456789';
    final random = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}