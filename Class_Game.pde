/*
  Game class, main gameHandler
 */
class Game {
  /*creates instances for Pacman and 4 Ghosts (ghosts need to be updated)*/
  //will be Initialized in setAllStartPosition()
  boolean rendered = false;
  Pacman player;

  Ghost[] ghosts;


  int playerScore=0;
  boolean bootup=true;
  int ghost_default_position[]= new int[2];

  /*delay handler. movement every 200ms*/
  int mil=0, mil3=0, mil4=0, frMil=0;
  int GLOBALDELAY=250;
  int DEFAULT_GHOSTDELAY=300;
  int FRIGHTENED_TIME=10000;

  int widthScale, heightScale;


  int frameRate;
  int oldFrames=0;
  int frameCnt=0;
  /*map which will be rendered
    -currently: square:25x25:sym_001.bmp -Felix*/
    int map[][] = {
    	{1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,},
    	{1,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,},
    	{1,2,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,0,1,2,1,2,1,2,1,1,1,2,1,1,1,1,1,1,1,2,1,1,1,1,2,1,},
    	{1,2,1,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,0,0,1,2,1,2,1,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,1,2,1,},
    	{1,2,1,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,1,0,4,1,2,1,2,1,2,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,2,1,},
    	{1,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,1,1,1,1,2,1,2,2,2,2,2,2,2,1,2,1,2,2,2,2,2,2,2,2,1,2,1,},
    	{1,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,1,1,1,1,1,2,1,2,1,2,1,1,2,1,1,1,2,1,2,1,},
    	{1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,2,2,2,2,2,2,2,1,2,1,2,1,2,2,2,2,2,2,1,2,1,2,1,},
    	{0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,2,1,2,1,2,1,2,1,2,1,2,1,1,1,1,2,1,2,1,2,2,2,0,},
    	{1,2,1,1,1,1,1,2,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,2,1,2,2,2,1,2,1,2,1,2,1,2,1,2,2,2,2,2,2,1,2,1,2,1,1,1,},
    	{1,2,2,2,2,2,2,2,1,2,2,2,1,2,2,2,1,2,2,2,1,2,2,2,1,2,1,1,1,2,1,2,1,2,1,2,1,1,1,1,1,2,1,1,2,1,2,2,2,1,},
    	{1,1,1,2,1,2,1,1,1,2,1,2,1,2,1,2,2,2,1,2,2,2,1,1,1,2,1,2,2,2,1,2,1,2,2,2,2,2,2,2,2,2,1,1,2,1,2,1,2,1,},
    	{1,2,2,2,2,2,2,2,1,2,1,2,1,2,1,1,1,1,1,1,1,1,1,2,2,2,1,2,1,1,1,2,1,1,1,2,1,1,1,1,1,2,1,2,2,2,2,1,2,1,},
    	{1,2,1,1,1,1,1,2,1,2,1,2,1,2,1,2,2,2,2,2,2,2,1,2,1,1,1,2,1,2,2,2,2,2,1,2,1,2,2,2,1,2,1,2,1,1,1,1,2,1,},
    	{1,2,1,2,2,2,1,2,1,2,1,2,1,2,1,2,1,1,1,1,1,2,1,2,1,2,2,2,1,2,1,1,1,2,1,2,1,2,1,2,2,2,1,2,2,2,2,1,2,1,},
    	{1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,2,2,1,2,1,2,1,2,1,2,1,2,2,2,1,2,2,2,1,2,1,1,1,1,1,1,2,1,2,1,2,1,},
    	{1,2,1,2,1,2,2,2,1,2,2,2,1,2,2,2,1,2,1,2,1,2,2,2,1,2,1,2,1,2,1,2,1,1,1,1,1,2,2,1,2,2,2,1,2,1,2,1,2,1,},
    	{1,2,2,2,1,2,1,1,1,1,2,1,1,2,1,2,2,1,1,2,1,2,1,2,2,2,1,2,1,2,2,2,2,2,2,2,1,1,2,1,2,1,2,2,2,1,2,1,2,1,},
    	{1,2,1,2,2,2,1,2,2,2,2,1,1,2,1,1,2,2,1,2,1,2,1,2,1,2,1,2,1,1,1,1,1,1,1,2,2,1,2,1,2,1,2,1,2,1,2,2,2,1,},
    	{1,2,2,1,1,1,1,2,1,1,1,1,2,2,2,1,1,2,1,2,2,2,1,2,1,2,1,2,2,2,2,2,2,1,1,1,2,1,2,1,2,1,2,1,2,1,1,1,2,1,},
    	{1,2,2,1,1,1,1,2,2,2,2,1,2,1,2,2,1,2,1,2,1,1,1,2,1,2,2,2,1,1,2,1,2,1,1,1,2,1,2,2,2,1,2,1,2,2,2,1,2,1,},
    	{1,1,2,2,2,2,2,2,1,1,2,2,2,1,1,2,2,2,1,2,2,2,2,2,1,1,2,1,1,1,2,1,2,2,2,1,2,2,2,1,2,2,2,1,2,1,2,1,2,1,},
    	{1,2,2,1,2,1,1,1,1,1,1,1,2,1,1,2,1,1,1,2,1,1,1,1,1,1,2,1,2,1,2,1,1,1,2,1,2,1,2,1,1,1,1,1,2,1,2,1,2,1,},
    	{1,2,1,1,2,2,2,2,1,1,2,2,2,1,2,2,1,2,2,2,1,2,2,2,2,2,2,1,2,1,2,2,2,1,2,1,2,1,2,2,2,2,2,2,2,1,2,1,2,1,},
    	{1,2,1,2,2,1,1,2,2,2,2,1,1,1,2,1,1,2,1,1,1,2,1,2,1,1,2,1,2,1,1,1,2,1,2,2,2,1,1,1,1,1,2,1,1,1,2,1,2,1,},
    	{1,2,1,2,1,1,1,2,1,1,1,1,1,2,2,2,1,2,1,1,1,2,1,2,1,1,2,1,2,1,1,1,2,1,1,2,1,1,1,2,2,2,2,1,1,2,2,1,2,1,},
    	{1,2,1,2,1,2,2,2,2,2,2,2,1,2,1,2,1,2,2,2,1,2,1,2,2,2,2,2,2,1,2,2,2,1,2,2,1,2,2,2,1,1,2,2,2,2,1,1,2,1,},
    	{1,2,1,2,1,2,1,1,1,1,1,2,1,2,1,2,1,1,1,2,1,2,1,2,1,1,1,1,1,1,2,1,1,1,2,1,1,2,1,1,1,1,1,1,1,2,1,2,2,1,},
    	{1,2,1,2,1,2,1,2,2,2,1,2,2,2,1,2,2,2,1,2,1,1,1,2,1,1,2,2,2,2,2,1,2,2,2,1,1,2,2,2,1,1,2,2,2,2,2,2,1,1,},
    	{1,2,1,2,2,2,1,2,1,2,2,2,1,2,1,1,1,2,1,2,1,1,2,2,2,1,2,1,1,1,2,1,2,1,2,2,1,2,1,2,2,2,2,1,1,1,1,2,2,1,},
    	{1,2,1,1,1,2,1,2,1,2,1,2,1,2,1,1,1,2,2,2,2,2,2,1,2,1,2,1,2,2,2,1,2,1,1,2,2,2,1,1,1,1,2,1,1,1,1,2,2,1,},
    	{1,2,2,2,1,2,1,2,1,2,1,2,1,2,2,1,1,1,1,1,1,1,2,1,2,1,2,1,2,1,2,1,2,2,1,1,2,1,1,2,2,2,2,1,2,2,2,1,2,1,},
    	{1,2,1,2,1,2,2,2,1,2,1,2,1,1,3,2,2,2,2,2,2,1,2,1,2,2,2,1,2,1,2,1,1,2,2,1,2,1,1,2,1,1,1,1,2,1,2,2,2,1,},
    	{1,2,1,2,1,2,1,2,2,2,1,2,2,1,1,1,1,1,2,1,2,1,2,1,2,1,2,2,2,1,2,1,2,1,2,2,2,1,2,2,2,1,2,2,2,1,2,1,2,1,},
    	{1,2,1,2,1,2,1,1,1,1,1,1,2,1,2,2,2,1,2,2,2,1,2,1,2,1,2,1,2,1,2,2,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,},
    	{1,2,1,2,2,2,2,1,2,2,2,1,2,1,2,1,2,1,1,1,2,1,2,2,2,1,2,1,2,1,1,1,1,1,2,1,2,1,2,1,2,1,2,1,2,2,2,1,2,1,},
    	{1,2,1,1,1,1,2,1,2,1,2,2,2,1,2,1,2,2,2,2,2,1,2,1,1,1,2,1,2,2,2,2,2,2,2,1,2,1,2,1,2,1,2,1,1,1,1,1,2,1,},
    	{1,2,1,2,2,2,2,1,2,1,1,1,1,1,2,1,1,1,2,1,1,1,2,1,2,2,2,1,1,1,1,1,1,1,1,1,2,1,2,1,2,1,2,2,2,2,2,2,2,1,},
    	{1,2,1,2,1,2,1,1,2,2,2,2,2,2,2,2,2,1,2,1,2,2,2,1,2,1,1,1,2,2,2,1,2,2,2,1,2,1,2,1,2,1,1,1,2,1,2,1,1,1,},
    	{1,2,2,2,1,2,1,1,2,1,1,1,1,1,2,1,2,1,2,1,2,1,1,1,2,1,2,2,2,1,2,2,2,1,2,2,2,1,2,2,2,1,2,2,2,2,2,2,2,1,},
    	{1,1,1,2,1,2,1,2,2,2,2,2,2,1,2,1,2,1,2,1,2,1,2,2,2,1,2,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,2,1,1,1,1,1,2,1,},
    	{0,2,2,2,1,2,1,2,1,1,1,1,2,1,2,1,2,1,2,1,2,1,2,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,},
    	{1,2,1,2,1,2,2,2,2,2,2,1,2,1,2,1,2,2,2,2,2,2,2,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,},
    	{1,2,1,2,1,1,1,2,1,1,2,1,2,1,2,1,1,1,1,1,1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,1,},
    	{1,2,1,2,2,2,2,2,2,2,2,1,2,1,2,2,2,2,2,2,2,1,2,1,1,1,1,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,2,1,},
    	{1,2,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,2,1,2,1,2,1,5,0,1,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,1,2,1,},
    	{1,2,1,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,1,2,1,2,1,0,0,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,1,2,1,},
    	{1,2,1,1,1,1,2,1,1,1,1,1,1,1,2,1,1,1,2,1,2,1,2,1,0,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,2,1,},
    	{1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,3,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,1,},
    	{1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,},
    };

