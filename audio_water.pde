import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;             // Minim library instance
AudioInput audioInput;   // Audio input source (microphone or other)
FFT fft;                 // FFT (Fast Fourier Transform) analyzer

int bufferSize = 1024;   // Size of the audio buffer for analysis
int sampleRate = 44100;  // Sample rate of audio input (adjust as needed)

void setup() {
  size(1920, 1080);
  minim = new Minim(this);
  
  // Set up audio input
  audioInput = minim.getLineIn(Minim.MONO, bufferSize, sampleRate);
  
  // Set up FFT analyzer
  fft = new FFT(audioInput.bufferSize(), audioInput.sampleRate());
  fft.window(FFT.HAMMING); // You can choose a different windowing function if desired
}

void draw() {
  translate(width/2, height/2);
  background(0);
  float mag = 300;
  float s = 10;
  noStroke();
  
  // Analyze audio frequency data with FFT
  fft.forward(audioInput.mix);
  
  for (int i = 0; i < 100; i++) {
    // Map FFT data to control the range of i
    int index = int(map(i, 0, 100, 0, fft.specSize()));
    float energy = fft.getBand(index); // Get FFT energy value for a specific frequency band
    
    // Map the energy value to control the range of i (adjust the values as needed)
    int mappedI = int(map(energy, 0, 1, 0, 100));
    
    // Map the energy value to control the range of w (adjust the values as needed)
    float mappedW = map(energy, 0, 1, -100, 100);
    
    float wave1 = map(tan(radians(frameCount * 0.8 + mappedI + mappedW)), -1, 1, -mag, mag);
    float wave2 = map(cos(radians(frameCount * 0.1 + mappedI + mappedW)), -1, 1, -mag, mag);
    float wave3 = map(tan(radians(frameCount * 0.6 + mappedI + mappedW)), -1, 1, -mag, mag);
    float wave4 = map(cos(radians(frameCount * 0.3 + mappedI + mappedW)), -1, 1, -mag, mag);
    
    float r = random(100, 150);
    float g = random(120, 180);
    float b = random(180, 255); // Randomly generate a color value
    
    fill(r, g, b);
    
    circle(wave1, wave2 + wave2, s * 1.5);
    rect(wave1 + wave3, wave2 + wave3, s * 0.2, s * 2);
  }
}

void stop() {
  // Clean up Minim resources when exiting the program
  audioInput.close();
  minim.stop();
  super.stop();
}
