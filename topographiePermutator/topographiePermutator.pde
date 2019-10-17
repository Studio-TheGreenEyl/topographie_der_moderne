import processing.video.*;

long runTime = 1000;
String[] permutations;
String[] assets;
ArrayList<Area> areas = new ArrayList<Area>();
StringList combinations = new StringList();



void setup() {
  size(5568, 48);
  
  // array to arraylist conversion
  permutations = loadStrings("permutations.txt");
  for(int i = 0; i<permutations.length; i++) combinations.append(permutations[i]);
  
  //combinations.remove(50);
  //int randomCombination = random(combinations.size());
  
  for(int i = 0; i<1; i++) areas.add(new Area(this, 0, 1113*i, 0));
    
   
  
  assets = loadStrings("assets.txt");
  for(int i = 0; i<assets.length; i++) {
    String[] e = splitTokens(assets[i], ",");
    areas.get(int(e[1])).setAssets(e[3], int(e[2]), e[0], int(e[4]));
    
    //void setAssets(String _lang, int _asset, String _fn, int _w) {
  }
  
  for (int i = 0; i < areas.size(); i++) {
    Area area = areas.get(i);
    area.loadMovie();
  } 
  
}

void draw() {
  for (int i = 0; i < areas.size(); i++) {
    Area area = areas.get(i);
    area.display();
  } 
}
