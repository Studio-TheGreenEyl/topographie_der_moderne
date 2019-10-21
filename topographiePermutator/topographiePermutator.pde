import processing.video.*;

PGraphics pg;

long runTime = 1000;
String[] permutations;
String[] assets;
ArrayList<Area> areas = new ArrayList<Area>();
int randomCombination = 0;
StringList combinations = new StringList();

boolean runParallel = false; // run two movies at the same time
int combinationIndex = 0;
int combinationIndexNext = 1;
int currentArea = 0;
int currentAreaNext = 0;

// EXPORT
boolean export = true;
long exportCounter = 0;

void setup() {
  //size(3200, 24);
  size(1920, 14);
  pg = createGraphics(5568, 48);
  pg.beginDraw();
  pg.background(0);
  pg.endDraw();

  // array to arraylist conversion
  permutations = loadStrings("permutations.txt");
  for(int i = 0; i<permutations.length; i++) combinations.append(permutations[i]);
  
  for(int i = 0; i<5; i++) areas.add(new Area(this, i, 1113*i, 0)); 
  // 1113
  // 556
   
  assets = loadStrings("assets.txt");
  println("loaded assets.txt with "+ assets.length + " lines");  
  for(int i = 0; i<assets.length; i++) {
    String[] e = splitTokens(assets[i], ",");
    areas.get(int(e[1])).setAssets(int(e[2]), e[3], e[0], int(e[4]));
  }
  
  for (int i = 0; i < areas.size(); i++) {
    Area area = areas.get(i);
    area.loadMovies();
  } 
  
  randomCombination = int(random(combinations.size()));
  int r = (int)random(0, 100);
  if(r <= 20) runParallel = true;
  else runParallel = false;
}

void draw() {
  boolean allFinished = true;
  background(0);
  
  for(int i = 0; i<areas.size(); i++) {
    if(!areas.get(i).isFinished()) allFinished = false;  
  }
  
  if(allFinished) {
    println("all finished");
    if(combinations.size() <= 0) exit();
    combinationIndex = 0;
    combinationIndexNext = 1;
    combinations.remove(randomCombination);
    randomCombination = int(random(combinations.size()));    
    if(combinations.size() <= 0) {
      for(int i = 0; i<permutations.length; i++) combinations.append(permutations[i]);
    }
   
    for (int i = 0; i < areas.size(); i++) {
      Area area = areas.get(i);
      area.advanceArea();
    }
    int r = (int)random(0, 100);
    if(r <= 20) runParallel = true;
    else runParallel = false;
  } 
    /** play all simultaneously without order */
    /*
    for (int i = 0; i < areas.size(); i++) {
      Area area = areas.get(i);
      area.update();
      area.display();
    }
    */
    
    String[] currentCombination = split(combinations.get(randomCombination), ",");
    // get which area to play
    pg.beginDraw();
    pg.background(0);
    if(!runParallel) {
      for(int i = 0; i<currentCombination.length; i++) {
        if(int(currentCombination[i]) == combinationIndex) currentArea = i;
      }
      //println("––––––");
      Area area = areas.get(currentArea);
      area.update();
      area.display();
      if(area.isFinished()) combinationIndex++;
    } else {
      for(int i = 0; i<currentCombination.length; i++) {
        if(int(currentCombination[i]) == combinationIndex) currentArea = i;
      }
      for(int i = 0; i<currentCombination.length; i++) {
        if(int(currentCombination[i]) == combinationIndexNext) currentAreaNext = i;
      }
      //println("––––––");
      Area area1 = areas.get(currentArea);
      area1.update();
      area1.display();
      if(area1.isFinished()) combinationIndex+=2;
      
      Area area2 = areas.get(currentAreaNext);
      area2.update();
      area2.display();
      if(area2.isFinished()) combinationIndexNext+=2;
    }
    
    pg.endDraw();
    image(pg, 0, 0, width, height);
  
  
  if(export) {
    pg.save("export_wiggler/"+ exportCounter +".tga"); //saveFrame("export/###.tga");
    exportCounter++;
  }
  
  if(runParallel) {
    push();
    fill(255);
    noStroke();
    rect(2, 2, 2, 2);
    rect(10, 2, 2, 2);
    pop();
  } else {
     push();
    fill(255);
    noStroke();
    rect(2, 2, 2, 2);
    pop();
  }
}

void movieEvent(Movie m) {
  m.read();
}
