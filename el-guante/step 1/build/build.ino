/*
//  Author: Richard B. Kaufman-López <richardbkaufman@gmail.com>
//  Date: 2014-07-22
//
//  Project: El Guante
//  Description: 
//
//  License: General Public License version 2
*/

#define ARRAY_SIZE(x)  (sizeof(x) / sizeof(x[0]))

const int OUTPUT_PORTS[] = {2,7};
const int INPUT_PORTS[] = {3,4,5,6};

String connections = "";
int gesture = -1;
const String gestures[] = {
  "", // Open hand
  "2,3;", // Index finger touches thumb
  "2,4;", // Middle finger touches thumb
  "2,5;", // Ring finger touches thumb
  "2,6;", // Pinky finger touches thumb
  "-", // Thumb touches back of middle finger
  "-", // Thumb touches back of ring finger
  "-", // Thumb touches back of middle finger
  "7,3;7,4;7,5;7,6;", // Non-thumb fingers are closed touching palm. Thumb is open.
  "-", // Non-thumb fingers (except index) are closed touching the palm. Thumb and index are open.
  "-" // Thumb is touching index on the inner-side contact.
};


void setup() {
  Serial.begin(9600);
//  delay(1000);
  
  // Setup ports
  for (int i = 0; i < ARRAY_SIZE(INPUT_PORTS); i++) {
    pinMode(INPUT_PORTS[i], INPUT);
    digitalWrite(INPUT_PORTS[i], HIGH); // Turn on internal pullup resistor. Inverts input logic.
  }

  for (int i = 0; i < ARRAY_SIZE(OUTPUT_PORTS); i++) {
    pinMode(OUTPUT_PORTS[i], OUTPUT);
    digitalWrite(OUTPUT_PORTS[i], HIGH); // Default is HIGH.
  }
//  Serial.print("Done!");
}

void loop() {
  connections = detectConnections();
  Serial.println("Connection: " + connections);
  
  gesture = detectGesture(connections);
  Serial.println("Gesture: " + String(gesture));
}

String detectConnections() {
  String _connections = "";
  
  // Detect connections
  for (int out = 0; out < ARRAY_SIZE(OUTPUT_PORTS); ++out) {
    digitalWrite(OUTPUT_PORTS[out], LOW);
    delay(10); // If the glove doesn't word properly, try making the delay longer
  
    for (int in = 0; in < ARRAY_SIZE(INPUT_PORTS); ++in) {
      if( digitalRead(INPUT_PORTS[in]) == LOW) {
        _connections += (String(OUTPUT_PORTS[out])+","+String(INPUT_PORTS[in])+";");
      }
    }
    digitalWrite(OUTPUT_PORTS[out], HIGH);
    delay(10); // If the glove doesn't word properly, try making the delay longer
  }
  return _connections;
} 

int detectGesture(String _connections) {
  _connections.trim();

  for(int i = 0; i < ARRAY_SIZE(gestures); i++) {
    if(_connections.equals(gestures[i])) {
      return i;
    }
  }
  
  return -1;
}