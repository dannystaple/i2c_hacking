#include <Wire.h>

#define MD25 0x58

#define MOTOR1 0
#define MOTOR2 1
#define BATTV  10
#define SWVER  13
#define MODE   15

int ret;

void getMD25Version() {
  Serial.print("Requesting ver. First trans: ");
  Wire.beginTransmission(MD25);
  Wire.send(SWVER);
  ret = Wire.endTransmission();
  Serial.print(ret, DEC);
  Wire.requestFrom(MD25, 1);
  int ver= Wire.receive();
  Serial.print("Got version :");
  Serial.println(ver, DEC);
}


void getMD25BattV() {
  Wire.beginTransmission(MD25);
  Wire.send(BATTV);
  ret = Wire.endTransmission();
  Wire.requestFrom(MD25, 1);
  Serial.print("Got battv :");
  int volts = Wire.receive();
  Serial.println(volts, DEC);
}

//Amount - signed, 7 bit.
void setMDSpeed(int amount) 
{
  Wire.beginTransmission(MD25);
  Wire.send(MOTOR1);
  Wire.send(128 - amount);
  Wire.endTransmission();
  Serial.print("Sent motor1 speed 128-");
  Serial.println(amount, DEC);
}

void setMDTurn(int amount)
{
  Wire.beginTransmission(MD25);
  Wire.send(MOTOR2);
  Wire.send(128 - amount);
  Wire.endTransmission();
  Serial.print("Sent TURN speed 128-");
  Serial.println(amount, DEC);  
}

void setup()
{
  pinMode(13, OUTPUT);
  delay(500);
  // initialize serial communication:
  Serial.begin(9600);
  Wire.begin();//Join the i2c bus
  getMD25Version();
  getMD25BattV();
  //Put the md25 into turn mode, with unsigned values.
  Wire.beginTransmission(MD25);
  Wire.send(MODE);
  Wire.send(2);
  Wire.endTransmission();
  Serial.println("Sent mode 2");
  setMDSpeed(40);
  delay(2020);
  setMDTurn(30);
  delay(2020);
  setMDSpeed(40);
  delay(2020);
  setMDTurn(-30);
}

void loop()
{
  delay(100);
/*  if (Serial.available() > 0) {
    int val = Serial.read();
    if(val == 0x0f) {
      Wire.beginTransmission(MD25);
      Wire.send(MOTOR1);
      Wire.send(128 - 40);
      Wire.endTransmission();
    }
    if(val == 0x0b) {
      Wire.beginTransmission(MD25);
      Wire.send(MOTOR1);
      Wire.send(128 + 40);
      Wire.endTransmission();
    }
  }*/
}