  int teleporters[][][] = {};
  /*color codes for different map features*/
  color colorMap[]= {color(0, 0, 0), color(0, 0, 255), color(200, 200, 100), color(200, 200, 100)};

  /*
  0 = empty
   1 = wall
   2 = pellets
   3 = power pellets (same color as coins)
   4 = ghost (only for return value in checkCollision)
   5 = pacman (only for init)

   INFO: this.map.length ist die Höhe, this.map[0].length die Breite
   Wir sollten noch mehr Kommentare machen
   */


  Game() {
    /*DEBUG*/
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: Initialized gameHandler with map size["+this.map[0].length+"|"+this.map.length+"]");
    this.frameCnt=millis;
    findTeleporters();
    setAllStartPosition(); //also creates instances

    this.widthScale = (width/this.map[0].length);
    this.heightScale = (height/this.map.length);
    if(width/height != this.map[0].length/this.map.length) debugoutput.println(hour()+":"+minute()+":"+second()+": "+"############\nMAP RATIO IS NOT MATCHING SCREEN RATIO\n############\n");

    /*
      for (int i =0; i<this.teleporters.length; i++) {
        print("teleporter1:"+teleporters[i][0][0]+","+teleporters[i][0][1]+"teleporter2:"+teleporters[i][1][0]+","+teleporters[i][1][1]+"\n");
    */
  }



