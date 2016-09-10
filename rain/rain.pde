import themidibus.*;

MidiBus myBus;

color pink = color(255, 34, 168);
color yellow = color(255, 255, 34);
color blue =  color(36, 236, 255);
color green = color(174, 252, 0);

color[] colors = {yellow, blue, green};

int pitch;
int max_pitch = 0;
int min_pitch = 1000;

Drop[] rain = new Drop[500];
int next_drop = 0;

void setup() {
  fullScreen();
  for (int i = 0; i < rain.length; i++) {
    rain[i] = new Drop();
    rain[i].dropColor = blue;
  }
  
  myBus = new MidiBus(this, "Port 1", "Port 1");
}

void draw() {
  background(pink);
   
  for (int i = 0; i < rain.length; i++) {
    rain[i].fall();
    rain[i].display();
    
    if(rain[i].centerY > height + 100) {
      rain[i].active = false;
    }
  }
}

void noteOn(Note note) {
  println("Note On! " + "Pitch: "+ note.pitch() + "Velocity: " + note.velocity());
  
  pitch = note.pitch();
  max_pitch = max(max_pitch, pitch);
  min_pitch = min(min_pitch, pitch);
    
  if (!rain[next_drop].active) {
    rain[next_drop].reset(normilize(min_pitch, max_pitch, note.pitch), 0, 4 + note.velocity()/10);
    next_drop = (next_drop + 1) % rain.length;
  }
}

void noteOff(Note note) {
  // Receive a noteOff
}

int normilize(int min_val, int max_val, int val) {
  return int((val - min_val * 1.0)/(max_val - min_val)*width);
}