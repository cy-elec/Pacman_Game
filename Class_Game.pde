/*
  Game class, main gameHandler
*/

class Game {
  /*creates instances for Pacman and 4 Ghosts (ghosts need to be updated)*/
  Pacman player = new Pacman();
  Blinky Ghost_Blinky = new Blinky();
  Pinky Ghost_Pinky = new Pinky();
  Inky Ghost_Inky = new Inky();
  Clyde Ghost_Clyde = new Clyde();

  int playerScore=0;
  boolean bootup=true;

  /*used for new movement control*/
  String oldDirection="";
  /*delay handler. movement every 200ms*/
  int mil=0,mil2=0;
  int GLOBALDELAY=200;
  int GHOSTDELAY=300;


  /*map which will be rendered*/
  int map[][] = {
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,1,0,1,0,1,0,0,0,0,1},
    {1,0,1,1,0,1,0,1,0,1,0,1,1,0,1},
    {1,0,1,0,0,0,0,0,0,0,0,0,1,0,1},
    {1,0,0,0,2,1,0,1,0,1,0,0,0,0,1},
    {1,0,1,1,2,1,1,1,1,1,0,1,1,0,1},
    {0,0,0,1,2,0,0,1,0,0,0,1,0,0,0},
    {1,1,1,1,2,1,1,0,1,1,0,1,1,1,1},
    {1,0,0,1,2,0,0,0,0,0,0,1,0,0,1},
    {1,0,1,1,0,1,1,1,1,1,0,1,1,0,1},
    {1,0,0,0,0,1,0,1,0,1,0,0,0,0,1},
    {1,0,1,0,0,0,0,0,0,0,0,0,1,0,1},
    {1,0,1,0,1,1,0,1,1,0,1,0,1,0,1},
    {1,0,0,0,0,1,0,1,0,0,1,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
  };
  /*color codes for different map features*/
  color colorMap[]= {color(0,0,0),color(0,0,255),color(200,200,100)};

  /*
  0 = empty
  1 = wall
  2 = coin
  3 = ghost (only for return value in checkCollision)

  INFO: this.map.length ist die Höhe, this.map[0].length die Breite
  Wir sollten noch mehr Kommentare machen
  */


  Game(){
    /*DEBUG*/
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: Initialized gameHandler with map size["+this.map[0].length+"|"+this.map.length+"]");


  }

  void renderNonPlayableScene() {
    /*DEBUG*/
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: Rendering nonplayableScene");
    background(0);

    /*here we need to decide if the game is booting up or already over*/
    /*BootScreen*/
    if(this.bootup) {
      //start Game
      this.bootup=false;
      player.isAlive=true;
    }
    /*EndScreen*/
    else {

    }
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
    for(int i=0; i<this.map[0].length; i++)
    {
      for(int j=0; j<this.map.length; j++)
      {
        //replace by image source and scale
        fill(this.colorMap[map[j][i]]);//fill changes the colour for all draw functions
        if(this.map[j][i]==2) ellipse(i*widthScale+widthScale/2, j*heightScale+heightScale/2, widthScale, heightScale);
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
    text("Score: "+playerScore,5,35);
    textSize(20);
    if(player.isAlive) fill(0,255,0);
    else fill(255,0,0);
    text("[status]",2,height-2);
  }

  /*movement control and collision check*/
  void move(boolean keyMap[]) 	// diese funktion verändert die position von pacman
  {
    /*update new input key immediately*/
    player.direction=keyMap['w']?"up":keyMap['a']?"left":keyMap['s']?"down":keyMap['d']?"right":player.direction;

    //every 500ms
    if(mil2==0||millis()-mil2>=GHOSTDELAY) {
      mil2=millis();
      //move ghosts
      Ghost_Blinky.makeMove(player.position);

      //check if ghost is on Pacman
      /*End the game*/
      if(this.checkCollision(player.position)==3) { player.isAlive=false; return;};
      debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: Tracked no collision with ghosts");
    }

    //every 500ms
    if((mil==0&&player.direction!="")||millis()-mil>=GLOBALDELAY) {
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
        default:break;
      }
      /*get collision*/
      int collision = this.checkCollision(playerNextPos);

      /*DEBUG*/
      debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: Tracked collision: "+collision);

      //check for collision and afterwards move
      /*Ghost collision*/
      if(collision==3) {
        //if he colides with a ghost we want to check if he has a power up, else he dies
        player.isAlive=false;
        return;
        /*END GAME*/
      }
      /*wall collision -> ignore key*/
      else if(collision==1) {
        /*DEBUG*/
        debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: reverting input to last valid movement");
        /*restore previous valid direction to cancel out current one and move*/


        /*calculate next position again and check for collision*/
        playerNextPos=player.position.clone();
        switch(oldDirection) {
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
          default:break;
        }
        collision = this.checkCollision(playerNextPos);
        /*if it's not a wall, move*/
        if(collision!=1){
          player.position=playerNextPos.clone();
        }
      }
      /*no wall collision -> move*/
      else if(collision!=1){
        /*DEBUG*/
        debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Game: Moving with new valid input");
        /*update position*/
        player.position=playerNextPos.clone();
        /*update last valid direction*/
        oldDirection=player.direction;
      }

      if(collision==2) {
        playerScore++;
        map[player.position[1]][player.position[0]]=0;
      }

    }
  }
  /*returns map marker at coordinate*/
  int checkCollision(int[] coords){
    if(Ghost_Blinky.position[0]==coords[0]&&Ghost_Blinky.position[1]==coords[1]) return 3;
    if(Ghost_Inky.position[0]==coords[0]&&Ghost_Inky.position[1]==coords[1]) return 3;
    if(Ghost_Pinky.position[0]==coords[0]&&Ghost_Pinky.position[1]==coords[1]) return 3;
    if(Ghost_Clyde.position[0]==coords[0]&&Ghost_Clyde.position[1]==coords[1]) return 3;

    return this.map[coords[1]][coords[0]];
  }
}
