// garrison winfield lemasters
// georgetown 2014
// minim library experiment 2
// includes song fragment from 
// jynweythek ylow, via
// (Marie Antoinette soundtrack)

import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer song;
FFT fft;
float xPos,yPos;

void setup() {
  size(900,700);
  minim=new Minim(this);
  song=minim.loadFile("ylow.mp3",512);
  song.play();
  fft=new FFT(song.bufferSize(),song.sampleRate());
  fft.forward(song.mix);
  noStroke();
}

void draw() {
  fill(128,5);
  rect(0,0,width,height);
  xPos=45;
  yPos=45;
  fft.forward(song.mix);
  int i=0;
  fill(255);
  while (i<fft.specSize()) {
    pushMatrix();
    translate(xPos,yPos);
    ellipse(0,0,fft.getBand(i)*(2.15+i/1.5),fft.getBand(i)*(2.15+i/1.5));
    popMatrix();
    i++;
    xPos=xPos+45;
    if (xPos>width-45) {
      xPos=45;
      yPos=yPos+45;
    }
    if (yPos>height-45) {
      yPos=45;
      xPos=45;
    }
  }
}