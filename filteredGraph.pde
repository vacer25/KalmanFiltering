import controlP5.*;

// -------------------- DATA --------------------

int xPos = 1;         // horizontal position of the graph

float curentRawData = 50;
float previousRawData = 50;
float curentFilteredData = 0;
float previousFilteredData = 0;

float rawDataMaxRange = 100;
float rawDataMinRange = 0;
float rawDataChangeRange = 2;

// -------------------- FILTERING --------------------

KalmanFilter filter = new KalmanFilter();

// -------------------- INPUT --------------------

ControlP5 controlP5;
float smoothness = 0.01;
float roughness = rawDataChangeRange;

// -------------------- COLORS --------------------

color rawLineColor = color(240, 20, 0);
color filteredLineColor = color(0, 240, 20);

// -------------------- SIZE --------------------


void setup () {
  // set the window size:
  size(1800, 900);
  //frameRate(100);

  // set inital background:
  background(0);

  // -------------------- CONTOLLER --------------------

  controlP5 = new ControlP5(this);
  controlP5.addSlider("smoothness", 0.0001, 0.05, 0.01, 20, height - 50, width - 100, 10);
  controlP5.addSlider("roughness", 0.1, 20, rawDataChangeRange, 20, height - 30, width - 100, 10);
}
void draw () {

  //long currentMillis = millis();

  // -------------------- RAW DATA --------------------

  rawDataChangeRange = roughness;

  curentRawData += /* = (rawDataMaxRange / 4) * sin((float)(currentMillis / 2000.0f)) + rawDataMaxRange / 2 + */ random(rawDataChangeRange * 2) - rawDataChangeRange;
  curentRawData = constrain(curentRawData, rawDataMinRange, rawDataMaxRange);

  int currentRawHeight = (int)map(curentRawData, rawDataMinRange, rawDataMaxRange, height - 70, 0);
  int previousRawHeight = (int)map(previousRawData, rawDataMinRange, rawDataMaxRange, height - 70, 0);

  stroke(rawLineColor);
  strokeWeight(2);
  if (xPos > 0) {
    line(xPos - 1, previousRawHeight, xPos, currentRawHeight);
  } else {
    line(xPos, previousRawHeight, xPos, currentRawHeight);
  }

  previousRawData = curentRawData;

  // -------------------- FILTERED DATA --------------------

  filter.R = smoothness;

  //curentFilteredData = curentRawData * smoothness * 100000000 + (curentRawData * (1.0f - smoothness * 100000000));

  curentFilteredData = filter.update(curentRawData);

  int curentFilteredHeight = (int)map(curentFilteredData, rawDataMinRange, rawDataMaxRange, height - 70, 0);
  int previousFilteredHeight = (int)map(previousFilteredData, rawDataMinRange, rawDataMaxRange, height - 70, 0);

  //if (curentFilteredHeight >= previousFilteredHeight) {
  stroke(filteredLineColor);
  //stroke(20,240,30,200);
  //} else {
  //   stroke(255, 255, 255);
  // }

  strokeWeight(2);
  if (xPos > 0) {
    line(xPos - 1, previousFilteredHeight, xPos, curentFilteredHeight);
  } else {
    line(xPos, previousFilteredHeight, xPos, curentFilteredHeight);
  }

  previousFilteredData = curentFilteredData;

  // -------------------- RE-DRAW --------------------

  // at the edge of the screen, go back to the beginning:
  if (xPos >= width) {
    xPos = 0;
    background(0);
  } else {
    // increment the horizontal position:
    xPos++;
  }
}

void slider(float value) {
  println("a slider event. value: " + value);
}