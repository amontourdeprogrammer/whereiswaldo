PImage img;
boolean gameWon = false;
float xWaldo, yWaldo, originalImgWidth, originalImgHeight, searchRange;

void setup() {
fullScreen();
//size(800,500);
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

  gameWon = false;
  xWaldo = 1266;
  yWaldo = 100;
  originalImgWidth = 1590;
  originalImgHeight = 981;
  searchRange = 100;
}

void draw() {
  noCursor();
  if (gameWon == true) {
    endGame();
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
      float d = dist(x, y, mouseX, mouseY);
      if (d > searchRange) {
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

void mouseClicked() {
  float xWaldo_fullscreen = (xWaldo * width)/ originalImgWidth;
  float yWaldo_fullscreen = (yWaldo * height)/ originalImgHeight;
  float waldoRange = dist(mouseX, mouseY, xWaldo_fullscreen, yWaldo_fullscreen);
  if (waldoRange <= searchRange){
    print("found Waldo");
    gameWon = true;
    redraw();
  } else {
    print("Clicked!");
  }
}

void keyPressed() {
  if (keyCode == UP && searchRange <= height/3){
    searchRange += 10;
  }
  else if (keyCode == DOWN && searchRange >= height/12) {
    searchRange -= 10;
  }
}


void endGame() {
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