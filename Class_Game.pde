class Game {
  Pacman player = new Pacman();
  Ghost[] Ghosts = new Ghost[2];

  String oldDirection="";
  int mil =0, GLOBALDELAY=300;

  int map[][] = {{1,1,1,1,1,1,1,1,1,1}, {1,0,0,0,0,0,0,0,0,1}, {1,0,0,0,0,0,0,0,0,1}, {1,0,0,0,0,0,0,0,0,1}, {1,0,0,0,0,0,0,0,0,1}, {0,0,0,0,0,0,0,0,0,0}, {1,0,0,0,0,0,0,0,0,1}, {1,0,0,0,0,0,0,0,0,1}, {1,0,0,0,0,0,0,0,0,1}, {1,0,0,0,0,0,0,0,0,1}, {1,1,1,1,1,1,1,1,1,1,1}};
  color colorMap[]= {color(0,0,0),color(0,0,255),color(255,0,255),color(200,200,100),color(255,0,255)};
  color pacmanColor = color(255, 255, 0);
  /*
  0 = empty
  1 = wall
  2 = Ghost
  3 = coin
  4 = coin + Ghost

  INFO: this.map.length ist die Höhe, this.map[0].length die Breite
  Wir sollten noch mehr Kommentare machen
  */


  Game(){

  }
  void renderMap() {

    //one box=100*100 pixel --UPDATE: ceil() for screen fill
    int widthScale = ceil((float)width/this.map[0].length);
    int heightScale = ceil((float)height/this.map.length);

    for(int i=0; i<this.map[0].length; i++)
    {
      for(int j=0; j<this.map.length; j++)
      {
        //replace by image source and scale
        fill(this.colorMap[map[j][i]]);//fill changes the colour for all draw functions
        rect(i*widthScale, j*heightScale, widthScale, heightScale);//rect draws a rect you idiot
      }
    }
    //print pacman
    fill(this.pacmanColor); //fill changes the colour for all draw functions
    rect(player.position[0]*widthScale, player.position[1]*heightScale, widthScale, heightScale);//rect draws a rect you idiot
  }


  void move() 	// diese funktion verändert die position von pacman
  {
    player.direction=keyMap['w']?"up":keyMap['a']?"left":keyMap['s']?"down":keyMap['d']?"right":player.direction;
    //delay 500ms
    if((mil==0&&player.direction!="")||millis()-mil>=GLOBALDELAY) {
      mil=millis();



      //move ghosts



      int playerNextPos[] = player.position.clone();


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
      int collision = this.checkCollision(playerNextPos);

      //check for collision and afterwards move

      if(collision==3) {

        //if he colides with a ghost we want to check if he has a power up, else he dies
      }

      else if(collision!=1){
        player.position=playerNextPos.clone();
        oldDirection=player.direction;
      }
      else if(collision==1) {
        player.direction=oldDirection;
        playerNextPos=player.position.clone();
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
        collision = this.checkCollision(playerNextPos);
        if(collision!=1){
          player.position=playerNextPos.clone();
        }
      }



    }
  }
  int checkCollision(int[] coords){

    return this.map[coords[1]][coords[0]];
  }
}
