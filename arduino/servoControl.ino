#include <Servo.h>

Servo meuServo;

void setup() {
  Serial.begin(9600);  // Usa a serial hardware
  meuServo.attach(9);  // Servo no pino 9
}

void loop() {
  if (Serial.available()) {
    char comando = Serial.read();

    if (comando == 'A') {
      meuServo.write(0);
    } 
    else if (comando == 'F') {
      meuServo.write(90);
    }
  }
}