  void renderNonPlayableScene() {
    /*DEBUG*/
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: Rendering nonplayableScene");

    /*here we need to decide if the game is booting up or already over*/
    /*BootScreen*/
    if(this.bootup) {
      this.bootupScreen();
    }
    else if (player.lives > 1){
      if (mil3 == 0)
        mil3 = millis;
      this.smartRender();
      if (millis-mil3 > 2000)
        this.reset();
    }
      /*EndScreen*/
    else
      this.endScreen();



  }

  /*renders the whole map*/
  void renderMap() {

    /*DEBUG*/
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: Rendering map:");

    background(0);

    //one box=100*100 pixel --UPDATE: ceil() for screen fill


    /*loop through x and y axis*/
    for (int i=0; i<this.map[0].length; i++)
    {
      for (int j=0; j<this.map.length; j++)
      {
        //replace by image source and scale
        fill(this.colorMap[map[j][i]]);//fill changes the colour for all draw functions
        if (this.map[j][i]==2) ellipse(i*this.widthScale+this.widthScale/2, j*this.heightScale+this.heightScale/2, this.widthScale/2, this.heightScale/2);
        else if (this.map[j][i]==3) ellipse (i*this.widthScale+this.widthScale/2, j*this.heightScale+this.heightScale/2, this.widthScale, this.heightScale);
        else rect(i*this.widthScale, j*this.heightScale, this.widthScale, this.heightScale);//rect draws a rect you idiot
      }
    }
  }

