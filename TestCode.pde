#include <Servo.h>

Servo servo;
int servoPin = 9;
double startTime = 0;
double finishTime = 0;
int thousands, hundreds, tens, ones;
int finalSpeed, reverseFinalSpeed;
double reverseStartTime;

void setup() {
  servo.attach(servoPin);  

  Serial.begin(9600);
  Serial.println("Ready.");
  Serial.println("Welcome to die.");
  Serial.println("Enter a PWM length to execute");
  Serial.println("Use the - key to halt and print time data");
}

void loop() {

  if ( Serial.available() ) {
    char ch = Serial.peek();
    
    switch(ch) {
        
        case '+':
          Serial.println("Rewinding...");
          reverseFinalSpeed = 1500 + 1500 - finalSpeed;
          reverseStartTime = millis();
          while ( millis() - reverseStartTime < finishTime ) {
            servo.writeMicroseconds(reverseFinalSpeed);
          }
          servo.writeMicroseconds(1500);
          Serial.flush();
          break;
          
	case '-':
	  servo.writeMicroseconds(1500);
          Serial.println("Servo Stopped. Time elapsed in ms:");
          finishTime = millis() - startTime;
          Serial.println(finishTime);
          Serial.flush();
          Serial.println("Press + to rewind");
	  break;

        default:
          if ( Serial.available() >= 4 ) {
            thousands = Serial.read() - 48;
            hundreds = Serial.read() - 48;
            tens = Serial.read() - 48;
            ones = Serial.read() - 48;
            finalSpeed = thousands*1000 + hundreds*100 + tens*10 + ones;
            Serial.println(finalSpeed);
            servo.writeMicroseconds(finalSpeed);
            startTime = millis();
            
          }
          break;
    }
  }
}  
