import 'dart:async';

int otpCooldownSeconds = 0;
Timer? otpTimer;

void startOtpCooldown(int seconds) {
  otpCooldownSeconds = seconds;
  otpTimer?.cancel();
  otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    otpCooldownSeconds--;
    if (otpCooldownSeconds <= 0) {
      timer.cancel();
    }
  });
}
