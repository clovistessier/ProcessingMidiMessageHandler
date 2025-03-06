import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import processing.core.PApplet;
import themidibus.*;

public class MidiMessageHandler {
  private PApplet p; // Processing sketch (parent)
  private BlockingQueue<MidiMessage> messageQueue;
  private int maxSize;
  private static final int DEFAULT_MAX_SIZE = 100;
  private MidiBus myBus;
  private String incomingDeviceName;

  /**
   * Constructor with max size.
   *
   * @param maxSize The maximum size of the message queue.
   */
  public MidiMessageHandler(PApplet parent, String incomingDeviceName, int maxSize) {
    p = parent;
    this.incomingDeviceName = incomingDeviceName;
    this.maxSize = maxSize;
    messageQueue = new LinkedBlockingQueue<>(maxSize);

    // check that the desired device name is available
    boolean foundIncoming = false;
    for (String element : MidiBus.availableInputs()) {
      if (incomingDeviceName.equals(element)) {
        foundIncoming = true;
        break;
      }
    }

    if (foundIncoming) {
      // Open connection to Midi hardware, using handler as the parent to recieve
      // incoming messages
      myBus = new MidiBus(this, incomingDeviceName, -1);
      p.println("opened " + incomingDeviceName);

    } else {
      p.println("Desired input device " + incomingDeviceName + " is not available");
    }
  }

  /**
   * Default constructor using a predefined default max size.
   */
  public MidiMessageHandler(PApplet parent, String incomingDeviceName) {
    this(parent, incomingDeviceName, DEFAULT_MAX_SIZE); // Call the other constructor with the default value
  }

  public boolean hasWaitingMessages() {
    return !messageQueue.isEmpty();
  }

  public void clearMessages() {
    messageQueue.clear();
  }

  /**
   * Represents a note on event.
   *
   * @param channel  MIDI channel (0-15)
   * @param pitch    MIDI pitch (0-127)
   * @param velocity MIDI velocity (0-127)
   */
  public void noteOn(int channel, int pitch, int velocity) {
    byte statusByte = (byte) (0x90 | (channel & 0x0F));
    MidiMessage message = new MidiMessage(statusByte, (byte) pitch, (byte) velocity);
    if (!messageQueue.offer(message)) {
      System.err.println("Warning: Note On message queue is full. Message discarded.");
    }
  }

  /**
   * Represents a note off event.
   *
   * @param channel  MIDI channel (0-15)
   * @param pitch    MIDI pitch (0-127)
   * @param velocity MIDI velocity (0-127)
   */
  public void noteOff(int channel, int pitch, int velocity) {
    byte statusByte = (byte) (0x80 | (channel & 0x0F));
    MidiMessage message = new MidiMessage(statusByte, (byte) pitch, (byte) velocity);
    if (!messageQueue.offer(message)) {
      System.err.println("Warning: Note Off message queue is full. Message discarded.");
    }
  }

  /**
   * Represents a controller change event.
   *
   * @param channel MIDI channel (0-15)
   * @param number  MIDI controller number (0-127)
   * @param value   MIDI controller value (0-127)
   */
  public void controllerChange(int channel, int number, int value) {
    byte statusByte = (byte) (0xB0 | (channel & 0x0F));
    MidiMessage message = new MidiMessage(statusByte, (byte) number, (byte) value);
    if (!messageQueue.offer(message)) {
      System.err.println("Warning: Controller Change message queue is full. Message discarded.");
    } else {
      // System.out.println("channel: "+channel+" number: "+number+" value: "+value);
    }
  }

  /**
   * Retrieves and removes the first MidiMessage from the queue.
   *
   * @return The first MidiMessage object in the queue, or null if the queue is
   *         empty.
   */
  public MidiMessage getAndRemoveFirstMessage() {
    return messageQueue.poll();
  }

  /**
   * Gets the maximum size of the message queue.
   *
   * @return The maximum size.
   */
  public int getMaxsize() {
    return maxSize;
  }

  /**
   * Sets the maximum size of the message queue. This will create a new queue
   * with the new capacity and copy over the elements from the old queue.
   *
   * @param maxSize The new maximum size.
   */
  public void setMaxSize(int maxSize) {
    if (maxSize <= 0) {
      throw new IllegalArgumentException("Max size must be positive.");
    }

    this.maxSize = maxSize;
    BlockingQueue<MidiMessage> newQueue = new LinkedBlockingQueue<>(maxSize);
    messageQueue.drainTo(newQueue); // Efficiently transfer elements
    messageQueue = newQueue;
  }
}