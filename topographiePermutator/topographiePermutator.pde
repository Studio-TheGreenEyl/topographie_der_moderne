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

int randomMin = 4500;
int randomMax = 6000;

// fps
boolean useFps = true;
int fps = 30;
long lastMillis = 0;

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
  frameRate(30);

  // array to arraylist conversion
  permutations = loadStrings("permutations.txt");
  for(int i = 0; i<permutations.length; i++) combinations.append(permutations[i]);
  
  for(int i = 0; i<5; i++) areas.add(new Area(this, i, 1113*i, 0)); 
   
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
}

void draw() {
  if (useFps && millis() - lastMillis < 1000.0/fps) return;
    lastMillis = millis();
    
  boolean allFinished = true;
  background(0);
  
  for(int i = 0; i<areas.size(); i++) {
    if(!areas.get(i).isFinished()) allFinished = false;  
  }
  
  if(allFinished) {
    String[] currentCombination = split(combinations.get(randomCombination), ",");
    for(int i = 0; i<areas.size(); i++) {
       println(i +" => " + currentCombination[i]);       
        Area a = areas.get(int(currentCombination[i]));
        int randomDelay = (int)random(randomMin*i, randomMax*i);
        println(currentCombination[i] +" => " + randomDelay);
        a.setDelay(randomDelay);
    }
    // remove this index
    combinations.remove(randomCombination);
    randomCombination = int(random(combinations.size()));
    
    if(combinations.size() <= 0) exit();
    
    for (int i = 0; i < areas.size(); i++) {
      Area area = areas.get(i);
      area.advanceArea();
    }
  }
  pg.beginDraw();
  pg.background(0);
    

    
  // neue, cleane methode
  for(int i = 0; i<areas.size(); i++) {
    Area a = areas.get(i);
    a.update();
    a.display();
  }
    
  pg.endDraw();
 // image(pg, 0, 0, width, height);
  
  
  if(export) {
    pg.save("exports/191024/"+ exportCounter +".tga"); //saveFrame("export/###.tga");
    exportCounter++;
  }
  
}

void movieEvent(Movie m) {
  m.read();
}
