import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckPhone extends StatefulWidget {
  const CheckPhone({super.key});

  @override
  State<CheckPhone> createState() => _CheckPhoneState();
}

class _CheckPhoneState extends State<CheckPhone> {
  final TextEditingController _phoneController = TextEditingController(
    text: "+213676979671",
  );
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId;
  bool _otpSent = false;
  bool _loading = false;
  String? _statusMsg;

  Future<void> _verifyPhone() async {
    setState(() {
      _loading = true;
      _statusMsg = null;
    });
    await _auth.verifyPhoneNumber(
      phoneNumber: "+213676979671",
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatic handling on Android
        await _auth.signInWithCredential(credential);
        setState(() {
          _loading = false;
          _statusMsg = "Phone number automatically verified.";
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _loading = false;
          _statusMsg = "Verification failed: ${e.message}";
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _otpSent = true;
          _loading = false;
          _statusMsg = "OTP sent. Please check your SMS.";
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
          _loading = false;
        });
      },
    );
  }

  Future<void> _verifyOTP() async {
    if (_verificationId == null) return;
    setState(() {
      _loading = true;
      _statusMsg = null;
    });
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otpController.text.trim(),
      );
      await _auth.signInWithCredential(credential);
      setState(() {
        _loading = false;
        _statusMsg = "Phone number verified successfully!";
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _statusMsg = "Invalid OTP. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_otpSent)
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    prefixText: "",
                    hintText: "+213xxxxxxxxx",
                  ),
                  keyboardType: TextInputType.phone,
                ),
              if (_otpSent)
                TextField(
                  controller: _otpController,
                  decoration: const InputDecoration(
                    labelText: "OTP Code",
                    hintText: "Enter the OTP received",
                  ),
                  keyboardType: TextInputType.number,
                ),
              const SizedBox(height: 20),
              if (_loading) const CircularProgressIndicator(),
              if (!_loading)
                ElevatedButton(
                  onPressed: _otpSent ? _verifyOTP : _verifyPhone,
                  child: Text(_otpSent ? "Verify OTP" : "Send OTP"),
                ),
              if (_statusMsg != null) ...[
                const SizedBox(height: 12),
                Text(
                  _statusMsg!,
                  style: TextStyle(
                    color: _statusMsg!.toLowerCase().contains("fail")
                        ? Colors.red
                        : Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
