#include <Wire.h>

#define ADDR24c02 0x50

int ret = 0;

void setup() {
  Serial.begin(9600);
  Wire.begin();
  Serial.println("Starting wire");
  delay(500);

  Serial.print("Using address: ");
  Serial.println(ADDR24c02, DEC);
  Wire.beginTransmission(ADDR24c02);
  Wire.send(0);
  ret = Wire.endTransmission();
  Serial.print("Status :");
  Serial.println(ret, DEC);
  //Start reading bytes
  Serial.print("Got '");
  Wire.requestFrom(ADDR24c02, 8);
  while(Wire.available() > 0) {
    Serial.print(Wire.receive());
  }
  Serial.println("'");
}

void loop() {
}
