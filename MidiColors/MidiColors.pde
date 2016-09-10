import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

void setup() {
  size(800, 800);
  background(0);

  colorMode(HSB, 100);

  MidiBus.list();
  myBus = new MidiBus(this, "Port 1", "Port 1");
}

Note last_note;

int pitch;
int max_pitch = 0;
int min_pitch = 1000;

int velocity;
int max_velocity = 0;
int min_velocity = 1000;

void draw() {
  
  if (last_note != null) {
    pitch = last_note.pitch();
    max_pitch = max(max_pitch, pitch);
    min_pitch = min(min_pitch, pitch);
    
    velocity = last_note.velocity();
    max_velocity = max(max_velocity, velocity);
    min_velocity = min(min_velocity, velocity);
    
    if (max_pitch != min_pitch) {
      background(
        color(
          normilize(min_pitch, max_pitch, pitch),
          normilize(min_velocity, max_velocity, velocity),
          50
        ));
    }
    
    text("PITCH: [" + min_pitch + ", " + max_pitch + "]", 10 , 10);
  }
    
  // myBus.sendNoteOn(note); // Send a Midi noteOn
  // myBus.sendNoteOff(note); // Send a Midi nodeOff
}

float normilize(int min_val, int max_val, int val) {
  return (val - min_val * 1.0)/(max_val - min_val)*100;
}

void noteOn(Note note) {
  // Receive a noteOn
  println("Note On! " + "Pitch: "+ note.pitch() + "Velocity: " + note.velocity());
  last_note = note;
}

void noteOff(Note note) {
  // Receive a noteOff
}

void controllerChange(ControlChange change) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+change.channel());
  println("Number:"+change.number());
  println("Value:"+change.value());
}