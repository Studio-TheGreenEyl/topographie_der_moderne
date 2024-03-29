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
  Movie dot;
  PApplet pa;
  int id;
  int cycle = 0;
  
  String[] files_de = {"", "", ""};
  String[] files_en = {"", "", ""};
  int[] wiggle_de = {0, 0, 0};
  int[] wiggle_en = {0, 0, 0};
  
  int[] width_de = {0, 0, 0};
  int[] width_en = {0, 0, 0};
  
  int[] height_de = {0, 0, 0};
  int[] height_en = {0, 0, 0};
  
  boolean pause = true;
  boolean isFinished = false;
  boolean advancable = false;
  boolean showDot = false;
  
  long dotTimer = 0;
  long dotDelay = 500;
  float dotAlpha = 0.0;
  
  PVector pos;
  int c1 = int(random(255));
  
  float scale = 1.0;
  
  
  long randomStartDelay = (int)random(randomMin, randomMax);
  long time = 0;
  
  public Area(PApplet _pa, int _id, int _x, int _y) {
    pa = _pa;
    id = _id;
    pos = new PVector(_x, _y);
    time = millis();
    
    dot = new Movie(pa, "assets/dot.mp4");
    dot.play();
    dot.jump(0);
    dot.stop();
  }
  
  void display() {
    pg.imageMode(CENTER);
    pg.rectMode(CENTER);
    pg.push();
    
    //pg.pushStyle();
    pg.noFill();
    //pg.stroke(255);
    //pg.strokeWeight(3);
    //pg.translate(pos.x, pos.y);
    if(drawDot) pg.image(dot, dot_positions[id], 24);
    //pg.rect(dot_positions[id], 24, 30, 48);
    //pg.popStyle();
    
    float pointLeft = 0;
    float pointMiddle = dot_positions[id];
    float pointRight = 1113;
    /*
    float positionDE = pointMiddle / 2;
    float positionEN = (pointMiddle / 2) * 3;
    */
    float positionDE = pointMiddle - radiusAroundDot;
    float positionEN = pointMiddle + radiusAroundDot;
    
    
    
    /*
    if(showDot) {
      if(dotAlpha <= 1.0) dotAlpha += 0.1;
      pg.push();
      pg.fill(255, map(dotAlpha, 0.0, 1.0, 0, 255));
      pg.circle(556, pg.height/2, 16);
      pg.pop();
    } else if(!showDot && dotAlpha > 0) {
      if(dotAlpha > 0.0) dotAlpha -= 0.05;
      pg.push();
      pg.fill(255, map(dotAlpha, 0.0, 1.0, 0, 255));
      pg.circle(556, pg.height/2, 16);
      pg.pop();
    }
    */
    
    // mit wiggle
    //pg.image(mov_de, 0+wiggle_de[cycle], 0);
    //pg.image(mov_en, 556+wiggle_en[cycle], 0);
    
    // ohne wiggle
    //pg.image(mov_de, (556-width_de[cycle])/2, 0);
    //pg.image(mov_en, 556 + ( (556-width_en[cycle])/2 ), 0);
    
    // ohne wiggle und zentriert mit hilfe von dot_position
    pg.push();
    pg.imageMode(CORNER);
    pg.image(mov_de, positionDE - width_de[cycle], 0);
    pg.image(mov_en, positionEN, 0);
    
    
    
    pg.stroke(255, 0, 0);
    //pg.rect(positionDE - width_de[cycle], 0, width_de[cycle], height_de[cycle]-2);
    //pg.rect(positionEN, 0, width_en[cycle], height_en[cycle]-2);
    pg.pop();
    
    /*
    pg.stroke(255);
    pg.line(positionDE, 0, positionDE, 48);
    pg.line(positionEN, 0, positionEN, 48);
    
    pg.stroke(0, 255, 255);
    pg.line(0, 0, 0, 48);
    pg.stroke(255, 255, 0);
    pg.line(556*2, 0, 556*2, 48);
    */
    
    
    
    
    //pg.fill(255, 0, 255);
    //pg.circle( (pointMiddle - pointLeft) / 2, 24, 5);
    //pg.circle( (pointRight - pointMiddle) / 2, 24, 5);
    
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
    dot.play();
    mov_de.jump(0);
    mov_en.jump(0);
    dot.jump(0);
    mov_de.stop();
    mov_en.stop();
    dot.stop();
    
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
      showDot = false;
      advancable = false;
    }
    
  }
  
  void startMovies() {
    if(mov_de != null) {
      mov_de.play();
      if(mov_de.width != 0) {
        wiggle_de[cycle] = 556-int(random(mov_de.width, 556));
        width_de[cycle] = mov_de.width;
        height_de[cycle] = mov_de.height;
      }
    }
    if(mov_en != null) {
      mov_en.play();
      if(mov_en.width != 0) {
        wiggle_en[cycle] = 556-int(random(mov_en.width, 556));
        width_en[cycle] = mov_en.width;
        height_en[cycle] = mov_en.height;
      }
    }
    if(dot != null) dot.play();
    showDot = true;
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
