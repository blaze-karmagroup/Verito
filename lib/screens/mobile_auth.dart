import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verito/screens/home_screen.dart';

class AuthMobile extends StatefulWidget {
  const AuthMobile({super.key});

  @override
  State<AuthMobile> createState() => _AuthMobileState();
}

class _AuthMobileState extends State<AuthMobile> {
  final TextEditingController _mobileController = TextEditingController();

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void showOtpDialog() {
    final focusNodes = List.generate(4, (_) => FocusNode());
    final controllers = List.generate(4, (_) => TextEditingController());

    void disposeControllers() {
      for (var controller in controllers) {
        controller.dispose();
      }
      for (var node in focusNodes) {
        node.dispose();
      }
    }

    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            String errorMessage = '';
            bool isResending = false;
            int resendTimer = 30;

            void _onOtpChanged(String value, int index) {
              setState(() {
                errorMessage = '';
              });
              if (value.isNotEmpty && index < 3) {
                FocusScope.of(context).requestFocus(focusNodes[index + 1]);
              }
              if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(focusNodes[index - 1]);
              }
            }

            void _verifyOtp() {
              final otp = controllers.map((c) => c.text).join();
              print('OTP: $otp');
              if (otp.length != 4) {
                setState(() {
                  errorMessage = 'Please enter the 4-digit OTP.';
                });
                return;
              }
              // --- TODO: Replace with your actual OTP verification logic ---
              if (otp != "1234") {
                setState(() {
                  errorMessage = 'Invalid OTP. Please try again.';
                  print('Invalid OTP. Please try again.');
                  _showErrorSnackBar(errorMessage);
                });
              } else {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  this.context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(title: "Auth"),
                  ),
                );
                _showSuccessSnackBar('OTP Verified Successfully!');
              }
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Color(0xFFF8F0E3),
              title: Center(
                child: Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'A 4-digit code has been sent to your number.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: 48,
                          child: TextFormField(
                            controller: controllers[index],
                            focusNode: focusNodes[index],
                            onChanged: (value) => _onOtpChanged(value, index),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.teal.shade700,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 12),
                    //   child: (errorMessage.isNotEmpty)
                    //       ? Text(
                    //           errorMessage,
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //             color: Colors.red.shade700,
                    //             fontSize: 12,
                    //           ),
                    //         )
                    //       : const SizedBox.shrink(),
                    // ),
                    if (errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive code? ",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            // TODO: Add resend logic
                            print("Resend OTP tapped");
                          },
                          child: Text(
                            "Resend OTP",
                            style: TextStyle(
                              color: Colors.teal.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: EdgeInsets.fromLTRB(24, 0, 24, 24),
              actions: [
                ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _sendOtp() {
    final String mobileNumber = _mobileController.text;
    print("OTP Sent to $mobileNumber");

    if (mobileNumber == null ||
        mobileNumber.isEmpty ||
        mobileNumber.length != 10) {
      _showErrorSnackBar('Please enter a valid 10-digit mobile number');
    } else {
      showOtpDialog();
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage(title: "Auth")),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade100, Color(0xFFF8F0E3)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Icon(Icons.fingerprint, size: 60, color: Colors.teal.shade700),
              Image.asset('assets/images/karma_logo.png'),

              // const SizedBox(height: 20),
              const Text(
                'Welcome to Karma Verito',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023C3C),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your mobile number to continue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 40),

              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  hintText: 'e.g. 9876543210',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: Colors.teal.shade200,
                ),
                child: const Text(
                  'Send OTP',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