  void smartRender(){


    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: smart Render:");
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"\tPacman position: "+player.position[0]+" "+player.position[1]);

    for (int i=0; i<this.ghosts.length;i++){
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"\t"+ghosts[i].name+" position: "+ghosts[i].position[0]+" "+ghosts[i].position[1]);
    }


    //frameRate
    if(millis-this.frameCnt>500) {
      this.frameRate=(frameCount-this.oldFrames)*2;
      this.oldFrames=frameCount;
      this.frameCnt=millis;
    }

    //first render here to avoid leftovers
    if (!this.rendered){
      this.rendered = true;
      this.renderMap();
    }

    int[][] squaresToUpdate = {
        player.oldPosition, player.renderPosition, player.position
      };

    for (int i=0; i<this.ghosts.length; i++){
      squaresToUpdate = (int[][]) append(squaresToUpdate, ghosts[i].oldPosition);
      squaresToUpdate = (int[][]) append(squaresToUpdate, ghosts[i].renderPosition);
      squaresToUpdate = (int[][]) append(squaresToUpdate, ghosts[i].position);
    }


    for (int i = 0; i< squaresToUpdate.length; i++){

      fill(this.colorMap[0]);
      rect(this.widthScale*squaresToUpdate[i][0], this.heightScale*squaresToUpdate[i][1], this.widthScale, this.heightScale);

      if (this.map[squaresToUpdate[i][1]][squaresToUpdate[i][0]] == 2){
        fill(this.colorMap[2]);
        ellipse(this.widthScale*squaresToUpdate[i][0] + this.widthScale/2, this.heightScale*squaresToUpdate[i][1] +this.heightScale/2 , this.widthScale/2, this.heightScale/2);
      }
      else if (this.map[squaresToUpdate[i][1]][squaresToUpdate[i][0]]==3){
        fill(this.colorMap[3]);
        ellipse(this.widthScale*squaresToUpdate[i][0]+this.widthScale/2, this.heightScale*squaresToUpdate[i][1]+this.heightScale/2, this.widthScale, this.heightScale);
      }
    }

    this.updateSmoothPosition();


    /*SmartText pt1*/
    //draw playerScore
    //clear background (factor width/47,2 * letterNum to get pixels and then this divided by widthScale : (width/47,2 * letterNum)/widthScale for the number of map indices to update )

    //score: (12 Letters for: "Score: xxxxx")
    int score_clear_width = (int)((width/47.2f*12)/widthScale+0.5);
    int score_clear_pos[] = {0,score_clear_width,0};
    //lives: (8 Letters for: "Lives: x")
    int lives_clear_width = (int)((width/47.2f*8)/widthScale+0.5);
    int lives_clear_pos[] = {this.map[0].length-lives_clear_width,this.map[0].length,0};
    //status: (8 Letters for: "[status]" -> *4 because half the size)
    int status_clear_width = (int)((width/47.2f*4)/widthScale+0.5);
    int status_clear_pos[] = {0,status_clear_width,this.map.length-1};
    //framerate: (9 Letters for: "FPS: xxxx" -> *5 because half the size)
    int framerate_clear_width = (int)((width/47.2f*4)/widthScale+0.5);
    int framerate_clear_pos[] = {this.map[0].length-framerate_clear_width-1,this.map[0].length,this.map.length-1};

    //list of positions to clear (only horizontal clear)
    int toClear[][] = {score_clear_pos, lives_clear_pos, status_clear_pos};

    if(DEBUGMODE) toClear = (int[][])append(toClear, framerate_clear_pos);

    for(int i=0; i<toClear.length; i++) {
      for(int j=toClear[i][0]; j<toClear[i][1]; j++) {
        fill(this.colorMap[map[toClear[i][2]][j]]);//fill changes the colour for all draw functions
        if (this.map[toClear[i][2]][j]==2) ellipse(i*this.widthScale+this.widthScale/2, j*this.heightScale+this.heightScale/2, this.widthScale/2, this.heightScale/2);
        else rect(j*this.widthScale, toClear[i][2]*this.heightScale, this.widthScale, this.heightScale);//rect draws a rect you idiot
      }
    }




    fill(player.pacmanColor); //fill changes the colour for all draw functions

    switch(player.renderDirection){
      case"right":image(player.right, player.renderPosition[0]*this.widthScale+player.renderFactor[0], player.renderPosition[1]*this.heightScale+player.renderFactor[1], this.widthScale, this.heightScale);break;
      case"left":image(player.left, player.renderPosition[0]*this.widthScale+player.renderFactor[0], player.renderPosition[1]*this.heightScale+player.renderFactor[1], this.widthScale, this.heightScale);break;
      case"up":image(player.up, player.renderPosition[0]*this.widthScale+player.renderFactor[0], player.renderPosition[1]*this.heightScale+player.renderFactor[1], this.widthScale, this.heightScale);break;
      case"down":image(player.down, player.renderPosition[0]*this.widthScale+player.renderFactor[0], player.renderPosition[1]*this.heightScale+player.renderFactor[1], this.widthScale, this.heightScale);break;
      default: break;
    }



    for (int i=0; i<this.ghosts.length; i++){
      if (ghosts[i].isAlive){
        fill(ghosts[i].ghostColor); //fill changes the colour for all draw functions
        if(ghosts[i].frightened) fill(ghosts[i].ghostColorF); //fill changes the colour for all draw functions
        rect(ghosts[i].renderPosition[0]*this.widthScale+ghosts[i].renderFactor[0], ghosts[i].renderPosition[1]*this.heightScale+ghosts[i].renderFactor[1], this.widthScale, this.heightScale);//rect draws a rect you idiot
      }
    }

    /*SmartText pt2*/
    fill(255);
    textSize(this.heightScale);
    text("Score: "+this.playerScore, width/250, this.heightScale-height/200);
    text("Lives:"+player.lives, width-this.heightScale*3.125-2, this.heightScale-height/200);
    textSize(this.heightScale/2);
    if(DEBUGMODE)
    text("FPS: "+this.frameRate, width-this.heightScale*2, height-height/500);
    if (player.isAlive) fill(0, 255, 0);
    else fill(255, 0, 0);
    if(frMil!=0) fill(255,255,0);
    text("[status]", 2, height-height/500);

  }



  void bootupScreen() {
    this.smartRender();
    fill(255);
    textFont(createFont("Arial Bold", 18));
    textSize(50);
    textAlign(CENTER);
    text("Pacman",width/2, height/2);
    textAlign(LEFT);
    textFont(createFont("Arial", 18));
    if(mil4==0) mil4=millis;

    if(millis-mil4>4000) {
      textFont(createFont("Arial", 18));
      player.isAlive=true;
      this.rendered = false;
      this.bootup=false;
    }
  }
  void endScreen(){
    background(0);

  }


  void findTeleporters() {

    for (int i=0; i<this.map[0].length; i++) {
      if (this.map[0][i]!= 1 && this.map[this.map.length-1][i]!=1) {
        int[][] coords = {{i, 0}, {i, this.map.length-1}};
        this.teleporters = (int[][][]) append(this.teleporters, coords);
      }
    }

    for (int i=0; i<this.map.length; i++) {
      if (this.map[i][0]!= 1 && this.map[i][this.map[0].length-1]!=1) {
        int[][] coords = {{0, i}, {this.map[0].length-1, i}};
        this.teleporters = (int[][][]) append(this.teleporters, coords);
      }
    }
  }

  void setAllStartPosition() {
    this.ghost_default_position[0] = -1;
    this.ghost_default_position[1] = -1;
    int pac_default_position[] = {-1,-1};
      //search map for "4"
      for (int i=0; i<this.map[0].length; i++) {
        for(int j=0; j<this.map.length; j++) {
          if(this.map[j][i]==4) {
            this.map[j][i]=0;
            this.ghost_default_position[0] = i;
            this.ghost_default_position[1] = j;
          }
          if(this.map[j][i]==5) {
            this.map[j][i]=0;
            pac_default_position[0] = i;
            pac_default_position[1] = j;
          }
        }
      }
      if(this.ghost_default_position[0]==-1||this.ghost_default_position[1]==-1) {
        debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: Couldn't locate ghost position, quitting");
        exit();
      }
      if(pac_default_position[0]==-1||pac_default_position[1]==-1) {
        debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: Couldn't locate pacman position, quitting");
        exit();
      }

      this.player = new Pacman(pac_default_position);


      ghosts = new Ghost[]{new Blinky(this.ghost_default_position,this.DEFAULT_GHOSTDELAY), new Pinky(this.ghost_default_position,this.DEFAULT_GHOSTDELAY), new Inky(this.ghost_default_position,this.DEFAULT_GHOSTDELAY), new Kinky(this.ghost_default_position,this.DEFAULT_GHOSTDELAY)};
  }




  /*movement control and collision check for ghosts*/
  void move(boolean keyMap[]) {

    /*update new input key immediately*/
    player.direction=keyMap['w']?"up":keyMap['a']?"left":keyMap['s']?"down":keyMap['d']?"right":player.direction;


    for(int j=0; j<this.ghosts.length; j++) {
      if(ghosts[j].mayMove()==0) continue;

      //move ghost
      ghosts[j].oldPosition = ghosts[j].renderPosition;
      if(ghosts[j] instanceof Blinky)
        ghosts[j].makeMove(player.position.clone());
      else if(ghosts[j] instanceof Inky)
        ghosts[j].makeMove();
      else if(ghosts[j] instanceof Pinky)
        ghosts[j].makeMove(player.position.clone(), player.oldDirection);
      else if(ghosts[j] instanceof Kinky)
        ghosts[j].makeMove(player.position.clone(), player.oldDirection);
      else
        print("ghost", ghosts[j].name,"didnt move");

      int collision=this.checkCollision(player.position);

      //check if ghost is on Pacman
      /*End the game*/
      if (collision>=4) {
        while(collision>=4) {
          //if he colides with a ghost we want to check if he has a power up, else he dies (powerups still have to be added to the game)
          if(!ghosts[collision-4].frightened) {
            player.isAlive=false;
            return;
          }
          else {
            this.playerScore+=200;
            ghosts[collision-4].kill();
          }
          collision=this.checkCollision(player.position);
        }
      }
      debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: Tracked no collision with ghosts");
    }



    //every 500ms
    if ((mil==0&&player.direction!="")||millis-mil>=GLOBALDELAY) {
      /*reset counter*/
      mil=millis;


      /*DEBUG*/
      debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: update movement");


      /*copy position*/
      int playerNextPos[] = player.position.clone();

      /*calculate next coordinate*/
      switch(player.direction) {
        case "up":
          playerNextPos[1]--;
          playerNextPos[1]= playerNextPos[1]<0?this.map.length-1:playerNextPos[1];
          break;
        case "down":
          playerNextPos[1]++;
          playerNextPos[1] %= this.map.length;
          break;
        case "left":
          playerNextPos[0]--;
          playerNextPos[0]= playerNextPos[0]<0?this.map[0].length-1:playerNextPos[0];
          break;
        case "right":
          playerNextPos[0]++;
          playerNextPos[0] %= this.map[0].length;
          break;
        default:
          break;
      }
      /*get collision*/
      int collision = this.checkCollision(playerNextPos);

      /*DEBUG*/
      debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: Tracked collision: "+collision);

      //check for collision and afterwards move
      /*Ghost collision*/
      if (collision>=4) {
        while(collision>=4) {
          //if he colides with a ghost we want to check if he has a power up, else he dies (powerups still have to be added to the game)
          if(!ghosts[collision-4].frightened) {
            player.isAlive=false;
            return;
          }
          else {
            this.playerScore+=200;
            ghosts[collision-4].kill();
          }
          collision=this.checkCollision(player.position);
        }
      }
      /*wall collision -> ignore key*/
      if (collision==1) {
        /*DEBUG*/
        debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: reverting input to last valid movement");
        /*restore previous valid direction to cancel out current one and move*/


        /*calculate next position again and check for collision*/
        playerNextPos=player.position.clone();

        switch(player.oldDirection) {
          case "up":
            playerNextPos[1]--;
            playerNextPos[1]= playerNextPos[1]<0?this.map.length-1:playerNextPos[1];
            break;
          case "down":
            playerNextPos[1]++;
            playerNextPos[1] %= this.map.length;
            break;
          case "left":
            playerNextPos[0]--;
            playerNextPos[0]= playerNextPos[0]<0?this.map[0].length-1:playerNextPos[0];
            break;
          case "right":
            playerNextPos[0]++;
            playerNextPos[0] %= this.map[0].length;
            break;
          default:
            break;
        }
        collision = this.checkCollision(playerNextPos);
        /*if it's not a wall, move*/
        if (collision>=4) {
          while(collision>=4) {
            //if he colides with a ghost we want to check if he has a power up, else he dies (powerups still have to be added to the game)
            if(!ghosts[collision-4].frightened) {
              player.isAlive=false;
              return;
            }
            else {
              this.playerScore+=200;
              ghosts[collision-4].kill();
            }
            collision=this.checkCollision(player.position);
          }
        }
        if (collision!=1) {
          this.updatePosition(playerNextPos);
        }
      }

      /*no wall collision -> move*/
      else if (collision!=1) {
        /*DEBUG*/
        debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: Moving with new valid input");
        /*update position*/
        this.updatePosition(playerNextPos);
        /*update last valid direction*/

        player.renderDirection=player.direction;
        player.oldDirection=player.direction;
      }

      /*
        COIN
      */
      collision=this.map[this.player.position[1]][this.player.position[0]];
      if (collision==2) {
        this.playerScore++;
        map[player.position[1]][player.position[0]]=0;
      }
      /*
        POWER PALLET
      */
      else if(collision==3) {
        this.playerScore+=10;
        map[player.position[1]][player.position[0]]=0;
        for(int i=0; i<ghosts.length; i++) {
          ghosts[i].frightened=true;
        }
        frMil=millis;
      }



      if(FRIGHTENED_TIME>0&&frMil!=0&&millis-frMil>=FRIGHTENED_TIME) {
        for(int i=0; i<ghosts.length; i++) {
          ghosts[i].frightened=false;
        }
        frMil=0;
      }

    }
  }

  void updatePosition(int[] playerNextPos){
    /*update position*/

    player.oldPosition = player.renderPosition.clone();

    player.resetSmooth();

    player.position=playerNextPos.clone();

  }



  void updateSmoothPosition() {

    /*UPDATE PLAYER*/


    float delay=0;




      switch(player.renderDirection) {
        case "up":player.renderFactor[1]=-1*this.heightScale*((float)(millis-player.renderTime)/this.GLOBALDELAY);break;
        case "down":player.renderFactor[1]=this.heightScale*((float)(millis-player.renderTime)/this.GLOBALDELAY);break;
        case "left":player.renderFactor[0]=-1*this.widthScale*((float)(millis-player.renderTime)/this.GLOBALDELAY);break;
        case "right":player.renderFactor[0]=this.widthScale*((float)(millis-player.renderTime)/this.GLOBALDELAY);break;
      }
      player.renderFactor[0]=player.renderFactor[0]<(-this.heightScale)?-this.heightScale:player.renderFactor[0]>(this.heightScale)?this.heightScale:player.renderFactor[0];
      player.renderFactor[1]=player.renderFactor[1]<(-this.widthScale)?-this.widthScale:player.renderFactor[1]>(this.widthScale)?this.widthScale:player.renderFactor[1];


    /*UPDATE GHOSTS*/

    for (int i = 0; i<this.ghosts.length;i++){
      if(!ghosts[i].isAlive) continue;
      switch(ghosts[i].renderDirection) {
        case "up":ghosts[i].renderFactor[1]=-1*this.heightScale*((float)(millis-this.ghosts[i].renderTime)/this.ghosts[i].GHOSTDELAY);break;
        case "down":ghosts[i].renderFactor[1]=this.heightScale*((float)(millis-this.ghosts[i].renderTime)/this.ghosts[i].GHOSTDELAY);break;
        case "left":ghosts[i].renderFactor[0]=-1*this.widthScale*((float)(millis-this.ghosts[i].renderTime)/this.ghosts[i].GHOSTDELAY);break;
        case "right":ghosts[i].renderFactor[0]=this.widthScale*((float)(millis-this.ghosts[i].renderTime)/this.ghosts[i].GHOSTDELAY);break;
      }

      ghosts[i].renderFactor[0]=ghosts[i].renderFactor[0]<(-this.heightScale)?-this.heightScale:ghosts[i].renderFactor[0]>(this.heightScale)?this.heightScale:ghosts[i].renderFactor[0];
      ghosts[i].renderFactor[1]=ghosts[i].renderFactor[1]<(-this.widthScale)?-this.widthScale:ghosts[i].renderFactor[1]>(this.widthScale)?this.widthScale:ghosts[i].renderFactor[1];

    }


  }




  /*returns map marker at coordinate*/
  int checkCollision(int[] coords) {

    for (int i = 0; i<this.ghosts.length;i++){

    if (ghosts[i].position[0]==coords[0]&&ghosts[i].position[1]==coords[1]&&ghosts[i].isAlive) return 4+i;

    }
    return this.map[coords[1]][coords[0]];
  }


  void reset(){
    this.rendered = false;

    ghosts = new Ghost[]{new Blinky(this.ghost_default_position,this.DEFAULT_GHOSTDELAY), new Pinky(this.ghost_default_position,this.DEFAULT_GHOSTDELAY), new Inky(this.ghost_default_position,this.DEFAULT_GHOSTDELAY), new Kinky(this.ghost_default_position,this.DEFAULT_GHOSTDELAY)};

    this.mil=0;
    this.mil3 = 0;
    this.mil4 = 0;

    this.player.reset();
    this.player.lives--;
    this.frameCnt=millis;

  }
}
