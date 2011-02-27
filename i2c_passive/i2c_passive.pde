//#include <serial.h>

//inputs
const int clockPin = 11;
const int dataPin = 10;

//outputs
const int ledPin = 13;

int clockState;
int dataState;
void setup() {
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
  pinMode(clockPin, INPUT);
  pinMode(dataPin, INPUT);
  Serial.println("Starting monitor");
  clockState = digitalRead(clockPin);
  dataState = digitalRead(dataPin);
}

void loop() {
  int newClockState = digitalRead(clockPin);
  int newDataState = digitalRead(dataPin);
  if(clockState == HIGH && newClockState == HIGH) {
    if(dataState == HIGH && newDataState == LOW) {
      Serial.println("Seen start");
    }
    if(dataState == LOW && newDataState == HIGH) {
      Serial.println("Seen stop");
    }
  }
  clockState = newClockState;
  dataState = newDataState;
}
