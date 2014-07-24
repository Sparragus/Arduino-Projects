/*
//  Author: Richard B. Kaufman-López <richardbkaufman@gmail.com>
//  Date: 2014-07-22
//
//  Project: El Guante
//  Description: 
//
//  License: General Public License version 2
*/

import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

final int[] OUTPUT_PORTS =  {2,7};
final int[] INPUT_PORTS = {3,4,5,6};


ArrayList<PVector> connections;
ArrayList<ArrayList<PVector>> gestures;
int gesture;


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
  createGestures();

}

void draw() {
  connections = detectConnections();
  gesture = detectGesture(connections);

  showGesture(gesture);

  noLoop();
}

void createGestures() {
  gestures = new ArrayList<ArrayList<PVector>>();

  for (int i = 0; i < 11; ++i) {
    gestures.add(new ArrayList<PVector>());
  }

  // Open hand
  gestures.get(0).clear();

  // Index finger touches thumb
  gestures.get(1).add(new PVector(2,3));
  
  // Middle finger touches thumb
  gestures.get(2).add(new PVector(2,4));
  
  // Ring finger touches thumb
  gestures.get(3).add(new PVector(2,5));
  
  // Pinky finger touches thumb
  gestures.get(4).add(new PVector(2,6));

  // TODO: Implement gestures below.

  // Thumb touches back of middle finger
  gestures.get(5).clear();

  // Thumb touches back of ring finger
  gestures.get(6).clear();

  // Thumb touches back of middle finger
  gestures.get(7).clear();

  // Non-thumb fingers are closed touching palm. 
  // Thumb is open.
  gestures.get(8).add(new PVector(7,3));
  gestures.get(8).add(new PVector(7,4));
  gestures.get(8).add(new PVector(7,5));
  gestures.get(8).add(new PVector(7,6));

  // Non-thumb fingers (except index) are closed touching the palm. 
  // Thumb and index are open.
  gestures.get(9).clear();

  // Thumb is touching index on the inner-side contact.
  gestures.get(10).clear();


}

int detectGesture(ArrayList<PVector> _connections) {

  for (ArrayList<PVector> _gesture : gestures) {
    if( connections.equals(_gesture)) {
      return gestures.indexOf(_gesture);
    }
  }

  return -1;
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

// DEBUGGING FUNCTIONS

void keyPressed() {
  switch (key) {
    case ' ':
      loop();
      break;
    case 'd':
      connections = detectConnections();
      println("Connections: ");
      for (PVector v : connections) {
        println("Finger "+v.x+" and " +v.y+ " are connected.");
      }
      break;
  }
}

void showGesture(int _gesture) {
  background(#000000);

  fill(#F8F8F8);
  textSize(24);
  textAlign(CENTER,CENTER);

  if(_gesture>=0) {
    text(_gesture,width/2,height/2);
  }
  else {
    text("¿?",width/2,height/2);
  }

}

