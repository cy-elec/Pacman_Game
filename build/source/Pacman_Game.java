import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Pacman_Game extends PApplet {

/*  Pacman_Game.pde - Project by Elec42, TheJa937 and Flooxxxyy;

*/


//Language Reference:  https://processing.org/reference/

int score;
boolean keyMap[] = new boolean[256];

/*gameHandler is an instance of Game and used for the general game control*/
Game gameHandler = new Game();

public void setup()
{
  /*Display size, width, height*/
  
}

/*Update loop*/
public void draw()
{
  /*renering Map*/
  gameHandler.renderMap();
  /*updating position of pacman and ghost, as well as handling collisions with ghost, coin, etc*/
  gameHandler.move(keyMap);
}


/*
  Keyboard functions
*/
public void keyPressed()
{
  if(key != CODED) //if we detect a key press which is not a CODED key (=win, alt etc.) the key is marked in our key map
    keyMap[key]=true;
}

public void keyReleased() {
  if(key != CODED)//if a key is released, we remeber the key, so that we can release it in our key map next cycle (1cylce= 1 pacman move)
    keyMap[key]=false;
}
/*
  Game class, main gameHandler
*/

class Game {
  /*creates instances for Pacman and 4 Ghosts (ghosts need to be updated)*/
  Pacman player = new Pacman();
  Ghost[] Ghosts = new Ghost[4];

  /*used for new movement control*/
  String oldDirection="";
  /*delay handler. movement every 200ms*/
  int mil=0, GLOBALDELAY=200;


  /*map which will be rendered*/
  int map[][] = {{1,1,1,1,1,1,1,1,1,1}, {1,0,0,0,0,0,0,0,0,1}, {1,0,0,0,0,0,0,0,0,1}, {1,0,0,0,0,0,0,0,0,1}, {1,0,0,1,0,0,1,0,0,1}, {0,0,0,1,0,0,1,0,0,0}, {1,0,0,1,1,1,1,0,0,1}, {1,0,0,0,0,0,0,0,0,1}, {1,0,0,0,0,0,0,0,0,1}, {1,0,0,0,0,0,0,0,0,1}, {1,1,1,1,1,1,1,1,1,1,1}};
  /*color codes for different map features*/
  int colorMap[]= {color(0,0,0),color(0,0,255),color(255,0,255),color(200,200,100),color(255,0,255)};
  int pacmanColor = color(255, 255, 0);
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

  /*renders the whole map*/
  public void renderMap() {

    //one box=100*100 pixel --UPDATE: ceil() for screen fill
    int widthScale = ceil((float)width/this.map[0].length);
    int heightScale = ceil((float)height/this.map.length);

    /*loop through x and y axis*/
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

  /*movement control and collision check*/
  public void move(boolean keyMap[]) 	// diese funktion verändert die position von pacman
  {
    /*update new input key immediately*/
    player.direction=keyMap['w']?"up":keyMap['a']?"left":keyMap['s']?"down":keyMap['d']?"right":player.direction;

    //every 500ms
    if((mil==0&&player.direction!="")||millis()-mil>=GLOBALDELAY) {
      /*reset counter*/
      mil=millis();



      //move ghosts


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

      //check for collision and afterwards move
      /*Ghost collision*/
      if(collision==3) {

        //if he colides with a ghost we want to check if he has a power up, else he dies
      }
      /*wall collision -> ignore key*/
      else if(collision==1) {
        /*restore previous valid direction to cancel out current one and move*/
        player.direction=oldDirection;

        /*calculate next position again and check for collision*/
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
        /*if it's not a wall, move*/
        if(collision!=1){
          player.position=playerNextPos.clone();
        }
      }
      /*no wall collision -> move*/
      else if(collision!=1){
        /*update position*/
        player.position=playerNextPos.clone();
        /*update last valid direction*/
        oldDirection=player.direction;
      }



    }
  }
  /*returns map marker at coordinate*/
  public int checkCollision(int[] coords){

    return this.map[coords[1]][coords[0]];
  }
}
class Ghost {
boolean isAlive;

}
class Pacman {
  boolean isAlive=true;
  int[] position = new int[2];

  String direction;


  Pacman(){
    this.direction="";
    this.position[0]=1;
    this.position[1]=1;
  }
}
  public void settings() {  size(500, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Pacman_Game" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
