
#include <Servo.h>
#include <SoftwareSerial.h>

Servo servo;
SoftwareSerial BT(10, 11); // RX, TX

void setup() {
  servo.attach(9);
  BT.begin(9600);
}

void loop() {
  if (BT.available()) {
    char c = BT.read();
    if (c == 'A')      servo.write(90);
    else if (c == 'F') servo.write(0);
  }
}