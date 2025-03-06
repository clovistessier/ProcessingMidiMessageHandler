import themidibus.*;

MidiBus myBus; // The MidiBus
MidiMessageHandler handler;

// MIDI CC mappings
final int R_CC = 0;
final int B_CC = 1;
final int G_CC = 2;

int r = 0;
int g = 0;
int b = 0;

void setup() {
  size(400, 400);
  background(r, g, b);

  MidiBus.list();  // List all available Midi devices on STDOUT. This will show each device's index and name.

  String incomingDeviceName = "SLIDER/KNOB";
  handler = new MidiMessageHandler(this, incomingDeviceName); // use default constructor, size 100 messages.
}

void draw() {
  // check for waiting MIDI messages
  while (handler.hasWaitingMessages()) {
    MidiMessage msg = handler.getAndRemoveFirstMessage();     // Got a message
    if (msg.getChannel() == 1) { // Check if this is the MIDI channel we're listening on
      if (msg.getMessageType() == MidiMessageType.CONTROL_CHANGE) { // Handle Control Change messages
        switch(msg.getControllerNumber()) {
        case R_CC:
          r = msg.getControllerValue()*2;
          break;
        case B_CC:
          b = msg.getControllerValue()*2;
          break;
        case G_CC:
          g = msg.getControllerValue()*2;
          break;
        default :
          println("got an unmapped midi cc: " + msg.getControllerNumber() + " value: " +msg.getControllerValue());
        }
      }
    }
  }
  background(r, g, b);
}