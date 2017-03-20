PImage img;


void setup() {
  size(700, 431);
  frameRate(30);
  img = loadImage("waldo.jpg");
  img.resize(700, 0);
  img.loadPixels();
  // Only need to load the pixels[] array once, because we're only
  // manipulating pixels[] inside draw(), not drawing shapes.
  loadPixels();
  
}

boolean gameOver = false;

void mouseClicked() {
  float[] coordinates = {mouseX, mouseY};
  if ((coordinates[0] <= 100) && (coordinates[1] <= 100)){
    print("found Waldo");
    gameOver = true;
    redraw();
  } else {
    //value = 0;
    print("Clicked!");
  }
}

void draw() {
  //imageMode(CORNER);
  //image(img, 50, 50);
  if (gameOver == true) {
    loadPixels();
    img = loadImage ("waldo.jpg");
    img.loadPixels();
    updatePixels();
    noLoop ();
  }
  else {
    playGame();
  }

}

void playGame() {
    for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
      // Calculate the 1D location from a 2D grid
      int loc = x + y*img.width;
      // Get the R,G,B values from image
      float r,g,b;
      r = red (img.pixels[loc]);
      g = green (img.pixels[loc]);
      b = blue (img.pixels[loc]);
      // Calculate an amount to change brightness based on proximity to the mouse
      float maxdist = 100;//dist(0,0,width,height);
      float d = dist(x, y, mouseX, mouseY);
      float adjustbrightness = 255*(maxdist-d)/maxdist;
      r += adjustbrightness;
      g += adjustbrightness;
      b += adjustbrightness;
      // Constrain RGB to make sure they are within 0-255 color range
      r = constrain(r, 0, 255);
      g = constrain(g, 0, 255);
      b = constrain(b, 0, 255);
      // Make a new color and set pixel in the window
      //color c = color(r, g, b);
      color c = color(r,g,b);
      pixels[y*width + x] = c;
    }
  }
  updatePixels();
}