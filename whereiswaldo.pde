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
float xWaldo = 1266, yWaldo = 100;
float originalImgWidth = 1590, originalImgHeight = 981;

void mouseClicked() {
  float xWaldo_fullscreen = (xWaldo * width)/ originalImgWidth;
  float yWaldo_fullscreen = (yWaldo * height)/ originalImgHeight;
  float waldoRange = dist(mouseX, mouseY, xWaldo_fullscreen, yWaldo_fullscreen);
  if (waldoRange <= 100){
    print("found Waldo");
    gameWon = true;
    redraw();
  } else {
    print("Clicked!");
  }
}

void draw() {
  noCursor();
  if (gameWon == true) {
    image(img, 0, 0);
    
    String congratsMessage = "Well done, you found Charlie!";
    float messageWidth = textWidth(congratsMessage);
    //Textbox manually placed
    rectMode(RADIUS);
    fill(100);
    rect(width/2, height/2 - 10, 0.75 * messageWidth, 20);
    
    fill(0);
    text(congratsMessage, width/2, height/2);
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