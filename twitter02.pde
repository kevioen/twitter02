void setup() {
  size(960, 640);
  background(255);
  fill(0);
  stroke(200);
  smooth(); 
  noLoop();
  // BASIC TEXT SETUP:
  PFont font;
  font = loadFont("Helvetica-18.vlw");
  textFont(font);
}

void draw() {

  String[] timestamps = {
  };
  String[] readings = {
  };

  String[] lines = loadStrings("https://twitter.com/SpikeData");
  println(lines);
  // GET TIMESTAMPS
  for (int i=0; i < lines.length; i++) {
    String[] timelines = match(lines[i], "tweet-timestamp"); // look for lines with timestamp
    // NEXT TO DO: PARSE FOR %23 = hashtag
    if (timelines != null) {
      String goodlines = trim(lines[i]);
      String[] betterlines = split(goodlines, '"'); // " is the separator for chunking
      timestamps = append(timestamps, betterlines[5]);
    }
  }

  //println(timestamps);

  // GET TWEET TEXT
  for (int i=0; i < lines.length; i++) {
    String[] tweetlines = match(lines[i], "random"); // I inserted random values in each tweet from the sensor b/c Twitter doesn't like you to tweet the same thing more than once.
    if (tweetlines != null) {
      String goodlines = trim(lines[i]);
      String[] tweets = split(goodlines, ' ');
      readings = append(readings, tweets[8]);
    }
  }

  //println(readings);

  // FIND HIGHEST READING
  float highest = 0;
  for (int i=0; i < readings.length; i++) {
    if (int(readings[i]) > highest) {
      highest = int(readings[i]);
    }
  }

  // GRAPH
  for (int i=0; i < timestamps.length; i++) {
    float h = map(int(readings[i]), 0, highest, 50, height-170);
    float hh = map(int(readings[i+1]), 0, highest, 50, height-170);
    float x = map(i, 0, timestamps.length, 50, width-50);
    float xx = map(i+1, 0, timestamps.length, 50, width-50);
    line(width-x, height-150-h, width-x, height-50); // Bar graph
    line(width-x, height-h-150, width-xx, height-hh-150); // Line graph
    //rect(width-x, height-50-h, width-x, height-50);
    //ellipse(width-x, (height-h)/2+(h/2), width-x, height-50);
    //ellipse(width-x, height/2, h, h);

    // Text
    text(int(readings[i]), width-x-10, height-h-150);
    pushMatrix();
    translate(width-x-2, height-50);
    rotate(-PI/2); 
    text(timestamps[i], 0, 0);
    popMatrix();
  }

  // Y AXIS TEXT
  pushMatrix();
  translate(50, height/2);
  rotate(-PI/2); 
  text("Readings per minute", 0, 0);
  popMatrix();
}

