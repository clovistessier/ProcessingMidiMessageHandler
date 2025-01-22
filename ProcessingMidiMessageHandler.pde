import themidibus.*;

// MidiBus myBus; // The MidiBus

MidiMessage msg;

void setup() {
  size(400, 400);
  background(0);

  msg = new MidiMessage((byte) 0xB0, (byte) 0x07, (byte) 0x64);
  println(msg.getMessageType());

  noLoop();
}

void draw() {
  // background(r, g, b);
}

// void delay(int time) {
//   int current = millis();
//   while (millis () < current+time) Thread.yield();
// }

// void exit() {
//   println("exiting");
//   myBus.close();
// }
