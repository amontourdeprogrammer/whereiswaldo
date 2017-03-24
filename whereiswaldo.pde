PImage waldoImg, endImg;
boolean gameWon = false, tryAgain = false, gameLost = false;
float xWaldo, yWaldo, originalImgWidth, originalImgHeight, searchRange;
int nbClick = 0, startTryAgain;

void setup() {
  fullScreen();
  frameRate(30);
  String urlWaldo = "https://i.ytimg.com/vi/SiYrSYd7mlc/maxresdefault.jpg"; 
  waldoImg = loadImage(urlWaldo, "jpg");
  waldoImg.resize(width, height);
  waldoImg.loadPixels();
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

  String urlYoda = "http://vignette2.wikia.nocookie.net/fairytailfanon/images/7/7c/Fail_Meme.jpg";
  endImg = loadImage(urlYoda, "jpg");
}

void draw() {
  noCursor();
  if (gameWon) {
    endGame();
  } else if (gameLost) {
    fill(0);
    rect(0,0, width, height);
    fill(100);
    text("Loooooser !!!!", width/2, height/6);
    imageMode(CENTER);
    image(endImg, width/2, height/2);
    noLoop();
  } else if (tryAgain) {
    text("Try again", width/2, height/2 );

    if ((millis() - startTryAgain) > 500) {
      tryAgain = false;
    }
  } else {
    playGame();
  }
}

void playGame() {
  for (int x = 0; x < waldoImg.width; x++) {
    for (int y = 0; y < waldoImg.height; y++ ) {
      // Calculate the 1D location from a 2D grid
      int loc = x + y*waldoImg.width;
      // Get the H,S,B values from image
      float h, s, b;
      h = hue (waldoImg.pixels[loc]);
      s = saturation (waldoImg.pixels[loc]);
      b = brightness (waldoImg.pixels[loc]);
      // Calculate an amount to change brightness based on proximity to the mouse
      float d = dist(x, y, mouseX, mouseY);
      if (d > searchRange) {
        b = 0;
      } 
      // Constrain HSB to make sure they are within 0-100 brightness range
      b = constrain(b, 0, 100);
      // Make a new color and set pixel in the window
      color c = color(h, s, b);
      pixels[y*width + x] = c;
    }
  }
  updatePixels();
}

void mouseClicked() {
  nbClick = nbClick + 1;
  float xWaldo_fullscreen = (xWaldo * width)/ originalImgWidth;
  float yWaldo_fullscreen = (yWaldo * height)/ originalImgHeight;
  float waldoRange = dist(mouseX, mouseY, xWaldo_fullscreen, yWaldo_fullscreen);
  if (waldoRange <= searchRange) {
    print("found Waldo");
    gameWon = true;
    redraw();
  } else {
    wrongClick();
  }
}

void wrongClick() {
  if (nbClick < 3) {
    startTryAgain = millis();
    tryAgain = true;
  } else {
    gameLost = true;
  }
}


void keyPressed() {
  if (keyCode == UP && searchRange <= height/3) {
    searchRange += 10;
  } else if (keyCode == DOWN && searchRange >= height/12) {
    searchRange -= 10;
  }
  if (keyCode == RIGHT) {
    gameWon = false;
    tryAgain = false;
    gameLost = false;
    loop();
  }
}


void endGame() {
  image(waldoImg, 0, 0);

  String congratsMessage = "Well done, you found Charlie!";
  float messageWidth = textWidth(congratsMessage);

  //Textbox manually placed
  rectMode(RADIUS);
  fill(100);
  rect(width/2, height/2 - 10, 0.75 * messageWidth, 20);

  fill(0);
  text(congratsMessage, width/2, height/2);
  noLoop();
}