PImage img;

void setup() {
  fullScreen();
  frameRate(30);
  img = loadImage("waldo.jpg");
  img.resize(width, height);
  img.loadPixels();
  // Only need to load the pixels[] array once, because we're only
  // manipulating pixels[] inside draw(), not drawing shapes.
  loadPixels();
  colorMode(HSB, 100);
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
  noCursor();
  if (gameOver == true) {
    image(img, 0, 0);
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
      // Get the H,S,B values from image
      float h, s , b;
      h = hue (img.pixels[loc]);
      s = saturation (img.pixels[loc]);
      b = brightness (img.pixels[loc]);
      // Calculate an amount to change brightness based on proximity to the mouse
      float maxdist = 100;//dist(0,0,width,height);
      float d = dist(x, y, mouseX, mouseY);
      //float adjustbrightness = (maxdist-d)/maxdist;
      if (d > maxdist) {
        b = 0;
      } 
      // Constrain HSB to make sure they are within 0-100 brightness range
      b = constrain(b, 0, 100);
      // Make a new color and set pixel in the window
      color c = color(h,s,b);
      pixels[y*width + x] = c;
    }
  }
  updatePixels();
}