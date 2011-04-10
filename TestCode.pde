#include <Servo.h>

Servo servo;
int servoPin = 9;
double startTime = 0;
double finishTime = 0;
int thousands, hundreds, tens, ones, buflen;
int finalSpeed, reverseFinalSpeed;
double reverseStartTime;
char ch;
int nextnum = 1;

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
    ch = Serial.peek();
    
    switch(ch) {
      case -1:
        break;
        
      case '+':
        Serial.print("Rewinding...");
        reverseFinalSpeed = 1500 + 1500 - finalSpeed;
        reverseStartTime = millis();
        while ( millis() - reverseStartTime < finishTime ) {
          servo.writeMicroseconds(reverseFinalSpeed);
        }
        servo.writeMicroseconds(1500);
        Serial.println("Complete!");
        Serial.flush();
        break;
        
      case '-':
        servo.writeMicroseconds(1500);
        Serial.print("Taper finished. Time elapsed in ms: ");
        finishTime = millis() - startTime;
        Serial.println(finishTime);
        Serial.flush();
        Serial.println("Press + to rewind");
        break;
        
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
      case '0':
        switch(nextnum) {
          case 1:
            thousands = Serial.read() - 48;
            Serial.print(thousands);
            nextnum = 2;
            break;
            
          case 2:
            hundreds = Serial.read() - 48;
            Serial.print(hundreds);
            nextnum = 3;
            break;
            
          case 3:
            tens = Serial.read() - 48;
            Serial.print(tens);
            nextnum = 4;
            break;
            
          case 4:
            ones = Serial.read() - 48;
            Serial.print(ones);
            nextnum = 1;
            finalSpeed = thousands*1000 + hundreds*100 + tens*10 + ones;
            Serial.println(" -- Speed set, beginning taper. Press - to stop.");
            servo.writeMicroseconds(finalSpeed);
            startTime = millis();
            break;
            
          default:
            break;
        }
        break;
      
      default:
        Serial.println("Invalid character!");
        Serial.flush();
        break;
    }
  }
}

