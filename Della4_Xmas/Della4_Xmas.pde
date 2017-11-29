// expressive computation 2017
// some small revisions to snow class
// using Della's excellent experiment
// from this week.


Snow[] mySnow;
PImage backImage;

// image originally 564 x 382
void setup() {
    size(800, 600, FX2D);
    backImage = loadImage("winterGU.jpg");
    backImage.resize(0, 600);
    background(#04112A);
    mySnow = new Snow[220];
    for (int i = 0; i < mySnow.length; i++) {
        mySnow[i] = new Snow(i);
    }
    noStroke();
}

void draw() {
    background(#04112A);

    // using tints to colorize image
    tint(110, 180, 232, 230);
    tint(150, 128);
    image(backImage, 0, 0);

    // two methods are called
    for (int i = 0; i < mySnow.length; i++) {
        mySnow[i].drawSnow();
        mySnow[i].snowFall();
    }
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
        trans = int(random(64, 225));
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
            this.y = random(-350, -10);
        }
    }
}