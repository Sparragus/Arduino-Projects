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

final int[] OUTPUT_PORTS =  {2,7};
final int[] INPUT_PORTS = {3,4,5,6};

ArrayList<PVector> connections;

void setup() {
  size(200, 200);
  frameRate(24);
  background(#000000);

  // println(Arduino.list());
  println("Initializing the glove...");
  arduino = new Arduino(this, Arduino.list()[5], 57600);
  delay(1000); // This delay is very important. One second seems sufficient
  println("The glove is ready!");


  for (int i = 0; i < INPUT_PORTS.length; i++) {
    arduino.pinMode(INPUT_PORTS[i], arduino.INPUT);
    arduino.digitalWrite(INPUT_PORTS[i], arduino.HIGH); // Turn on internal pullup resistor. Inverts input logic.
  }

  for (int i = 0; i < OUTPUT_PORTS.length; i++) {
    arduino.pinMode(OUTPUT_PORTS[i], arduino.OUTPUT);
    arduino.digitalWrite(OUTPUT_PORTS[i], arduino.HIGH); // Default is HIGH.
  }

  // This is the graph of connections.
  connections = new ArrayList<PVector>();

  noLoop();
}

void draw() {
  connections = detectConnections();
  println("Connections: ");
  for (PVector v : connections) {
    println("Finger "+v.x+" and " +v.y+ " are connected.");
  }
}

ArrayList<PVector> detectConnections() {

  // Connections graph.
  ArrayList<PVector> _connections = new ArrayList<PVector>();

  // Detect connections
  for (int out = 0; out < OUTPUT_PORTS.length; ++out) {
    arduino.digitalWrite(OUTPUT_PORTS[out], arduino.LOW);
    delay(10); // If the glove doesn't word properly, try making the delay longer

    for (int in = 0; in < INPUT_PORTS.length; ++in) {
      if( arduino.digitalRead(INPUT_PORTS[in]) == arduino.LOW) {
        _connections.add(new PVector(OUTPUT_PORTS[out], INPUT_PORTS[in]));
      }
    }
    arduino.digitalWrite(OUTPUT_PORTS[out], arduino.HIGH);
    delay(10); // If the glove doesn't word properly, try making the delay longer
  }

  return _connections;
}

void keyPressed() {
  switch (key) {
    case ' ':
      connections = detectConnections();
      println("Connections: ");
      for (PVector v : connections) {
        println("Finger "+v.x+" and " +v.y+ " are connected.");
      }
      break;
  }
}