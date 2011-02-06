#include <Wire.h>

#define MD25 0xb0
void setup()
{
  // initialize serial communication:
  Serial.begin(9600);
  Wire.begin();//Join the i2c bus
  //Put the md25 into turn mode, with unsigned values.
  Wire.beginTransmission(MD25);
  Wire.send(15);
  Wire.send(2);
  Wire.endTransmission();
  Wire.beginTransmission(MD25);
  Wire.send(11);
  Wire.send(128 - 40);
  Wire.endTransmission();
}

void loop()
{
  if (Serial.available() > 0) {
    int val = Serial.read();
    if(val == 0x0f) {
      Wire.beginTransmission(MD25);
      Wire.send(11);
      Wire.send(128 - 40);
      Wire.endTransmission();
    }
    if(val == 0x0b) {
      Wire.beginTransmission(MD25);
      Wire.send(11);
      Wire.send(128 + 40);
      Wire.endTransmission();
    }
  }
}

