class Area {
  
  Movie mov_de;
  Movie mov_en;
  PApplet pa;
  int id;
  int cycle = 0;
  
  String[] files_de = {"", "", ""};
  String[] files_en = {"", "", ""};
  int[] wiggle_de = {0, 0, 0};
  int[] wiggle_en = {0, 0, 0};
  
  boolean pause = true;
  
  PVector pos;
  int c1 = int(random(255));
  
  public Area(PApplet _pa, int _id, int _x, int _y) {
    pa = _pa;
    id = _id;
    pos = new PVector(_x, _y);
  }
  
  void display() {
    imageMode(CORNER);

    translate(pos.x, pos.y);
    fill(c1, c1, c1/2);
    noStroke();
    rect(0, 0, 1113, 48);
    mov_de.play();
    image(mov_de, 0, 0);

  }
  
  void update() {
    
  }
  
  void setAssets(String _lang, int _asset, String _fn, int _w) {
    if(_lang.equals("de")) {
      files_de[_asset] = _fn;
      wiggle_de[_asset] = _w;
    } else {
      files_en[_asset] = _fn;
      wiggle_en[_asset] = _w;
    }
  }
  
  void loadMovie() {
    mov_de = new Movie(pa, "assets/"+ files_de[cycle]);
    mov_en = new Movie(pa, "assets/"+ files_en[cycle]);
    //mov_de.stop();
    mov_de.play();
    mov_en.play();
    //mov_en.stop();
  }
  
  void cycle() {
    cycle++;
    cycle %= 3;
  }
  
  void movieEvent(Movie m) {
    m.read();
  }
}
