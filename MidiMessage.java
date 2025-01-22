public class MidiMessage {

    private byte byte1;
    private byte byte2;
    private byte byte3;

    // Default constructor
    public MidiMessage() {
        this.byte1 = 0;
        this.byte2 = 0;
        this.byte3 = 0;
    }

    // Constructor with parameters
    public MidiMessage(byte byte1, byte byte2, byte byte3) {
        this.byte1 = byte1;
        this.byte2 = byte2;
        this.byte3 = byte3;
    }
    // Getters and setters for each byte
    public byte getByte1() {
        return byte1;
    }

    public void setByte1(byte byte1) {
        this.byte1 = byte1;
    }

    public byte getByte2() {
        return byte2;
    }

    public void setByte2(byte byte2) {
        this.byte2 = byte2;
    }

    public byte getByte3() {
        return byte3;
    }

    public void setByte3(byte byte3) {
        this.byte3 = byte3;
    }

    public MidiMessageType getMessageType() {
        int statusByte = this.byte1 & 0xF0; // Mask to get the command
        return MidiMessageType.fromStatusByte(statusByte); //Use the static method from the enum
    }
}
