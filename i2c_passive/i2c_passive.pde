#define I2C_NOTRANS 0
#define I2C_DATA 1


//inputs
const int clockPin = 2;
const int dataPin = 3;
const int clockInt = 0;
const int dataInt = 1;

volatile int clockState;
volatile int dataState;

void handleClockInt() {
  int newClockState = !clockState;
  clockState = newClockState;
}

volatile int i2cstate = I2C_NOTRANS;
volatile int dataCount = 0;

void handleDataInt() {
  int newDataState = !dataState;
  if(clockState) {// Clock high
    //Low to high
    if(!dataState && newDataState && i2cstate == I2C_NOTRANS) {
      i2cstate = I2C_DATA;
    }
    if(dataState && !newDataState && i2cstate == I2C_DATA) {
      i2cstate = I2C_NOTRANS;
      dataCount++;
    }
  }
  dataState = newDataState;
}

void setup() {
  Serial.begin(9600);
  pinMode(clockPin, INPUT);
  pinMode(dataPin, INPUT);
  clockState = digitalRead(clockPin);
  dataState = digitalRead(dataPin);  
  delay(500);
  Serial.println("Starting monitor");
  attachInterrupt(clockInt, handleClockInt, CHANGE);
  attachInterrupt(dataInt, handleDataInt, CHANGE);
}

void loop() {
  if(i2cstate == I2C_NOTRANS && dataCount > 0) {
    Serial.print("Seen ");
    Serial.print(dataCount, DEC);
    Serial.println(" transmissions.");
    dataCount = 0;
  }
}
