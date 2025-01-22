import themidibus.*;

MidiBus myBus; // The MidiBus
MidiMessageHandler msgh;

int r_cc = 0;
int g_cc = 1;
int b_cc = 2;

int r = 0;
int g = 0;
int b = 0;

void setup() {
  size(400, 400);
  background(0);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.

  // Either you can
  //                   Parent In Out
  //                     |    |  |
  //myBus = new MidiBus(this, 0, 1); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

  // or you can ...
  //                   Parent         In                   Out
  //                     |            |                     |
  //myBus = new MidiBus(this, "IncomingDeviceName", "OutgoingDeviceName"); // Create a new MidiBus using the device names to select the Midi input and output devices respectively.

  // or for testing you could ...
  //                   Parent  In        Out
  //                     |     |          |
  //myBus = new MidiBus(this, -1, "Java Sound Synthesizer"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.

  msgh = new MidiMessageHandler();
  //--------------------------------------------------------------------------

  // Open NK2 as input device and no output device
  // parent has to be this in order for callbacks to be called
  myBus = new MidiBus(msgh, "Feather RP2040", -1); // NK2

  // Not sure why, but the parent has to be new java.lang.Object() in order to send
  //myBus = new MidiBus(new java.lang.Object(), "USB Midi ", "USB Midi "); // USB Midi Interface cable
  println("opened Feather RP2040");
}

void draw() {
  background(r, g, b);
  //int channel = 0; // Midi spec has the numbers 1-16
  //int pitch = 64;
  //int velocity = 127;
  //Note note = new Note(channel, pitch, velocity);

  //myBus.sendNoteOn(note); // Send a Midi noteOn with Note class
  //myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn with the raw value
  //delay(200);
  //myBus.sendNoteOff(note); // Send a Midi nodeOff
  //myBus.sendNoteOff(channel, pitch, velocity); // Send a Midi nodeOff


  //int number = 14;
  //int value = 90;
  //ControlChange change = new ControlChange(channel, number, value);

  //myBus.sendControllerChange(change); // Send a controllerChange
  //myBus.sendControllerChange(channel, number, 96); // Send a controllerChange
  //delay(2000);
  //myBus.sendControllerChange(channel, number, 32); // Send a controllerChange
  //delay(2000);
}

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  print("Controller Change:");
  print(" Channel: "+channel);
  print(" Number: "+number);
  println(" Value: "+value);

  if (number == r_cc) {
    r = value * 2;
  } else if (number == b_cc) {
    b = value * 2;
  } else if (number == g_cc) {
    g = value * 2;
  }
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

void exit() {
  println("exiting");
  myBus.close();
}
