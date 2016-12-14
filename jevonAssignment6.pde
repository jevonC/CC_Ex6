//----concept
//the treachery of words
//----inspirations
//Ludwig Wittgenstein's "Tractatus Logico-Philosophicus"
//David McCracken's "Diminish and Ascend"
//Rene Magritte's "The Treachery of Images"
//----controls
//Move mouse

IntDict counts; //stores strings with numbers. other versions: strings-float, strings-strings...
//IntDict countsDescend; //could not use to store counts.sortValuesReverse(), see below
int offset=3; //"lower" text to fit y-value, used to make the words "join"
PFont myFont; //fonts always needed

void setup() {
  //fullScreen(); //why does this not work?
  size(1200, 800, P3D);
  smooth();

  //font stuff
  myFont=createFont("Arial", 32, true);
  textFont(myFont);

  //initialise IntDict 
  counts=new IntDict();
  //countsDescend=new IntDict();

  //load text file
  String source="http://archive.org/stream/tractatuslogicop05740gut/tloph10.txt"; //Wittgensteins' Tractatus Logico-Philosophicus
  String[] lines=loadStrings(source); 
  String allwords=join(lines, "\n");
  String[]tokens=splitTokens(allwords, "\n\" .?!<>:/)=#+*]-$(&':,0123456789;}[_\\|`"); //remember: escape with a backslash '\'
  //how do I remove unwanted strings like "https"?

  //looping through all the tokens, we make 'counts'
  for (int i=0; i<tokens.length; i++) {
    String word=tokens[i].toLowerCase(); //word is whichever word we're looking at; we'll cycle through them all
    if (counts.hasKey(word)) { //hasKey() checks if key exists
      counts.increment(word); //increment() reaches in to relevant int value and +1 to value
    } else {
      counts.set(word, 1); //if new word, set int to 1; we're updating the key-value pair
    }
  }

  //I want to get word values in descending order to make staircase
  // countsDescend=counts.sortValuesReverse(); //why can't this work?
  //code below is a workaround, though it leaves 'counts' distorted...

  /* moved to draw(), forget about countsDescend for now
   //sort in descending order
   counts.sortValuesReverse();
   
   //copying 'counts' into 'countsDescend'
   arrayCopy(counts, countsDescend); //transplants 'counts' into 'countsDescend'
   */

  //by the end of setup(), we will know frequency of each word
}

void draw() {
  background(0);

  float mouseXconstrain=map(mouseX, 0, width, width*0.3, width*0.7); //constraining mobility of camera
  float mouseYconstrain=map(mouseY, 0, height, height*0, height*0.75); //constraining mobility of camera

  //camera
  camera(mouseXconstrain, mouseYconstrain, ((height/2) / tan(PI/6))-420, width/2, height/2, 0, 0, 1, 0); //constants included to crudely adjust perspective

  //sort counts in descending order
  counts.sortValuesReverse(); 

  //everyone is translated, no excuses
  translate(width/2, (height/2)+(height/6), 0); //constant (height/6) included to crudely adjust perspective

  //iterate through entire list
  //we just want a copy of the key (i.e the words) without the values; counterpart: valueArray()
  String[] keys=counts.keyArray(); //array of ONLY all the 'key's in IntDict
  //for (int i=0; i<keys.length; i++) { //going through every key
  for (int i=0; i<keys.length; i++) {
    //int count=counts.get(keys[i]); //getting corresponding 'value' for that particular 'key', initially used to change textSize

    textSize(10);
    float scalar=0.8; //adjust based on font
    float a=textAscent()*scalar;
    float x=0;

    float yCounter= ceil(0.5*i); 
    float y=-1*yCounter*a; //every i=1,3,5,7,9..... y-value increases

    float zCounter= floor(0.5*i);
    float z=-1*zCounter*a; //every i=0,2,4,6,8..... z-value increases

    //push-pop for every word?
    pushMatrix();
    translate(x, y, z); //translate(x, y, z);

    //rotating alternate words to form steps
    if (i%2==1) {
      rotateX(PI/2); //rotate 90 degrees away from screen
    }

    textAlign(CENTER, BOTTOM);
    text(keys[i], 0, 0+offset); //offset brings it down to baseline

    //drawing line at start of staircase
    if (i==0) {
      strokeWeight(1);
      stroke(255);
      line(-width*50, 0, width*50, 0); //is this line slightly glitchy? why does it get thicker sometimes?
    }

    //drawing line at end of staircase (but we can't see it!)
    if (i==keys.length-1) {
      strokeWeight(1);
      stroke(255);
      line(-width*50, 0, width*50, 0);
    }
    popMatrix();
  }

  /*
  //our floor
   stroke(255);
   noFill();
   beginShape();
   vertex(-15, 0, 0);
   vertex(15, 0, 0);
   vertex(15, 0, 30);
   vertex(-15, 0, 30);
   endShape(CLOSE);
   */
}