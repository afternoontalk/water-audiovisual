import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;             
AudioInput audioInput;   
FFT fft;                 

int bufferSize = 1024;   
int sampleRate = 44100;  

void setup() {
  fullScreen();
  minim = new Minim(this);
  noStroke();
  
  audioInput = minim.getLineIn(Minim.MONO, bufferSize, sampleRate);
  
  fft = new FFT(audioInput.bufferSize(), audioInput.sampleRate());
}

  float s = 15;

void draw() {
  translate(width/2, height/2);
  background(0);
  

  // Analyze audio frequency data with FFT
  fft.forward(audioInput.mix);
  
  float mag = 1.5 * map(audioInput.mix.level(), 0, 1, 100, 1000);
  
  for (int i = 0; i < 100; i++) {
    int index = int(map(i, 0, 100, 0, fft.specSize()));
    float energy = fft.getBand(index); // Get FFT energy value for a specific frequency band
    
    int mappedI = int(map(energy, 0, 1, 0, 100));
    
    float mappedW = map(energy, 0, 1, -200, 2000);
    
    float wave1 = map(tan(radians(frameCount * 0.01 + mappedI + mappedW)), -1, 1, -mag, mag);
    float wave2 = map(cos(radians(frameCount * 0.1 + mappedI + mappedW )), -1, 1, -mag, mag);
    float wave3 = map(tan(radians(frameCount * 0.6 + mappedI + mappedW)), -1, 1, -mag, mag);
    float wave4 = map(cos(radians(frameCount * 0.2 + mappedI + mappedW)), -1, 1, -mag, mag);
    
    float r1 = map(sin(radians(frameCount + mappedI+ mappedW)), -1, 1, 0, 150);
    float g1 = map(sin(radians(frameCount + mappedI+ mappedW)), -1, 1, 50, 180);
    float b1 = map(sin(radians(frameCount + mappedI+ mappedW)), -1, 1, 100, 255);
    
    float alpha = map(energy, 0, 1, 0, 100);
    
    fill(r1, g1, b1, alpha);
   
    circle(wave1, wave2 + wave2 - 800, s * 1.5 * mappedI * 0.01);
    circle(wave3, wave1 + wave4, s * 1.5);
    
    float r2 = map(sin(radians(frameCount + mappedI+ mappedW)), -1, 1, 150, 255);
    float g2 = map(sin(radians(frameCount + mappedI+ mappedW)), -1, 1, 150, 200);
    float b2 = map(sin(radians(frameCount + mappedI+ mappedW)), -1, 1, 200, 255);
    
    fill(r2, g2, b2, alpha);
    circle(wave1 + wave3, wave2 + 300, s * 1.5);
  }
  
  
}


void stop() {
  // Clean up Minim resources when exiting the program
  audioInput.close();
  minim.stop();
  super.stop();
}
