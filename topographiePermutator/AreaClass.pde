class Area {
  /*
    -- todo
    [ ] out to pgraphics
    [ ] wiggle room
    [x] asynch play
    [x] delays!
    
    */
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
  boolean isFinished = false;
  boolean advancable = false;
  
  PVector pos;
  int c1 = int(random(255));
  
  
  long randomStartDelay = (int)random(randomMin, randomMax);
  long time = 0;
  
  public Area(PApplet _pa, int _id, int _x, int _y) {
    pa = _pa;
    id = _id;
    pos = new PVector(_x, _y);
    time = millis();
  }
  
  void display() {
    pg.imageMode(CORNER);
    pg.push();
    pg.translate(pos.x, pos.y);
    
    pg.image(mov_de, 0+wiggle_de[cycle], 0);
    pg.image(mov_en, 556+wiggle_en[cycle], 0);
    /*
    push();
    fill(255);
    text("id(" + id +")", 10, 10);
    pop();
    */
    pg.pop();
  }
  
  void update() {
    if(pause) {
      if(millis() - time > randomStartDelay) {
        time = millis();
      startMovies();
      pause = false;
      //println("unpaused");
      }
    }
    
    if(!pause) checkFinished();
    
    
  }
  
  void setAssets(int _asset, String _lang, String _fn, int _w) {
    if(_lang.equals("de")) {
      files_de[_asset] = _fn;
      wiggle_de[_asset] = _w;
    } else {
      files_en[_asset] = _fn;
      wiggle_en[_asset] = _w;
    }
  }
  
  void loadMovies() {
    println("loaded movie files into RAM");
    println("=> " + files_de[cycle]);
    println("=> " + files_en[cycle]);
    mov_de = new Movie(pa, "assets/"+ files_de[cycle]);
    mov_en = new Movie(pa, "assets/"+ files_en[cycle]);
    mov_de.play();
    mov_en.play();
    mov_de.jump(0);
    mov_en.jump(0);
    mov_de.stop();
    mov_en.stop();
    
  }
  
  void cycle() {
    print(cycle + " => ");
    cycle++;
    cycle %= 3;
  }
  
  void movieEvent(Movie m) {
    m.read();
  }
  
  void checkFinished() {
    float currentTime_de = mov_de.time();
    float totalTime_de = mov_de.duration();
    float currentTime_en = mov_en.time();
    float totalTime_en = mov_en.duration();
    
    if( (currentTime_de >= totalTime_de && currentTime_en >= totalTime_en) || (int(currentTime_de) >= int(totalTime_de) && int(currentTime_en) >= int(totalTime_en))) {
      isFinished = true;
      advancable = false;
    }
    
  }
  
  void startMovies() {
    if(mov_de != null) {
      mov_de.play();
      if(mov_de.width != 0) wiggle_de[cycle] = 556-int(random(mov_de.width, 556));
    }
    if(mov_en != null) {
      mov_en.play();
      if(mov_en.width != 0) wiggle_en[cycle] = 556-int(random(mov_en.width, 556));
    }
  }
  
  
  boolean isFinished() {
    return isFinished;
  }
  
  void canAdvance() {
    advancable = true;
  }
  
  void setDelay(int delay) {
    randomStartDelay = delay;
  }
  
  void advanceArea() {
    if(isFinished) {
      // cycle + reset stuff + loadAssets
      println();
      println("gotta cycle fast");
      cycle();
      isFinished = false;
      loadMovies();
      pause = true;
      // alte methode
      //randomStartDelay = (int)random(randomMin, randomMax);
      
      // bisschen flotter
      //if(runParallel) randomStartDelay = (int)random(randomMin, randomMax*1.5);
      //else randomStartDelay = (int)random(randomMin/2, randomMax/2);
      time = millis();
      println("paused");
    }
  }
}
