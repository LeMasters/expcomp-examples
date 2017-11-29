import processing.video.*;

// expressive computation 2017
// some more revisions to my revisions to
// Della's excellent experiment
// from this week.

// This time, I've layered the snow
// atop video.  The video is in
// slow motion black and white, and
// then speeds up at the end, so it
// isn't ideal, but you'll see what
// I'm trying to accomplish.

Movie myMovie;
Snow[] mySnow;

void setup() {
    size(640, 360);
    
    // the Video library is built around the 
    // Movie class.  It is very particular
    // and specialized:  I find it works
    // best when I use it just as prescribed.
    // (Think of the complexity of what is
    // happening:  Your computer is refreshing
    // the screen at 60Hz; your processing
    // sketch is running at (say) 58fps;
    // you play a movie inside that sketch
    // that is running at 30fps; etc.
    // that is a lot of opportunity for
    // things to become un-synced.)
    myMovie = new Movie(this, "savvyBW.m4v");
    
    // the loop() method starts to play
    // the video... on an endless loop.
    myMovie.loop();
    background(#04112A);
    mySnow = new Snow[250];
    for (int i = 0; i < mySnow.length; i++) {
        mySnow[i] = new Snow(i);
    }
    noStroke();
}

void draw() {
    // surprisingly, perhaps, you treat the movie
    // like an image... in part because Processing
    // (and Java) are constantly updating the movie
    // for you (see more below).
    image(myMovie,0,0);

    for (int i = 0; i < mySnow.length; i++) {
        mySnow[i].drawSnow();
        mySnow[i].snowFall();
    }
}

// Many ways to use the Video library.
// One way is to include the new function
// movieEvent().  It's kind of like mousePressed().
// It is activated whether you called it or not.
// This is an event that gets called automatically
// every time a new frame from the video is ready 
// to be displayed.  It happens a lot -- usually about
// 24 times per second.  Processing passes a copy of
// that frame to the movieEvent function, where it is
// treated as a Movie object (but is really just a single
// frame from a movie) called "m".  The next line
// calls a method hidden inside the Movie class, "read()".
// That, in turn, updates your object (myMovie) to display
// the latest frame of the film.  You are able, then,
// to treat it like an image, by calling 
// image(myMovie, 0, 0);

// I find this Video library is great, but it is 
// really easy to muck up the display because of
// how often things get updated, etc.  Start by using it exactly
// as illustrated in the Processing manual, and
// adjust gently.

void movieEvent(Movie m) {
    m.read();
}

// the Snow class
class Snow {
    int ID; // I use ID as a way
    // of making some snow fall faster,
    // some slower.  It is an arbitrary
    // approach:  There are 100 other
    // ways to do that.
    int trans; // vary the transparency
    float x;
    float y;
    float dia;
    float flakeFallAdjustment;

    // when I call my constructor, I only pass
    // a single value, the ID number -- which is
    // just a consecutive series of integers.
    Snow(int _ID) {
        ID = _ID;
        trans = int(random(128, 235));
        x = random(0, width);

        // by setting y to a random number
        // between -height*0.75 and 0,
        // (in effect, -450 and 0), I
        // initially place the snow way
        // above the top of the window.
        // That way, it has time to
        // "settle" into its speed, 
        // arc, etc., and it looks more
        // natural.  Starting stuff from
        // y=0 will always look awkward.  
        // Start from y= -50, for example.
        y = random(-height * 0.75, 0);
        dia = random(2, 8);

        // with flakeFallAdjustement, I'm
        // just using the ID to slow down
        // every 7th flake, and speed up
        // every 31st flake.  Arbitrary.
        // just IDs that are multiples of 7
        if (this.ID%7 == 0) {
            flakeFallAdjustment = 0.45;
        } else {
            // just IDs that are multiples of 31
            if (this.ID%31 == 0) {
                flakeFallAdjustment = 1.65;
            } else {
                // all other IDs will end up on this line
                flakeFallAdjustment = 1.0;
            }
        }
    }


    // Here, I use the ID as a way of gradually
    // introducing flakes.  frameCount*0.05 means
    // that at 60fps, I'll have about 15 flakes
    // on screen after 5 seconds.  The objects
    // are all there, but I only draw them 
    // as that threshold rises.  Again,
    // there's no magic there, just a way
    // of harnessing the numbers to create an
    // effect.

    void drawSnow() {
        if (frameCount*0.05>this.ID) {
            fill(250, this.trans);
            ellipse(this.x, this.y, this.dia, this.dia);
        }
    }

    void snowFall() {
        float adj1 = cos(frameCount * 0.001 * this.ID); //horizontal
        float adj2 = 1.75-(noise(sin((adj1)), this.ID)); // vertical
        adj2 = adj2 * this.flakeFallAdjustment;

        this.x = this.x + adj1;
        this.y = this.y + adj2;
        
        // did we fall offscreen?  Send us back
        // to the top -- again, somewhere above
        // the top edge, between -10 and -350.
        if (this.y > height) {
            this.y = random(-150, -10);
        }
    }
}