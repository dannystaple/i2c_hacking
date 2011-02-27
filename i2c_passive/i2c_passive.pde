
//inputs
const int clockPin = 2;
const int dataPin = 3;
const int clockInt = 0;
const int dateInt = 1;

int clockState;
int dataState;

void handleClockInt() {
  int newClockState = !clockState;
  clockState = newClockState;
}

void handleDataInt() {
  int newDataState = !dataState;
  if(clockState) {// Clock high
    //Low to high
    if(!dataState && newDataState) {
      Serial.println("Seen stop");
    }
    if(dataState && !newDataState) {
      Serial.println("Seen start");
    }
  }
  dataState = newDataState;
}

void setup() {
  Serial.begin(9600);
  pinMode(clockPin, INPUT);
  pinMode(dataPin, INPUT);
  Serial.println("Starting monitor");
  clockState = digitalRead(clockPin);
  dataState = digitalRead(dataPin);  
  attachInterrupt(clockInt, handleClockInt, CHANGE);
  attachInterrupt(dataInt, handleDataInt, CHANGE);
}

