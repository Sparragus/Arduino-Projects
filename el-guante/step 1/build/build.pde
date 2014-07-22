/*
//  Author: Richard B. Kaufman-López <richardbkaufman@gmail.com>
//  Date: 2014-07-22
//
//  Project: El Guante
//  Description: 
*/

import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

void setup() {
  size(200, 200);
  frameRate(60);
  background(#000000);

  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[5], 57600);

  // a traves de un for establece los 13 pins digitales como entradas
  // for (int i = 0; i <= 13; i++) {
  //   arduino.pinMode(i, Arduino.INPUT);
  // }

  arduino.pinMode(7,Arduino.OUTPUT);

  arduino.pinMode(8,Arduino.INPUT);
  arduino.digitalWrite(8, Arduino.HIGH); // Turn on pull-up resistor. Inverts input logic.
}

void draw() {
  arduino.digitalWrite(7, arduino.LOW);

  if(arduino.digitalRead(8) == arduino.LOW) {
    background(248);
  }
  else {
    background(#000000);
  }
  // arduino.digitalWrite(7, arduino.LOW);

}