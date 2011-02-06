#include <Wire.h>

#define US_ADDR 0x2

int ret = 0;

void setup() {
  Serial.begin(9600);
  Wire.begin();
  Serial.println("Starting wire");
  delay(500);
  for(int addr=0; addr<128; addr++) {
    Serial.print("Using address: ");
    Serial.println(addr, DEC);
    Wire.beginTransmission(addr);
    Wire.send(0);
    ret = Wire.endTransmission();
    Serial.print("Status :");
    Serial.println(ret, DEC);
    if(ret != 2) {
      addr = 255;
    }
  }
  Serial.println("Done");
/*  int ver = Wire.receive();
  Serial.print("Got version:");
  Serial.println(ver, DEC);*/
}

void loop() {
}
