import java.util.ArrayDeque;
import java.util.Queue;
// import MidiMessage

public class MidiMessageHandler {
  // Class attributes
  Queue<Integer> queue;

  /**
   * Constructor
   */
  public MidiMessageHandler() {
    queue = new ArrayDeque<>();
  }

  public boolean hasWaitingMessages() {
    return !queue.isEmpty();
  }

  public void clearMessages() {
    queue.clear();
  }

  /**
   * Represents a note on event.
   * @param channel MIDI channel (0-15)
   * @param pitch MIDI pitch (0-127)
   * @param velocity MIDI velocity (0-127)
   */
  public void noteOn(int channel, int pitch, int velocity) {
    // Implement logic for note on event here
    System.out.println("Note On: channel=" + channel + ", pitch=" + pitch + ", velocity=" + velocity);
  }

  /**
   * Represents a note off event.
   * @param channel MIDI channel (0-15)
   * @param pitch MIDI pitch (0-127)
   * @param velocity MIDI velocity (0-127)
   */
  public void noteOff(int channel, int pitch, int velocity) {
    // Implement logic for note off event here
    System.out.println("Note Off: channel=" + channel + ", pitch=" + pitch + ", velocity=" + velocity);
  }

  /**
   * Represents a controller change event.
   * @param channel MIDI channel (0-15)
   * @param number MIDI controller number (0-127)
   * @param value MIDI controller value (0-127)
   */
  public void controllerChange(int channel, int number, int value) {
    // Implement logic for controller change event here
    System.out.println("Controller Change: channel=" + channel + ", number=" + number + ", value=" + value);
  }
}
