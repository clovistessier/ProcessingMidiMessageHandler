# MidiMessageHandler

A Java class for handling MIDI input in Processing with `themidibus` library

## Overview

The `MidiMessageHandler` class provides a thread-safe way to manage incoming MIDI messages. It uses a bounded queue to store incoming messages from `themidibus` when set as the parent of the `MidiBus` object. This design allows for asynchronous processing of MIDI events, preventing blocking of the main application thread.

## Features

*   **Thread-safe message queue:** Uses `LinkedBlockingQueue` for concurrent access.
*   **Bounded queue:** Prevents excessive memory usage by limiting the number of stored messages.
*   **Callback methods:**  `noteOn()`, `noteOff()`, and `controllerChange()` methods to handle specific MIDI message types from `themidibus`
*   **Clear message queue functionality:** Provides `clearMessages()` to empty the message queue.
*   **Getter and Setter for Max Queue Size:** Allows dynamic adjustment of the queue's capacity.
*   **Error Handling:** Discards messages and prints a warning to `System.err` if the queue is full.

## Usage

1.  **Include the classes:** Place `MidiMessage.java`, `MidiMessageType.java`, and `MidiMessageHandler.java` in your Processing sketch's `code` folder

2.  **Create an instance:** Create an instance of `MidiMessageHandler` in your Processing sketch, passing the sketch as the parent and name of the device you want to open. The MidiMessageHandler object will open the connection to the MIDI device using MidiBus under the hood.
Note: if the device isn't available then it will print to the console that it couldn't be found.

    ```java

    MidiMessageHandler midiHandler;

    void setup() {
        MidiBus.list()
        midiHandler = new MidiMessageHandler(this, "incomingDeviceName", 100); // Create handler with a queue size of 100
    }
    ```

5.  **Retrieve messages from the queue:** Use the `getAndRemoveFirstMessage()` method to process the queued messages.

    ```java
    void draw() {
        while (midiHandler.hasWaitingMessages()) {
            MidiMessage message = midiHandler.getAndRemoveFirstMessage();
            // Process the message
            println(message);

            // Check message type
            if (message.getMessageType() == MidiMessageType.CONTROL_CHANGE)
            {
                println(message.getChannel() + " " + message.getControllerNumber() + " " + message.getControllerValue());
            }
            if (message.getMessageType() == MidiMessageType.NOTE_ON || message.getMessageType() == MidiMessageType.NOTE_OFF)
            {
                println(message.getChannel() + " " + message.getNote() + " " + message.getVelocity());
            }
        }
    }
    ```

## Class Details

### `MidiMessageHandler(PApplet parent, String incomingDeviceName, int maxSize)`

Constructor. Pass the processing sketch as the parent and the name of the MIDI device you want to opern. Initializes the message queue with the specified maximum size. You can see see which devices are available with `MidiBus.list()`. If `incomingDeviceName` is not available, a warning is printed to the console. Creates a `MidiBus` object under the hood to listen for incoming messages.

### `MidiMessageHandler(PApplet parent, String incomingDeviceName)`

Constructor. Same as above but passes a default queue size of 100 MIDI messages.

### `void clearMessages()`

Clears all messages from the queue.

### `void noteOn(int channel, int pitch, int velocity)`

Callback method for Note On MIDI messages. Creates a `MidiMessage` object and adds it to the queue.

### `void noteOff(int channel, int pitch, int velocity)`

Callback method for Note Off MIDI messages. Creates a `MidiMessage` object and adds it to the queue.

### `void controllerChange(int channel, int number, int value)`

Callback method for Controller Change MIDI messages. Creates a `MidiMessage` object and adds it to the queue.

### `MidiMessage getAndRemoveFirstMessage()`

Retrieves and removes the first message from the queue. Returns `null` if the queue is empty.

### `int getMaxsize()`

Returns the maximum size of the message queue.

### `void setMaxSize(int maxSize)`

Sets the maximum size of the message queue. This creates a new queue and copies the existing messages. Throws `IllegalArgumentException` if `maxSize` is not positive.

## Dependencies
*   Processing 4.* (could work on earlier versions, but haven't tested it)
*   `themidibus` MIDI library for Processing
