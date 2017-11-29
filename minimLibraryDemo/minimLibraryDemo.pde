import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim myMinim;
AudioPlayer mySpeakers;
AudioInput myMicrophone;
float midScreen;


void setup()
{
  size (500,500);
  // Here, I'm going to use "this" as an argument.
  // Don't worry about it.  You'll only need to
  // use it in this situation.

  myMinim = new Minim(this);
  mySpeakers = myMinim.loadFile("mercury.mp3");
  myMicrophone = myMinim.getLineIn();
  mySpeakers.play();
  midScreen = height/2;
}

// we'll talk about bufferSize() next; just use it for now.

void draw()
{
 // background(100);
  for (int i = 0; i < mySpeakers.bufferSize() - 1; i=i+10)
  {
    float leftSpeaker = int(mySpeakers.left.get(i)*50)*10;
    fill(255);
    stroke(0);
    rect(i, midScreen + leftSpeaker, 10, 10);
    fill(100);
    noStroke();
    rect(i, midScreen + leftSpeaker + 10, 10, 300);
    rect(i, height - (midScreen + leftSpeaker), 10, 300);
  }
}