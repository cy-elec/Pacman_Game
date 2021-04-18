/*
  Game class, main gameHandler
 */

class Game {
  /*creates instances for Pacman and 4 Ghosts (ghosts need to be updated)*/
  //will be Initialized in setAllStartPosition()
  Pacman player;
  Blinky Ghost_Blinky;
  Pinky Ghost_Pinky;
  Inky Ghost_Inky;
  Clyde Ghost_Clyde;

  int playerScore=0;
  boolean bootup=true;
  int ghost_default_position[]= new int[2];

  /*delay handler. movement every 200ms*/
  int mil=0, mil2=0, mil3 = 0, mil4=0;
  int GLOBALDELAY=250;
  int GHOSTDELAY=300;


  /*map which will be rendered
    -currently: square:25x25:sym_001.bmp -Felix*/
  int map[][] = {
  	{1,0,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,0,1,},
  	{1,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,1,},
  	{1,2,1,1,2,1,2,1,1,1,1,1,2,1,1,1,1,1,2,1,2,1,1,2,1,},
  	{1,2,1,1,2,1,2,1,3,2,2,1,2,1,2,2,3,1,2,1,2,1,1,2,1,},
  	{1,2,2,2,2,1,2,1,1,1,2,1,2,1,2,1,1,1,2,1,2,2,2,2,1,},
  	{1,1,1,1,2,1,2,2,1,1,2,1,2,1,2,1,1,2,2,1,2,1,1,1,1,},
  	{0,2,2,1,2,1,1,2,1,2,2,2,2,2,2,2,1,2,1,1,2,1,2,2,0,},
  	{1,1,2,2,2,2,2,2,2,2,1,1,2,1,1,2,2,2,2,2,2,2,2,1,1,},
  	{1,2,2,1,1,1,1,2,1,2,1,0,0,0,1,2,1,2,1,1,1,1,2,2,1,},
  	{1,2,1,1,1,2,2,2,1,2,1,0,4,0,1,2,1,2,2,2,1,1,1,2,1,},
  	{1,2,1,2,1,1,1,1,1,2,1,1,1,1,1,2,1,1,1,1,1,2,1,2,1,},
  	{1,2,1,2,2,2,2,2,2,2,2,1,2,1,2,2,2,2,2,2,2,2,1,2,1,},
  	{1,2,1,2,1,1,1,1,2,1,2,1,2,1,2,1,2,1,1,1,1,2,1,2,1,},
  	{1,2,2,2,2,2,2,2,2,1,2,1,2,1,2,1,2,2,2,2,2,2,2,2,1,},
  	{1,2,1,1,1,1,2,1,2,1,1,1,2,1,1,1,2,1,2,1,1,1,1,2,1,},
  	{1,2,1,3,1,1,2,1,2,2,2,2,2,2,2,2,2,1,2,1,1,3,1,2,1,},
  	{1,2,2,2,1,2,2,1,1,1,2,1,2,1,2,1,1,1,2,2,1,2,2,2,1,},
  	{1,2,1,1,1,2,1,1,2,2,2,1,2,1,2,2,2,1,1,2,1,1,1,2,1,},
  	{0,2,2,2,2,2,1,2,2,1,2,1,1,1,2,1,2,2,1,2,2,2,2,2,0,},
  	{1,1,1,1,1,2,2,2,1,1,2,2,2,2,2,1,1,2,2,2,1,1,1,1,1,},
  	{1,2,2,2,1,1,1,2,1,1,2,1,1,1,2,1,1,2,1,1,1,2,2,2,1,},
  	{1,2,1,2,2,2,2,2,2,2,2,1,5,1,2,2,2,2,2,2,2,2,1,2,1,},
  	{1,2,1,2,1,1,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,2,1,2,1,},
  	{1,2,1,2,2,2,2,2,2,1,2,2,2,2,2,1,2,2,2,2,2,2,1,2,1,},
  	{1,0,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,0,1,},
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

    findTeleporters();
    setAllStartPosition(); //also creates instances

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
        mil3 = millis();
      this.renderMap();
      if (millis()-mil3 > 2000)
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
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"\tPacman position: "+player.position[0]+" "+player.position[1]);
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"\tBlinky position: "+Ghost_Blinky.position[0]+" "+Ghost_Blinky.position[1]);
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"\tInky position: "+Ghost_Inky.position[0]+" "+Ghost_Inky.position[1]);
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"\tPinky position: "+Ghost_Pinky.position[0]+" "+Ghost_Pinky.position[1]);
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"\tClyde position: "+Ghost_Clyde.position[0]+" "+Ghost_Clyde.position[1]);

    background(0);

    //one box=100*100 pixel --UPDATE: ceil() for screen fill
    int widthScale = (width/this.map[0].length);
    int heightScale = (height/this.map.length);

    /*loop through x and y axis*/
    for (int i=0; i<this.map[0].length; i++)
    {
      for (int j=0; j<this.map.length; j++)
      {
        //replace by image source and scale
        fill(this.colorMap[map[j][i]]);//fill changes the colour for all draw functions
        if (this.map[j][i]==2) ellipse(i*widthScale+widthScale/2, j*heightScale+heightScale/2, widthScale/2, heightScale/2);
        else rect(i*widthScale, j*heightScale, widthScale, heightScale);//rect draws a rect you idiot
      }
    }
    //print pacman
    fill(player.pacmanColor); //fill changes the colour for all draw functions
    rect(player.position[0]*widthScale, player.position[1]*heightScale, widthScale, heightScale);//rect draws a rect you idiot
    //print Blinky
    fill(Ghost_Blinky.ghostColor); //fill changes the colour for all draw functions
    rect(Ghost_Blinky.position[0]*widthScale, Ghost_Blinky.position[1]*heightScale, widthScale, heightScale);//rect draws a rect you idiot

    //draw playerScore
    fill(255);
    textSize(30);
    text("Score: "+playerScore, 5, 35);
    text("Lives:"+player.lives, 150, 35);
    textSize(20);
    if (player.isAlive) fill(0, 255, 0);
    else fill(255, 0, 0);
    text("[status]", 2, height-2);
  }


  void bootupScreen() {
    renderMap();
    fill(255);
    textFont(createFont("Arial Bold", 18));
    textSize(50);
    textAlign(CENTER);
    text("Pacman",width/2, height/2);
    textAlign(LEFT);
    textFont(createFont("Arial", 18));
    if(mil4==0) mil4=millis();

    if(millis()-mil4>4000) {
      textFont(createFont("Arial", 18));
      player.isAlive=true;
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
      this.Ghost_Blinky = new Blinky(this.ghost_default_position);
      this.Ghost_Pinky = new Pinky(this.ghost_default_position);
      this.Ghost_Inky = new Inky(this.ghost_default_position);
      this.Ghost_Clyde = new Clyde(this.ghost_default_position);
  }


  /*movement control and collision check*/
  void move(boolean keyMap[]) {
    /*update new input key immediately*/
    player.direction=keyMap['w']?"up":keyMap['a']?"left":keyMap['s']?"down":keyMap['d']?"right":player.direction;

    //every 500ms
    if(mil2==0) mil2=millis();
    if (millis()-mil2>=GHOSTDELAY) {
      mil2=millis();
      //move ghosts
      Ghost_Blinky.makeMove(player.position);

      //check if ghost is on Pacman
      /*End the game*/
      if (this.checkCollision(player.position)==4) {
        player.isAlive=false;
        return;
      };
      debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: Tracked no collision with ghosts");
    }

    //every 500ms
    if ((mil==0&&player.direction!="")||millis()-mil>=GLOBALDELAY) {
      /*reset counter*/
      mil=millis();

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
      if (collision==4) {
        //if he colides with a ghost we want to check if he has a power up, else he dies
        player.isAlive=false;
        return;
        /*END GAME*/
      }
      /*wall collision -> ignore key*/
      else if (collision==1) {
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
        if (collision!=1) {
          player.position=playerNextPos.clone();
        }
      }
      /*no wall collision -> move*/
      else if (collision!=1) {
        /*DEBUG*/
        debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: Moving with new valid input");
        /*update position*/
        player.position=playerNextPos.clone();
        /*update last valid direction*/
        player.oldDirection=player.direction;
      }

      if (collision==2) {
        playerScore++;
        map[player.position[1]][player.position[0]]=0;
      }
    }
  }

  /*returns map marker at coordinate*/
  int checkCollision(int[] coords) {
    if (Ghost_Blinky.position[0]==coords[0]&&Ghost_Blinky.position[1]==coords[1]) return 4;
    if (Ghost_Inky.position[0]==coords[0]&&Ghost_Inky.position[1]==coords[1]) return 4;
    if (Ghost_Pinky.position[0]==coords[0]&&Ghost_Pinky.position[1]==coords[1]) return 4;
    if (Ghost_Clyde.position[0]==coords[0]&&Ghost_Clyde.position[1]==coords[1]) return 4;

    return this.map[coords[1]][coords[0]];
  }


  void reset(){

    this.Ghost_Blinky = new Blinky(this.ghost_default_position);
    this.Ghost_Pinky = new Pinky(this.ghost_default_position);
    this.Ghost_Inky = new Inky(this.ghost_default_position);
    this.Ghost_Clyde = new Clyde(this.ghost_default_position);
    this.mil=0;
    this.mil2=0;
    this.mil3 = 0;
    this.mil4 = 0;

    this.player.reset();
    this.player.lives--;


  }
}
