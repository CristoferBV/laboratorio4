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

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  late TextEditingController _controllerPhoneNumber, _controllerOTP;
  String? _message;
  Telephony telephony = Telephony.instance;

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
        title: const Text('OTP Verification'),
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
                labelText: 'Enter Phone Number',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _controllerOTP,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter SMS',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _verifyOTP,
              child: const Text('Verify OTP'),
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

  Future<void> _verifyOTP() async {
    String phoneNumber = _controllerPhoneNumber.text;
    String enteredOTP = _controllerOTP.text;

    // Enviar el OTP al número de teléfono especificado
    String responseMessage = await _sendOTP(phoneNumber, enteredOTP);

    setState(() {
      _message = responseMessage;
    });
  }

    Future<String> _sendOTP(String phoneNumber, String otp) async {
    try {
      // Aquí enviarías el OTP al número de teléfono especificado
      // Usando la librería telephony
      await telephony.sendSms(
        to: phoneNumber,
        message: "Your OTP is: $otp",
      );

      // Como telephony.sendSms() no retorna ningún valor,
      // no necesitas asignar nada a _result
      return 'OTP sent successfully!';
    } catch (error) {
      print('Error sending OTP: $error');
      throw 'Error sending OTP: $error';
    }
  }
}
