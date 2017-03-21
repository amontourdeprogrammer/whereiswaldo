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
  textSize(32);
  textAlign(CENTER);
}

boolean gameWon = false;

void mouseClicked() {
  float[] coordinates = {mouseX, mouseY};
  if ((coordinates[0] <= 100) && (coordinates[1] <= 100)){
    print("found Waldo");
    gameWon = true;
    redraw();
  } else {
    //value = 0;
    print("Clicked!");
  }
}

void draw() {
  noCursor();
  if (gameWon == true) {
    image(img, 0, 0);
    
    String message = "Well done, you found Charlie!";
    float message_width = textWidth(message);
    
    rectMode(RADIUS);
    fill(100);
    rect(width/2, height/2 - 10, 0.75 * message_width, 20);
    
    fill(0);
    text(message, width/2, height/2);
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