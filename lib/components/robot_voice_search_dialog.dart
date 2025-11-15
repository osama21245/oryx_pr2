import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../extensions/decorations.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import '../main.dart';
import '../extensions/common.dart';

class RobotVoiceSearchDialog extends StatefulWidget {
  final Function(String)? onTextRecognized;
  final Function()? onCancel;

  const RobotVoiceSearchDialog({
    super.key,
    this.onTextRecognized,
    this.onCancel,
  });

  @override
  State<RobotVoiceSearchDialog> createState() => _RobotVoiceSearchDialogState();
}

class _RobotVoiceSearchDialogState extends State<RobotVoiceSearchDialog>
    with TickerProviderStateMixin {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = '';
  String _statusText = 'Tap to start talking...';

  late AnimationController _simplePulseController;
  late Animation<double> _simplePulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeSpeech();
  }

  void _initializeAnimations() {
    // Simple, lightweight pulse animation
    _simplePulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _simplePulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _simplePulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (mounted) {
          setState(() {
            _isListening = status == 'listening';
            if (status == 'listening') {
              _statusText = 'Listening... Speak now';
            } else if (status == 'done') {
              _statusText = 'Processing...';
            }
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isListening = false;
            _statusText = 'Error: ${error.errorMsg}';
          });
        }
      },
    );

    if (!available && mounted) {
      setState(() {
        _statusText = 'Speech recognition not available';
      });
    }
  }

  Future<void> _startListening() async {
    if (!_speech.isAvailable) {
      toast('Speech recognition is not available');
      return;
    }

    if (mounted) {
      setState(() {
        _isListening = true;
        _recognizedText = '';
        _statusText = 'Listening... Speak now';
      });
    }

    await _speech.listen(
      onResult: (result) {
        if (mounted) {
          setState(() {
            _recognizedText = result.recognizedWords;
            if (result.recognizedWords.isNotEmpty) {
              _statusText = 'I heard: ${result.recognizedWords}';
            }
          });

          if (result.finalResult) {
            _stopListening();
            if (result.recognizedWords.isNotEmpty) {
              // Wait a bit for visual feedback, then return the text
              Future.delayed(Duration(milliseconds: 500), () {
                if (mounted) {
                  widget.onTextRecognized?.call(result.recognizedWords);
                  Navigator.of(context).pop();
                }
              });
            } else {
              _stopListening();
            }
          }
        }
      },
      listenFor: Duration(seconds: 30),
      pauseFor: Duration(seconds: 3),
      localeId: 'ar_EG',
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    if (mounted) {
      setState(() {
        _isListening = false;
        if (_recognizedText.isEmpty) {
          _statusText = 'Tap to start talking...';
        }
      });
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _simplePulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              appStore.isDarkModeOn ? Colors.black87 : Colors.white,
              appStore.isDarkModeOn ? Colors.black : Colors.grey.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: primaryColor, size: 30),
                  onPressed: () {
                    _stopListening();
                    widget.onCancel?.call();
                    Navigator.of(context).pop();
                  },
                ).paddingAll(16),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo with simple pulse animation - using rounded square instead of circle
                    AnimatedBuilder(
                      animation: _simplePulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale:
                              _isListening ? _simplePulseAnimation.value : 1.0,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: primaryColor.withOpacity(0.1),
                              boxShadow: _isListening
                                  ? [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.2),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                app_logo,
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    40.height,

                    // Status text
                    Text(
                      _statusText,
                      style: boldTextStyle(
                        size: 18,
                        color: appStore.isDarkModeOn
                            ? Colors.white
                            : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ).paddingSymmetric(horizontal: 32),

                    20.height,

                    // Recognized text display
                    if (_recognizedText.isNotEmpty)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 32),
                        padding: EdgeInsets.all(16),
                        decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: appStore.isDarkModeOn
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                          borderRadius: radius(12),
                        ),
                        child: Text(
                          _recognizedText,
                          style: primaryTextStyle(
                            size: 16,
                            color: appStore.isDarkModeOn
                                ? Colors.white
                                : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    40.height,

                    // Simple listening indicator
                    if (_isListening)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                          ),
                          8.width,
                          Text(
                            'Listening...',
                            style: secondaryTextStyle(
                              color: primaryColor,
                              size: 14,
                            ),
                          ),
                        ],
                      ),

                    60.height,

                    // Action button
                    GestureDetector(
                      onTap: _isListening ? _stopListening : _startListening,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isListening ? Colors.red : primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: (_isListening ? Colors.red : primaryColor)
                                  .withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isListening ? Icons.stop : Icons.mic,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),

                    20.height,

                    Text(
                      _isListening ? 'Tap to stop' : 'Tap to talk',
                      style: secondaryTextStyle(
                        color: appStore.isDarkModeOn
                            ? Colors.grey
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
