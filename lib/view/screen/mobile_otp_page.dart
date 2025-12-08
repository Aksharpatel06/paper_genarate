import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paper_genarate_app/view/screen/category_page.dart';

import '../../utils/color.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController(text: '+91');

  bool _isOtpSent = false;
  bool _isLoading = false;
  String _verificationId = '';
  String? _errorMessage;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _resendToken = 0;
  int _countdown = 60;
  bool _canResend = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: AppBar(
        backgroundColor: CustomColors.blueColor,
        title: Text(_isOtpSent ? 'Verify OTP' : 'Enter Mobile Number', style: TextStyle(color: CustomColors.whiteColor)),
        elevation: 0,
        iconTheme: IconThemeData(color: CustomColors.whiteColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [if (!_isOtpSent) _buildPhoneInputSection(), if (_isOtpSent) _buildOtpInputSection()],
        ),
      ),
    );
  }

  Widget _buildPhoneInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your mobile number',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 8),
        Text('We will send you a verification code', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        SizedBox(height: 30),

        // Country Code and Phone Number
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              // Country Code
              Container(
                width: 80,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _countryCodeController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(hintText: '+91', border: InputBorder.none, isDense: true),
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(height: 30, width: 1, color: Colors.grey[300]),
              // Phone Number
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter mobile number',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),

        if (_errorMessage != null) ...[SizedBox(height: 16), Text(_errorMessage!, style: TextStyle(color: Colors.red, fontSize: 14))],

        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _sendOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.blueColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(CustomColors.whiteColor)),
                  )
                : Text(
                    'Send OTP',
                    style: TextStyle(color: CustomColors.whiteColor, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter OTP',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 8),
        Text(
          'Enter the 6-digit code sent to ${_countryCodeController.text}${_phoneController.text}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        SizedBox(height: 30),

        // OTP Input Field
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: 'Enter 6-digit OTP',
              border: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 8),
          ),
        ),

        if (_errorMessage != null) ...[SizedBox(height: 16), Text(_errorMessage!, style: TextStyle(color: Colors.red, fontSize: 14))],

        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _canResend ? _resendOtp : null,
              child: Text(
                _canResend ? 'Resend OTP' : 'Resend in $_countdown',
                style: TextStyle(color: _canResend ? CustomColors.blueColor : Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() {
                        _isOtpSent = false;
                        _errorMessage = null;
                        _otpController.clear();
                      });
                    },
              child: Text('Change Number', style: TextStyle(color: Colors.grey[600])),
            ),
          ],
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _verifyOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.blueColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(CustomColors.whiteColor)),
                  )
                : Text(
                    'Verify OTP',
                    style: TextStyle(color: CustomColors.whiteColor, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _sendOtp() async {
    if (_phoneController.text.length < 10) {
      setState(() {
        _errorMessage = 'Please enter a valid 10-digit mobile number';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String fullPhoneNumber = '${_countryCodeController.text}${_phoneController.text}';

      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification on Android devices
          await _auth.signInWithCredential(credential);
          _showSuccessAndNavigate();
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _errorMessage = _getErrorMessage(e.code);
            _isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _resendToken = resendToken ?? 0;
            _isOtpSent = true;
            _isLoading = false;
            _countdown = 60;
            _canResend = false;
            _startTimer();
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP sent successfully!'), backgroundColor: CustomColors.blueColor));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timeout
        },
        timeout: Duration(seconds: 60),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to send OTP. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a valid 6-digit OTP';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: _otpController.text);

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        _showSuccessAndNavigate();
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e.code);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Verification failed. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _canResend = false;
      _countdown = 60;
    });

    try {
      String fullPhoneNumber = '${_countryCodeController.text}${_phoneController.text}';

      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          _showSuccessAndNavigate();
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _errorMessage = _getErrorMessage(e.code);
            _isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _resendToken = resendToken ?? 0;
            _isLoading = false;
            _countdown = 60;
            _canResend = false;
            _startTimer();
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP resent successfully!'), backgroundColor: CustomColors.blueColor));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: Duration(seconds: 60),
        forceResendingToken: _resendToken,
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to resend OTP. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _showSuccessAndNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Phone number verified successfully!'), backgroundColor: Colors.green));

    // Navigate to next screen
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CategoryPage()));
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-phone-number':
        return 'Invalid phone number format';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later';
      case 'session-expired':
        return 'OTP session expired. Please request a new OTP';
      case 'invalid-verification-code':
        return 'Invalid OTP. Please check and try again';
      case 'user-disabled':
        return 'This account has been disabled';
      default:
        return 'An error occurred. Please try again';
    }
  }
}
