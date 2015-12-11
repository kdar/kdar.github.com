// Code from http://www.arduino.cc/playground/Code/PIRsense
// Modifed by Kevin Darlington for an Airwick Freshmatic PIR.

//the time we give the sensor to calibrate (10-60 secs according to the datasheet)
int calibrationTime = 30; 

//the time when the sensor outputs a low impulse
long unsigned int lowIn;

//the amount of milliseconds the sensor has to be low
//before we assume all motion has stopped
long unsigned int pause = 1000;

// The threshold. The sensor value has to go under this
// for motion to be present.
int threshold = 100;

boolean lockLow = true;
boolean takeLowTime;

int pirPin = 0; // analog pin 0
int ledPin = 12;

void setup()
{
  Serial.begin(9600);

  // This doesn't seem to make a bit of difference. But it's
  // here anyways.
  Serial.print("calibrating sensor ");
  for (int i = 0; i < calibrationTime; i++) {
    Serial.print(".");
    delay(1000);
  }
  Serial.println(" done");
  Serial.println("SENSOR ACTIVE");
  delay(50);
}

void loop()
{
  if (analogRead(0) < threshold) {
    if (lockLow) {
      // Turn on the LED by setting the pin to OUTPUT and LOW
      pinMode(ledPin, OUTPUT);
      digitalWrite(ledPin, LOW);

      //makes sure we wait for a transition to LOW before any further output is made:
      lockLow = false;
      Serial.println("---");
      Serial.print("motion detected at ");
      Serial.print(millis()/1000);
      Serial.println(" sec");
      delay(50);
    }
    takeLowTime = true;
  }

  if (analogRead(0) > threshold) {

    if (takeLowTime) {
      lowIn = millis();          //save the time of the transition from high to LOW
      takeLowTime = false;       //make sure this is only done at the start of a LOW phase
    }
    //if the sensor is low for more than the given pause,
    //we assume that no more motion is going to happen
    if (!lockLow && millis() - lowIn > pause) {
      // Turn off the LED by setting the pint to INPUT
      pinMode(12, INPUT);

      //makes sure this block of code is only executed again after
      //a new motion sequence has been detected
      lockLow = true;
      Serial.print("motion ended at ");      //output
      Serial.print((millis() - pause)/1000);
      Serial.println(" sec");
      delay(50);
    }
  }
}
