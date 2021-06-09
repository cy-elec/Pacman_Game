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

/*  Pacman_Game.pde - Project by Elec42, TheJa937, Flooxxxyy and Optirat;



*/
boolean DEBUGMODE = true;

int frames = 60;
int sizeX = 1000;
int sizeY = 1000;

int millis = 0;

//Language Reference:  https://processing.org/reference/

PrintWriter debugoutput;

boolean keyMap[] = new boolean[256];
boolean fullReset = true;
/*gameHandler is an instance of Game and used for the general game control*/

Game gameHandler;


public void settings(){

  size(sizeX, sizeY);


}

public void setup()
{
  debugoutput = createWriter(".debug.log");

  ref_loadImage();

  frameRate(frames);
  noStroke();
  /*DEBUG*/
  debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Main: Initialized Window");

  //display


}

/*Update loop*/
public void draw(){
  millis = millis();

  if (fullReset){
      fullReset = false;
      gameHandler=new Game();
  }
  if(gameHandler.player.isAlive) {
    /*renering Map*/
    gameHandler.smartRender();

    /*updating position of pacman and ghost, as well as handling collisions with ghost, coin, etc*/
    gameHandler.move(keyMap);

  }

  /*End screen or boot up screen*/
  else {
    gameHandler.renderNonPlayableScene();
  }
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



public void exit() {
  debugoutput.println("Exiting...");
  debugoutput.flush();
  debugoutput.close();
  super.exit();
}

//the node class is essential for the implementation of A*

class Node {

  Node parent;
  int g;//g is the distance from the start
  int[] position = new int[2];//coordinates
  int h = 0;//h is the distance from the end
  Integer f;//f is the final evaluation


  //when calling we need to pass the array position as a variable
  Node(Node parent, int g, int[] position, int h) {

    /*
    basically, the Node class saves its own coordinates(position),
    its distance from the start(g);
    an evaluation (h);
    and its parent node ie the node that came before it (parent)
    furthermore it creates its own final evaluatioin f which is just h + g
    */
    this.parent = parent;
    this.g = g;
    this.position = position.clone();

    this.h = this.h+h;

    this.f = this.g + this.h;
  }

  // we define an equals function to check if two nodes are the same
  //they are the same as long as their positions match
  public boolean equals(Node otherNode) {
    if (otherNode.position[0] == this.position[0] && otherNode.position[1] == this.position[1])
      return true;
    else
      return false;
  }




}


//this bubbleSort function was copied from the internet, basically it just sorts stuff
//i only kinda understand how it works so youll just have to google bubble Sort
//Note that this function returns void and changes the array passed to it
/*Edit by Felix: Top index 0 equals the least Node.f value --> best node at top*/
public void bubbleSort(Node[] a) {
    boolean sorted = false;
    Node temp;
    while(!sorted) {
        sorted = true;
        for (int i = 0; i < a.length - 1; i++) {
            if (a[i].f > a[i+1].f) {//this line is the only line i altered; i changed a[] to a[].f so that the evaluation is used to sort the nodes
                temp = a[i];
                a[i] = a[i+1];
                a[i+1] = temp;
                sorted = false;
            }
        }
    }
}


// i just translated a python A* algorithm so im recreating python functions
//the function does basically exactly what it says: it checks wether a is in b;
//Note that a has to be a Node and b an array of Nodes
public boolean isAinB(Node a, Node[] b){
  for (int i=0; i<b.length;i++){
    if(a.equals(b[i]))
      return true;
  }
  return false;


}


public int[][] AStar(int[] position1, int[] position2, int[][] map, int[][][] teleporters){


  //the A* algorithm (it tries to find the best path from position1 to position2)


  // if the two positions are the same we quit the function
  //basically just a failsave
  if (position1[0]==position2[0]&&position1[1]==position2[1])
    return null;


  //we create two arrays, one will house all explored nodes
  //the other will house all adjacent Nodes which we are yet to explored
  //Note that Nodes which are not adjacent to the explored Nodes are present in neither list
  //they will be added to our unexplored list if we find a path to this node ie a node next to it is explored
  Node[] explored = {};
  // the only node so far is our starting point, it has no parent and both its distance from the start and from the end are set to a default value of 0
  //this is because no matter what, it will be explored as it is the only node we have
  Node[] unexplored = {new Node(null, 0, position1,0)};


  // we will loop until there are no unexplored nodes left,
  //if this happens then there is no path to pacman and the ghost does not move
  //this should never happen as our maze is built in a way which connects all empty squares with each other
  while( unexplored.length != 0){

    //first of we sort our unexplored list according to the evaluation we give each node
    //so that the node with the lowest evalutaion ie the node most likely to lead to our goal ist first
    bubbleSort(unexplored);

    // we then save the node to be explored
    Node oldNode = unexplored[0];

    String[] possibleMoves = {"up", "down", "left", "right"};


    //we loop through all steps which can possibly be taken from the old Node and save their positions
    for (int i  = 0; i<4; i++){

       int[] newPosition = {oldNode.position[0], oldNode.position[1]};

      //this is a slightly altered version of the game.move() code
      switch(possibleMoves[i]) {
      case "up":
       newPosition[1]--;
       newPosition[1]= newPosition[1]<0?map.length-1:newPosition[1];
       break;
      case "down":
        newPosition[1]++;
        newPosition[1] %= map.length;
        break;
      case "left":
        newPosition[0]--;
        newPosition[0]= newPosition[0]<0?map[0].length-1:newPosition[0];

        break;

      case "right":
        newPosition[0]++;
        newPosition[0] %= map[0].length;
        break;
      default:break;
      }




      //first we check if our new Nodes position is a wall
      if (map[newPosition[1]][newPosition[0]] != 1){

        //with the new position we then create a new evaluation consisting of the length that we are away from our goal (a**2 + b**2 = c**2)
        int newH = (int)pow((int)pow(newPosition[0] - position2[0], 2) + (int)pow(newPosition[1] - position2[1], 2), 0.5f);

        for (int j=0; j<teleporters.length; j++){
          //we loop through every teleporter and check, if the distance from position1 to teleporter 1 plus the distance from teleporter2 to position2 is lower than the normal distance
          //(each teleporter consists of two sides teleporter1 and 2)
          int newHTeleporter =(int) pow( (int)pow(newPosition[0] - teleporters[j][0][0], 2) + (int)pow(newPosition[1] - teleporters[j][0][1], 2), 0.5f)
                              +
                              (int) pow( (int)pow(teleporters[j][1][0] - position2[0], 2) + (int)pow(teleporters[j][1][1] - position2[1], 2), 0.5f);
          if (newHTeleporter<newH)
            newH=newHTeleporter;

          //then we check the opposite: position1 -> teleporter2 + teleporter1 -> positon2
          newHTeleporter = (int) pow((int) pow( (int)pow(newPosition[0] - teleporters[j][1][0], 2) + (int)pow(newPosition[1] - teleporters[j][1][1], 2), 0.5f) + (int)pow( (int)pow(teleporters[j][0][0] - position2[0], 2) + (int)pow(teleporters[j][0][1] - position2[1], 2), 0.5f), 2);

          if (newHTeleporter<newH)
            newH=newHTeleporter;


        }




        // now that we have the new position and the new evalutaion we can create a new node
        //the parent node is our old node and our distance from the start increases by 1
        Node newNode = new Node(oldNode, oldNode.g+1, newPosition, newH);

        //we only check the new node if it has not been explored before and it hasnt already been added to our unexplored list
        if( !(isAinB(newNode, unexplored)||isAinB(newNode, explored))){

          //if our new Node has the position of our end destination, then we are almost done
          if(newNode.position[0]==position2[0] && newNode.position[1]==position2[1]){

            //if we find the end then we just backtrack back to the start
            int[][] path ={position2};

            //we do this by adding the position of the parent node to our path array until the parent node is null ie we've found our start node
            while(newNode.parent!=null){
              newNode= newNode.parent;
              path = (int[][])append(path, newNode.position);
            }
            //return the final and (hopefully) best path
            return (int[][]) reverse(path);
          }
          //if we havent found our goal, we just add the newNode to our unexplored list, so that it can be explored later
          unexplored = (Node[]) append(unexplored, newNode);
        }
      }
    }
    //remove the old node from our unexplored list and add it to our explored list as all its neighbors have been checked
    explored = (Node[]) append(explored, unexplored[0]);
    unexplored = (Node[]) reverse(unexplored);
    unexplored = (Node[]) shorten(unexplored);
    unexplored = (Node[]) reverse(unexplored);
  }

//if we could not find a path we print an error message and return null
//we should not reach this point as we should find a path and leave the function with the return statement in line 195
print("A* algorithm could not find a path \n");
return null;
}
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
  int mil=0, mil2=0, mil3=0, mil4=0, frMil=0;
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
    	{1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,},
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
  int colorMap[]= {color(0, 0, 0), color(0, 0, 255), color(200, 200, 100), color(200, 200, 100)};

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



  public void renderNonPlayableScene() {
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
  public void renderMap() {

    stroke(1);

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
    noStroke();
  }



  public void smartRender(){


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
    int score_clear_width = (int)((width/47.2f*12)/widthScale+0.5f);
    int score_clear_pos[] = {0,score_clear_width,0};
    //lives: (8 Letters for: "Lives: x")
    int lives_clear_width = (int)((width/47.2f*8)/widthScale+0.5f);
    int lives_clear_pos[] = {this.map[0].length-lives_clear_width,this.map[0].length,0};
    //status: (8 Letters for: "[status]" -> *4 because half the size)
    int status_clear_width = (int)((width/47.2f*4)/widthScale+0.5f);
    int status_clear_pos[] = {0,status_clear_width,this.map.length-1};
    //framerate: (9 Letters for: "FPS: xxxx" -> *5 because half the size)
    int framerate_clear_width = (int)((width/47.2f*4)/widthScale+0.5f);
    int framerate_clear_pos[] = {this.map[0].length-framerate_clear_width-1,this.map[0].length,this.map.length-1};

    //list of positions to clear (only horizontal clear)
    int toClear[][] = {score_clear_pos, lives_clear_pos, status_clear_pos};

    if(DEBUGMODE) toClear = (int[][])append(toClear, framerate_clear_pos);

    stroke(1);
    for(int i=0; i<toClear.length; i++) {
      for(int j=toClear[i][0]; j<toClear[i][1]; j++) {
        fill(this.colorMap[map[toClear[i][2]][j]]);//fill changes the colour for all draw functions
        if (this.map[toClear[i][2]][j]==2) ellipse(i*this.widthScale+this.widthScale/2, j*this.heightScale+this.heightScale/2, this.widthScale/2, this.heightScale/2);
        else rect(j*this.widthScale, toClear[i][2]*this.heightScale, this.widthScale, this.heightScale);//rect draws a rect you idiot
      }
    }
    noStroke();



    fill(player.pacmanColor); //fill changes the colour for all draw functions

    switch(player.renderDirection){
      case"right":image(player.Iright, player.renderPosition[0]*this.widthScale+player.renderFactor[0], player.renderPosition[1]*this.heightScale+player.renderFactor[1], this.widthScale, this.heightScale);break;
      case"left":image(player.Ileft, player.renderPosition[0]*this.widthScale+player.renderFactor[0], player.renderPosition[1]*this.heightScale+player.renderFactor[1], this.widthScale, this.heightScale);break;
      case"up":image(player.Iup, player.renderPosition[0]*this.widthScale+player.renderFactor[0], player.renderPosition[1]*this.heightScale+player.renderFactor[1], this.widthScale, this.heightScale);break;
      case"down":image(player.Idown, player.renderPosition[0]*this.widthScale+player.renderFactor[0], player.renderPosition[1]*this.heightScale+player.renderFactor[1], this.widthScale, this.heightScale);break;
      default: image(player.Idefault, player.renderPosition[0]*this.widthScale+player.renderFactor[0], player.renderPosition[1]*this.heightScale+player.renderFactor[1], this.widthScale, this.heightScale);break;
    }



    for (int i=0; i<this.ghosts.length; i++){
      if (ghosts[i].isAlive){
        if(ghosts[i].frightened&&millis-frMil<=(FRIGHTENED_TIME-1500)) image(ghosts[i].Ifrightened, ghosts[i].renderPosition[0]*this.widthScale+ghosts[i].renderFactor[0], ghosts[i].renderPosition[1]*this.heightScale+ghosts[i].renderFactor[1], this.widthScale, this.heightScale);
        else if(ghosts[i].frightened&&millis-frMil>=(FRIGHTENED_TIME-1500)) {
          if(ghosts[i].imgToggle) image(ghosts[i].Ifrightened, ghosts[i].renderPosition[0]*this.widthScale+ghosts[i].renderFactor[0], ghosts[i].renderPosition[1]*this.heightScale+ghosts[i].renderFactor[1], this.widthScale, this.heightScale);
          else image(ghosts[i].Idefault, ghosts[i].renderPosition[0]*this.widthScale+ghosts[i].renderFactor[0], ghosts[i].renderPosition[1]*this.heightScale+ghosts[i].renderFactor[1], this.widthScale, this.heightScale);
        }
        else
          switch(ghosts[i].renderDirection){
            case"right":image(ghosts[i].Iright, ghosts[i].renderPosition[0]*this.widthScale+ghosts[i].renderFactor[0], ghosts[i].renderPosition[1]*this.heightScale+ghosts[i].renderFactor[1], this.widthScale, this.heightScale);break;
            case"left":image(ghosts[i].Ileft, ghosts[i].renderPosition[0]*this.widthScale+ghosts[i].renderFactor[0], ghosts[i].renderPosition[1]*this.heightScale+ghosts[i].renderFactor[1], this.widthScale, this.heightScale);break;
            case"up":image(ghosts[i].Iup, ghosts[i].renderPosition[0]*this.widthScale+ghosts[i].renderFactor[0], ghosts[i].renderPosition[1]*this.heightScale+ghosts[i].renderFactor[1], this.widthScale, this.heightScale);break;
            case"down":image(ghosts[i].Idown, ghosts[i].renderPosition[0]*this.widthScale+ghosts[i].renderFactor[0], ghosts[i].renderPosition[1]*this.heightScale+ghosts[i].renderFactor[1], this.widthScale, this.heightScale);break;
            default: image(ghosts[i].Idefault, ghosts[i].renderPosition[0]*this.widthScale+ghosts[i].renderFactor[0], ghosts[i].renderPosition[1]*this.heightScale+ghosts[i].renderFactor[1], this.widthScale, this.heightScale);break;
          }
      }
    }

    /*SmartText pt2*/
    fill(255);
    textSize(this.heightScale);
    text("Score: "+this.playerScore, width/250, this.heightScale-height/200);
    text("Lives:"+player.lives, width-this.heightScale*3.125f-2, this.heightScale-height/200);
    textSize(this.heightScale/2);
    if(DEBUGMODE)
    text("FPS: "+this.frameRate, width-this.heightScale*2, height-height/500);
    if (player.isAlive) fill(0, 255, 0);
    else fill(255, 0, 0);
    if(frMil!=0) fill(255,255,0);
    text("[status]", 2, height-height/500);

  }



  public void bootupScreen() {
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
  public void endScreen(){
    background(0);

  }


  public void findTeleporters() {

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

  public void setAllStartPosition() {
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
  public void move(boolean keyMap[]) {

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


    if(mil2==0||millis-mil2>=GLOBALDELAY/1.5f) {
      mil2=millis;
      player.toggleImg();
      for(int i=0; i<this.ghosts.length; i++) this.ghosts[i].toggleImg();
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
        else {
          player.renderDirection="";
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

  public void updatePosition(int[] playerNextPos){
    /*update position*/

    player.oldPosition = player.renderPosition.clone();

    player.resetSmooth();

    player.position=playerNextPos.clone();

  }



  public void updateSmoothPosition() {

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
  public int checkCollision(int[] coords) {

    for (int i = 0; i<this.ghosts.length;i++){

    if (ghosts[i].position[0]==coords[0]&&ghosts[i].position[1]==coords[1]&&ghosts[i].isAlive) return 4+i;

    }
    return this.map[coords[1]][coords[0]];
  }


  public void reset(){
    this.rendered = false;

    ghosts = new Ghost[]{new Blinky(this.ghost_default_position,this.DEFAULT_GHOSTDELAY), new Pinky(this.ghost_default_position,this.DEFAULT_GHOSTDELAY), new Inky(this.ghost_default_position,this.DEFAULT_GHOSTDELAY), new Kinky(this.ghost_default_position,this.DEFAULT_GHOSTDELAY)};

    this.mil=0;
    this.mil2=0;
    this.mil3 = 0;
    this.mil4 = 0;

    this.player.reset();
    this.player.lives--;
    this.frameCnt=millis;

  }
}
class Ghost {
  protected boolean isAlive=true;
  protected String name;
  protected int[] spawnpoint = new int[2];
  protected int[] position = new int[2];

  int GHOSTDELAY=0;
  int GHOSTDELAY_N=0;

  int[] oldPosition = new int[2];
  int[] renderPosition = new int[2];
  float[] renderFactor = new float[2];
  String renderDirection="";

  int renderTime = 0;

  int deadTime = 6;
  int deadCount = 0;

  int dlTime=0;

  boolean frightened=false;


  boolean imgToggle=false;
  PImage Iright;
  PImage Ileft;
  PImage Iup;
  PImage Idown;
  PImage right0;
  PImage left0;
  PImage up0;
  PImage down0;
  PImage right1;
  PImage left1;
  PImage up1;
  PImage down1;
  PImage Idefault;
  PImage Ifrightened;

  Ghost(String name, PImage r0, PImage r1, PImage l0, PImage l1, PImage d0, PImage d1, PImage u0, PImage u1, PImage f, PImage d, int position[], int df){
    /*DEBUG*/
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Ghost: Initialized Ghost["+name+"]");

    this.GHOSTDELAY=df;
    this.GHOSTDELAY_N=df;
    this.name = name;
    this.spawnpoint = position.clone();
    this.oldPosition = position.clone();
    this.position = position.clone();
    this.renderPosition = position.clone();
    this.renderFactor[0] = 0;
    this.renderFactor[1] = 0;


    this.right0=r0;
    this.left0=l0;
    this.up0=u0;
    this.down0=d0;
    this.right1=r1;
    this.left1=l1;
    this.up1=u1;
    this.down1=d1;
    this.Idefault=d;
    this.Ifrightened=f;

    this.Iright=this.right0;
    this.Ileft=this.left0;
    this.Iup=this.up0;
    this.Idown=this.down0;

  }

  public int mayMove() {
    if(dlTime==0||millis-dlTime>=this.GHOSTDELAY) {
      dlTime=millis;
      if(this.frightened) this.GHOSTDELAY=this.GHOSTDELAY_N*2;
      else this.GHOSTDELAY=this.GHOSTDELAY_N;

      return 1;
    }
    return 0;
  }


  public void toggleImg() {
    if(this.imgToggle) {
      this.Iright=this.right1;
      this.Ileft=this.left1;
      this.Iup=this.up1;
      this.Idown=this.down1;
    }
    else {
      this.Iright=this.right0;
      this.Ileft=this.left0;
      this.Iup=this.up0;
      this.Idown=this.down0;
    }
    this.imgToggle=!this.imgToggle;
  }

  public void resetSmooth() {
    this.renderTime = millis;
    this.renderPosition=this.position.clone();
    this.renderFactor[0]=0;
    this.renderFactor[1]=0;
  }

  public void makeMove(){
    println("overriding inky didnt work");

  }
  public void makeMove(int[] position){
    println("overriding blinky didnt work");

  }
  public void makeMove(int[] position, String direction){
    println("overriding pinky or kinky didnt work");
    //kinky isnt in this file yet, will be updated probably later today when felix replies to my discord dms
  }

  public void kill(){
    this.frightened=false;
    this.isAlive = false;
    this.oldPosition = this.renderPosition.clone();
    this.renderPosition = this.spawnpoint.clone();
    this.renderDirection="";
    this.renderFactor=new float[2];
    this.position = this.spawnpoint.clone();

  }


}
/* Blinky */

class Blinky extends Ghost{

  Blinky(int position[], int df) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Blinky", ghost_blinky_right0_img, ghost_blinky_right1_img, ghost_blinky_left0_img, ghost_blinky_left1_img, ghost_blinky_down0_img, ghost_blinky_down1_img, ghost_blinky_up0_img, ghost_blinky_up1_img, ghost_blinky_frightened_img, ghost_blinky_default_img, position, df);
  }

  public void makeMove(int[] pacmanPosition){

    if(super.isAlive){
      resetSmooth();

      int[][] path = AStar(this.position, pacmanPosition, gameHandler.map, gameHandler.teleporters);
      if (path!=null) {
        int nPos[] = path[1].clone();

        if(nPos[0]-this.position[0]==-1) {this.renderDirection="left";}
        else if(nPos[0]-this.position[0]==1) {this.renderDirection="right";}

        if(nPos[1]-this.position[1]==-1) {this.renderDirection="up";}
        else if(nPos[1]-this.position[1]==1) {this.renderDirection="down";}


        this.position = nPos.clone();
      }
    }
    else{
      if(super.deadCount>=super.deadTime){
        super.deadCount = 0;
        super.isAlive = true;
      }
      else
        super.deadCount++;
    }
  }
}
/* Clyde*/

class Clyde extends Ghost{

  Clyde(int position[], int df) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Clyde", ghost_clyde_right0_img, ghost_clyde_right1_img, ghost_clyde_left0_img, ghost_clyde_left1_img, ghost_clyde_down0_img, ghost_clyde_down1_img, ghost_clyde_up0_img, ghost_clyde_up1_img, ghost_clyde_frightened_img, ghost_clyde_default_img, position, df);
  }
  //tries to stay out of the way -> goes always away from pacman

  public void makeMove(int[] pacmanPosition){



  }

}
/* Inky */

class Inky extends Ghost{

  int[][] leereFelder = {};
  int[][] path = {};
  int count = 0;



  int[] inkiesGoal = this.position;

  Inky(int position[], int df) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Inky", ghost_inky_right0_img, ghost_inky_right1_img, ghost_inky_left0_img, ghost_inky_left1_img, ghost_inky_down0_img, ghost_inky_down1_img, ghost_inky_up0_img, ghost_inky_up1_img, ghost_inky_frightened_img, ghost_inky_default_img, position, df);


  }
    //least predictable of the ghosts (probably just random moves)

  public void makeMove(){

    if(this.isAlive){

      resetSmooth();
      if(this.leereFelder.length==0) findeleereFelder();
      if(this.position[0]==inkiesGoal[0]&&this.position[1]==inkiesGoal[1])
      {
        this.inkiesGoal = (int[])leereFelder[(int)random(leereFelder.length)];
        this.path = AStar(this.position, this.inkiesGoal, gameHandler.map, gameHandler.teleporters);
        count = 0;
      }

      if (path!=null) {
        count++;
        int nPos[] = path[count].clone();

        if(nPos[0]-this.position[0]==-1) {this.renderDirection="left";}
        else if(nPos[0]-this.position[0]==1) {this.renderDirection="right";}

        if(nPos[1]-this.position[1]==-1) {this.renderDirection="up";}
        else if(nPos[1]-this.position[1]==1) {this.renderDirection="down";}

        this.position = nPos.clone();
      }
    }

    else{
      if(this.deadCount>=this.deadTime){
        this.deadCount = 0;
        this.inkiesGoal=this.spawnpoint.clone();
        this.isAlive = true;
      }
      else
        super.deadCount++;
    }

  }


  public void findeleereFelder()
  {
      for(int i=0; i< gameHandler.map.length; i++)
      {
        for(int j=0; j< gameHandler.map[0].length; j++)
        {
          if(gameHandler.map[i][j]!=1)
          {
            this.leereFelder = (int[][])append(this.leereFelder, new int[] {j,i});
          }
      }
    }
  }

}
/* Kinky */

class Kinky extends Ghost{

  int[] target = new int[2];
  int uP=0;
  boolean init=false;



  Kinky(int position[], int df) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Kinky", ghost_kinky_right0_img, ghost_kinky_right1_img, ghost_kinky_left0_img, ghost_kinky_left1_img, ghost_kinky_down0_img, ghost_kinky_down1_img, ghost_kinky_up0_img, ghost_kinky_up1_img, ghost_kinky_frightened_img, ghost_kinky_default_img, position, df);
  }

  public void makeMove(int[] pacmanPosition, String pacmanDirection){

    if(super.isAlive){

      resetSmooth();
      uP++;
      if(!init|| (
        (pacmanDirection=="left"&&pacmanPosition[0]<=this.target[0]) ||
        (pacmanDirection=="right"&&pacmanPosition[0]>=this.target[0]) ||
        (pacmanDirection=="up"&& pacmanPosition[1]<=this.target[1]) ||
        (pacmanDirection=="down"&& pacmanPosition[1]>=this.target[1])
      ) || (this.target[0]==this.position[0]&&this.target[1]==this.position[1])) {
        uP=0;
        findTarget(pacmanPosition, pacmanDirection);
        init=true;
      }
      int[][] path = AStar(this.position, this.target, gameHandler.map, gameHandler.teleporters);

      if (path!=null) {
        int nPos[] = path[1].clone();

        if(nPos[0]-this.position[0]==-1) {this.renderDirection="left";}
        else if(nPos[0]-this.position[0]==1) {this.renderDirection="right";}

        if(nPos[1]-this.position[1]==-1) {this.renderDirection="up";}
        else if(nPos[1]-this.position[1]==1) {this.renderDirection="down";}


        this.position = nPos.clone();
      }
    }
    else{
      if(super.deadCount>=super.deadTime){
        super.deadCount = 0;
        super.isAlive = true;
      }
      else
        super.deadCount++;
    }
  }

  public void findTarget(int[] pacmanPosition, String pacmanDirection) {
    int sPos[] = pacmanPosition.clone();

    boolean loop = true;
    int directionVector[] = new int[2];

    switch(pacmanDirection) {
      case "up": directionVector[1]=-1;break;
      case "down": directionVector[1]=1;break;
      case "left": directionVector[0]=-1;break;
      case "right": directionVector[0]=1;break;
      default : this.target = pacmanPosition; return;
    }

    String nextDirection=pacmanDirection;
    int foundNumber=0;
    do {
      if(foundNumber!=0&&foundNumber<2) {
        switch(nextDirection) {
          case "up": directionVector[1]=-1;directionVector[0]=0;break;
          case "down": directionVector[1]=1;directionVector[0]=0;break;
          case "left": directionVector[0]=-1;directionVector[1]=0;break;
          case "right": directionVector[0]=1;directionVector[1]=0;break;
          default : break;
        }
      }
      else if(foundNumber>=2) {
        loop=false;
        continue;
      }
      foundNumber=0;

      sPos[0]+=directionVector[0];
      sPos[1]+=directionVector[1];
      sPos[0] %= gameHandler.map[0].length;
      sPos[1] %= gameHandler.map.length;
      sPos[0] = sPos[0]<0?gameHandler.map[0].length-1:sPos[0];
      sPos[1] = sPos[1]<0?gameHandler.map.length-1:sPos[1];

      if(sPos[0]==this.position[0]&&sPos[1]==this.position[1]) {
        loop = false;
        sPos = pacmanPosition.clone();
        continue;
      }
      else if(gameHandler.map[sPos[1]][sPos[0]]==1) {
        sPos[0]-=directionVector[0];
        sPos[1]-=directionVector[1];
        sPos[0] %= gameHandler.map[0].length;
        sPos[1] %= gameHandler.map.length;
        sPos[0] = sPos[0]<0?gameHandler.map[0].length-1:sPos[0];
        sPos[1] = sPos[1]<0?gameHandler.map.length-1:sPos[1];
        loop=false;
        continue;
      }
      else {
        switch(nextDirection) {
          case "up":
            if(gameHandler.map[((sPos[1]-1)<0?gameHandler.map.length-1:sPos[1]-1)][sPos[0]]!=1){nextDirection="up";foundNumber++;}
            if(gameHandler.map[sPos[1]][((sPos[0]-1)<0?gameHandler.map[0].length-1:sPos[0]-1)]!=1){nextDirection="left";foundNumber++;}
            if(gameHandler.map[sPos[1]][((sPos[0]+1)%gameHandler.map[0].length)]!=1){nextDirection="right";foundNumber++;}
            break;

          case "down":
            if(gameHandler.map[((sPos[1]+1)%gameHandler.map.length)][sPos[0]]!=1){nextDirection="down";foundNumber++;}
            if(gameHandler.map[sPos[1]][((sPos[0]-1)<0?gameHandler.map[0].length-1:sPos[0]-1)]!=1){nextDirection="left";foundNumber++;}
            if(gameHandler.map[sPos[1]][((sPos[0]+1)%gameHandler.map[0].length)]!=1){nextDirection="right";foundNumber++;}
            break;

          case "left":
            if(gameHandler.map[sPos[1]][((sPos[0]-1)<0?gameHandler.map[0].length-1:sPos[0]-1)]!=1){nextDirection="left";foundNumber++;}
            if(gameHandler.map[((sPos[1]-1)<0?gameHandler.map.length-1:sPos[1]-1)][sPos[0]]!=1){nextDirection="up";foundNumber++;}
            if(gameHandler.map[((sPos[1]+1)%gameHandler.map.length)][sPos[0]]!=1){nextDirection="down";foundNumber++;}
            break;

          case "right":
            if(gameHandler.map[sPos[1]][((sPos[0]+1)%gameHandler.map[0].length)]!=1){nextDirection="right";foundNumber++;}
            if(gameHandler.map[((sPos[1]-1)<0?gameHandler.map.length-1:sPos[1]-1)][sPos[0]]!=1){nextDirection="up";foundNumber++;}
            if(gameHandler.map[((sPos[1]+1)%gameHandler.map.length)][sPos[0]]!=1){nextDirection="down";foundNumber++;}
            break;
        }
      }
    }while(loop);
    this.target=sPos.clone();
  }

}
/* Pinky */

class Pinky extends Ghost{

  int[] goal;

  Pinky(int position[], int df) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Pinky", ghost_pinky_right0_img, ghost_pinky_right1_img, ghost_pinky_left0_img, ghost_pinky_left1_img, ghost_pinky_down0_img, ghost_pinky_down1_img, ghost_pinky_up0_img, ghost_pinky_up1_img, ghost_pinky_frightened_img, ghost_pinky_default_img, position, df);

  }
  //tries to cut off your path off by coming in front of you

  public void makeMove(int[] pacmanPosition, String pacmanDirection){

    if(super.isAlive){
      resetSmooth();

      this.goal = findGoal(pacmanPosition, pacmanDirection);




      int[][] path = AStar(this.position, this.goal, gameHandler.map, gameHandler.teleporters);

      if (path!=null) {
        int nPos[] = path[1].clone();

        if(nPos[0]-this.position[0]==-1) {this.renderDirection="left";}
        else if(nPos[0]-this.position[0]==1) {this.renderDirection="right";}

        if(nPos[1]-this.position[1]==-1) {this.renderDirection="up";}
        else if(nPos[1]-this.position[1]==1) {this.renderDirection="down";}


        this.position = nPos.clone();
      }
    }
    else{
      if(super.deadCount>=super.deadTime){
        super.deadCount = 0;
        super.isAlive = true;
      }
      else
        super.deadCount++;
    }

}

  public int[] findGoal(int[] pacmanPosition, String pacmanDirection){
    int[] goal = pacmanPosition.clone();

    //if pinky is infront of pacman, corner him with blinky by chasing him down
    switch(pacmanDirection) {
    case "up":
      if (this.position[1] <= pacmanPosition[1]){
        return goal;
      }
      break;

    case "down":
      if (this.position[1] >= pacmanPosition[1]){
        return goal;
      }
      break;

    case "left":
      if (this.position[0] <= pacmanPosition[0]){
        return goal;
      }
      break;

    case "right":
      if (this.position[0] >= pacmanPosition[0]){
        return goal;
      }
      break;

    default:
      break;
    }



    //immer schauen, wo pacman in 4 schritten ist und da das neue ziel hinsetzen

    switch(pacmanDirection) {
      case "up":
        goal[1]-= 4;
        break;

      case "down":
        goal[1]+=4;
        break;

      case "left":
        goal[0]-=4;
        break;

      case "right":
        goal[0]+=4;
        break;

      default:
        break;
    }

    goal = this.getValidPos(goal.clone(), pacmanDirection, false);

    return goal;



  }



  public int[] getValidPos(int[] coord, String pacmanDirection, boolean hitWall){
    //it takes a given position as its argument and checks wether it is valid (!= out of bounds, !=wall)
    //wall = 1, free = 0




    if(hitWall){
      switch(pacmanDirection) {
      case "up":
        coord[1]++;
        break;

      case "down":
        coord[1]--;
        break;

      case "left":
        coord[0]++;
        break;

      case "right":
        coord[0]--;
        break;

      default:
        break;
      }

      if (gameHandler.map[coord[1]][coord[0]]!=1)
        return coord;
      else
        return this.getValidPos(coord.clone(), pacmanDirection, hitWall);
    }




    if(coord[0]<0){
      coord[0]=0;
      hitWall = true;
      return this.getValidPos(coord.clone(), pacmanDirection, hitWall);
    }
    else if(coord[1]<0) {
      coord[1]=0;
      hitWall = true;
      return this.getValidPos(coord.clone(), pacmanDirection, hitWall);

    }
    else if(coord[0]>=gameHandler.map[0].length){
      coord[0]=gameHandler.map[0].length;
      hitWall = true;
      return this.getValidPos(coord.clone(), pacmanDirection, hitWall);

    }
    else if(coord[1]>=gameHandler.map.length){
      coord[1]=gameHandler.map.length;
      hitWall = true;
      return this.getValidPos(coord.clone(), pacmanDirection, hitWall);
    }

    else{
      if (gameHandler.map[coord[1]][coord[0]]==1){

        switch(pacmanDirection) {
        case "up":
          coord[1]--;
          break;

        case "down":
          coord[1]++;
          break;

        case "left":
          coord[0]--;
          break;

        case "right":
          coord[0]++;
          break;

        default:
          break;
        }

        if(coord[0]<0){
          coord[0]=0;
          hitWall = true;
          return this.getValidPos(coord.clone(), pacmanDirection, hitWall);
        }
        else if(coord[1]<0) {
          coord[1]=0;
          hitWall = true;
          return this.getValidPos(coord.clone(), pacmanDirection, hitWall);

        }
        else if(coord[0]>=gameHandler.map[0].length){
          coord[0]=gameHandler.map[0].length;
          hitWall = true;
          return this.getValidPos(coord.clone(), pacmanDirection, hitWall);

        }
        else if(coord[1]>=gameHandler.map.length){
          coord[1]=gameHandler.map.length;
          hitWall = true;
          return this.getValidPos(coord.clone(), pacmanDirection, hitWall);
        }


        if (gameHandler.map[coord[1]][coord[0]]!=1)
          return coord;

        else
          return this.getValidPos(coord.clone(), pacmanDirection, hitWall);

        }
    }

    return coord;
  }

}
class Pacman {
  boolean isAlive = false;
  int[] position = new int[2];
  int[] oldPosition = new int[2];

  int[] renderPosition = new int[2];
  float[] renderFactor = new float[2];
  String renderDirection="";

  int renderTime = 0;

  int[] spawnpoint = new int[2];
  int pacmanColor = color(255, 255, 0);
  int lives = 3;

  String direction = "";
  String oldDirection = "";

  boolean imgToggle=false;
  PImage Iright;
  PImage Ileft;
  PImage Iup;
  PImage Idown;
  PImage right0 = pacman_right0_img;
  PImage left0 = pacman_left0_img;
  PImage up0 = pacman_up0_img;
  PImage down0 = pacman_down0_img;
  PImage right1 = pacman_right1_img;
  PImage left1 = pacman_left1_img;
  PImage up1 = pacman_up1_img;
  PImage down1 = pacman_down1_img;
  PImage Idefault = pacman_default_img;

  Pacman(int spawn[]){
    /*DEBUG*/
    this.spawnpoint = spawn.clone();
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Pacman: Initialized pacman");
    this.direction="";
    this.position = this.spawnpoint.clone();
    this.oldPosition = this.spawnpoint.clone();
    this.renderPosition = this.spawnpoint.clone();

    this.Iright=this.right0;
    this.Ileft=this.left0;
    this.Iup=this.up0;
    this.Idown=this.down0;

  }

  public void toggleImg() {
    if(this.imgToggle) {
      this.Iright=this.right1;
      this.Ileft=this.left1;
      this.Iup=this.up1;
      this.Idown=this.down1;
    }
    else {
      this.Iright=this.right0;
      this.Ileft=this.left0;
      this.Iup=this.up0;
      this.Idown=this.down0;
    }
    this.imgToggle=!this.imgToggle;
  }

  public void reset(){

    this.isAlive = true;
    this.position = this.spawnpoint.clone();
    this.renderPosition = this.spawnpoint.clone();
    this.oldPosition = this.spawnpoint.clone();
    this.renderFactor[0] = 0;
    this.renderFactor[1] = 0;
    this.direction = "";
    this.oldDirection = "";
    this.renderDirection="";
  }

  public void resetSmooth(){
    this.renderTime = millis;
    this.renderPosition=this.position.clone();
    this.renderFactor[0]=0;
    this.renderFactor[1]=0;
  }

}

//ghosts
PImage ghost_inky_up0_img;//loadImage("data/ghosts/ghost_inky_up0.png");
PImage ghost_inky_up1_img;//loadImage("data/ghosts/ghost_inky_up1.png");
PImage ghost_inky_down0_img;//loadImage("data/ghosts/ghost_inky_down0.png");
PImage ghost_inky_down1_img;//loadImage("data/ghosts/ghost_inky_down1.png");
PImage ghost_inky_left0_img;//loadImage("data/ghosts/ghost_inky_left0.png");
PImage ghost_inky_left1_img;//loadImage("data/ghosts/ghost_inky_left1.png");
PImage ghost_inky_right0_img;//loadImage("data/ghosts/ghost_inky_right0.png");
PImage ghost_inky_right1_img;//loadImage("data/ghosts/ghost_inky_right1.png");
PImage ghost_inky_frightened_img;//loadImage("data/ghosts/ghost_inky_frightened.png");
PImage ghost_inky_default_img;//loadImage("data/ghosts/ghost_inky_default.png");

PImage ghost_blinky_up0_img;//loadImage("data/ghosts/ghost_blinky_up0.png");
PImage ghost_blinky_up1_img;//loadImage("data/ghosts/ghost_blinky_up1.png");
PImage ghost_blinky_down0_img;//loadImage("data/ghosts/ghost_blinky_down0.png");
PImage ghost_blinky_down1_img;//loadImage("data/ghosts/ghost_blinky_down1.png");
PImage ghost_blinky_left0_img;//loadImage("data/ghosts/ghost_blinky_left0.png");
PImage ghost_blinky_left1_img;//loadImage("data/ghosts/ghost_blinky_left1.png");
PImage ghost_blinky_right0_img;//loadImage("data/ghosts/ghost_blinky_right0.png");
PImage ghost_blinky_right1_img;//loadImage("data/ghosts/ghost_blinky_right1.png");
PImage ghost_blinky_frightened_img;//loadImage("data/ghosts/ghost_blinky_frightened.png");
PImage ghost_blinky_default_img;//loadImage("data/ghosts/ghost_blinky_default.png");

PImage ghost_kinky_up0_img;//loadImage("data/ghosts/ghost_kinky_up0.png");
PImage ghost_kinky_up1_img;//loadImage("data/ghosts/ghost_kinky_up1.png");
PImage ghost_kinky_down0_img;//loadImage("data/ghosts/ghost_kinky_down0.png");
PImage ghost_kinky_down1_img;//loadImage("data/ghosts/ghost_kinky_down1.png");
PImage ghost_kinky_left0_img;//loadImage("data/ghosts/ghost_kinky_left0.png");
PImage ghost_kinky_left1_img;//loadImage("data/ghosts/ghost_kinky_left1.png");
PImage ghost_kinky_right0_img;//loadImage("data/ghosts/ghost_kinky_right0.png");
PImage ghost_kinky_right1_img;//loadImage("data/ghosts/ghost_kinky_right1.png");
PImage ghost_kinky_frightened_img;//loadImage("data/ghosts/ghost_kinky_frightened.png");
PImage ghost_kinky_default_img;//loadImage("data/ghosts/ghost_kinky_default.png");

PImage ghost_pinky_up0_img;//loadImage("data/ghosts/ghost_pinky_up0.png");
PImage ghost_pinky_up1_img;//loadImage("data/ghosts/ghost_pinky_up1.png");
PImage ghost_pinky_down0_img;//loadImage("data/ghosts/ghost_pinky_down0.png");
PImage ghost_pinky_down1_img;//loadImage("data/ghosts/ghost_pinky_down1.png");
PImage ghost_pinky_left0_img;//loadImage("data/ghosts/ghost_pinky_left0.png");
PImage ghost_pinky_left1_img;//loadImage("data/ghosts/ghost_pinky_left1.png");
PImage ghost_pinky_right0_img;//loadImage("data/ghosts/ghost_pinky_right0.png");
PImage ghost_pinky_right1_img;//loadImage("data/ghosts/ghost_pinky_right1.png");
PImage ghost_pinky_frightened_img;//loadImage("data/ghosts/ghost_pinky_frightened.png");
PImage ghost_pinky_default_img;//loadImage("data/ghosts/ghost_pinky_default.png");

PImage ghost_clyde_up0_img;//loadImage("data/ghosts/ghost_clyde_up0.png");
PImage ghost_clyde_up1_img;//loadImage("data/ghosts/ghost_clyde_up1.png");
PImage ghost_clyde_down0_img;//loadImage("data/ghosts/ghost_clyde_down0.png");
PImage ghost_clyde_down1_img;//loadImage("data/ghosts/ghost_clyde_down1.png");
PImage ghost_clyde_left0_img;//loadImage("data/ghosts/ghost_clyde_left0.png");
PImage ghost_clyde_left1_img;//loadImage("data/ghosts/ghost_clyde_left1.png");
PImage ghost_clyde_right0_img;//loadImage("data/ghosts/ghost_clyde_right0.png");
PImage ghost_clyde_right1_img;//loadImage("data/ghosts/ghost_clyde_right1.png");
PImage ghost_clyde_frightened_img;//loadImage("data/ghosts/ghost_clyde_frightened.png");
PImage ghost_clyde_default_img;//loadImage("data/ghosts/ghost_clyde_default.png");

PImage pacman_up0_img;//loadImage("data/pacman/pacman_up0.png");
PImage pacman_up1_img;//loadImage("data/pacman/pacman_up1.png");
PImage pacman_down0_img;//loadImage("data/pacman/pacman_down0.png");
PImage pacman_down1_img;//loadImage("data/pacman/pacman_down1.png");
PImage pacman_left0_img;//loadImage("data/pacman/pacman_left0.png");
PImage pacman_left1_img;//loadImage("data/pacman/pacman_left1.png");
PImage pacman_right0_img;//loadImage("data/pacman/pacman_right0.png");
PImage pacman_right1_img;//loadImage("data/pacman/pacman_right1.png");
PImage pacman_default_img;//loadImage("data/pacman/pacman_default.png");

public void ref_loadImage() {
  ghost_inky_up0_img = loadImage("data/ghosts/ghost_inky_up0.png");
  ghost_inky_up1_img = loadImage("data/ghosts/ghost_inky_up1.png");
  ghost_inky_down0_img = loadImage("data/ghosts/ghost_inky_down0.png");
  ghost_inky_down1_img = loadImage("data/ghosts/ghost_inky_down1.png");
  ghost_inky_left0_img = loadImage("data/ghosts/ghost_inky_left0.png");
  ghost_inky_left1_img = loadImage("data/ghosts/ghost_inky_left1.png");
  ghost_inky_right0_img = loadImage("data/ghosts/ghost_inky_right0.png");
  ghost_inky_right1_img = loadImage("data/ghosts/ghost_inky_right1.png");
  ghost_inky_frightened_img = loadImage("data/ghosts/ghost_inky_frightened.png");
  ghost_inky_default_img = loadImage("data/ghosts/ghost_inky_default.png");

  ghost_blinky_up0_img = loadImage("data/ghosts/ghost_blinky_up0.png");
  ghost_blinky_up1_img = loadImage("data/ghosts/ghost_blinky_up1.png");
  ghost_blinky_down0_img = loadImage("data/ghosts/ghost_blinky_down0.png");
  ghost_blinky_down1_img = loadImage("data/ghosts/ghost_blinky_down1.png");
  ghost_blinky_left0_img = loadImage("data/ghosts/ghost_blinky_left0.png");
  ghost_blinky_left1_img = loadImage("data/ghosts/ghost_blinky_left1.png");
  ghost_blinky_right0_img = loadImage("data/ghosts/ghost_blinky_right0.png");
  ghost_blinky_right1_img = loadImage("data/ghosts/ghost_blinky_right1.png");
  ghost_blinky_frightened_img = loadImage("data/ghosts/ghost_blinky_frightened.png");
  ghost_blinky_default_img = loadImage("data/ghosts/ghost_blinky_default.png");

  ghost_kinky_up0_img = loadImage("data/ghosts/ghost_kinky_up0.png");
  ghost_kinky_up1_img = loadImage("data/ghosts/ghost_kinky_up1.png");
  ghost_kinky_down0_img = loadImage("data/ghosts/ghost_kinky_down0.png");
  ghost_kinky_down1_img = loadImage("data/ghosts/ghost_kinky_down1.png");
  ghost_kinky_left0_img = loadImage("data/ghosts/ghost_kinky_left0.png");
  ghost_kinky_left1_img = loadImage("data/ghosts/ghost_kinky_left1.png");
  ghost_kinky_right0_img = loadImage("data/ghosts/ghost_kinky_right0.png");
  ghost_kinky_right1_img = loadImage("data/ghosts/ghost_kinky_right1.png");
  ghost_kinky_frightened_img = loadImage("data/ghosts/ghost_kinky_frightened.png");
  ghost_kinky_default_img = loadImage("data/ghosts/ghost_kinky_default.png");

  ghost_pinky_up0_img = loadImage("data/ghosts/ghost_pinky_up0.png");
  ghost_pinky_up1_img = loadImage("data/ghosts/ghost_pinky_up1.png");
  ghost_pinky_down0_img = loadImage("data/ghosts/ghost_pinky_down0.png");
  ghost_pinky_down1_img = loadImage("data/ghosts/ghost_pinky_down1.png");
  ghost_pinky_left0_img = loadImage("data/ghosts/ghost_pinky_left0.png");
  ghost_pinky_left1_img = loadImage("data/ghosts/ghost_pinky_left1.png");
  ghost_pinky_right0_img = loadImage("data/ghosts/ghost_pinky_right0.png");
  ghost_pinky_right1_img = loadImage("data/ghosts/ghost_pinky_right1.png");
  ghost_pinky_frightened_img = loadImage("data/ghosts/ghost_pinky_frightened.png");
  ghost_pinky_default_img = loadImage("data/ghosts/ghost_pinky_default.png");

  ghost_clyde_up0_img = loadImage("data/ghosts/ghost_clyde_up0.png");
  ghost_clyde_up1_img = loadImage("data/ghosts/ghost_clyde_up1.png");
  ghost_clyde_down0_img = loadImage("data/ghosts/ghost_clyde_down0.png");
  ghost_clyde_down1_img = loadImage("data/ghosts/ghost_clyde_down1.png");
  ghost_clyde_left0_img = loadImage("data/ghosts/ghost_clyde_left0.png");
  ghost_clyde_left1_img = loadImage("data/ghosts/ghost_clyde_left1.png");
  ghost_clyde_right0_img = loadImage("data/ghosts/ghost_clyde_right0.png");
  ghost_clyde_right1_img = loadImage("data/ghosts/ghost_clyde_right1.png");
  ghost_clyde_frightened_img = loadImage("data/ghosts/ghost_clyde_frightened.png");
  ghost_clyde_default_img = loadImage("data/ghosts/ghost_clyde_default.png");

  pacman_up0_img = loadImage("data/pacman/pacman_up0.png");
  pacman_up1_img = loadImage("data/pacman/pacman_up1.png");
  pacman_down0_img = loadImage("data/pacman/pacman_down0.png");
  pacman_down1_img = loadImage("data/pacman/pacman_down1.png");
  pacman_left0_img = loadImage("data/pacman/pacman_left0.png");
  pacman_left1_img = loadImage("data/pacman/pacman_left1.png");
  pacman_right0_img = loadImage("data/pacman/pacman_right0.png");
  pacman_right1_img = loadImage("data/pacman/pacman_right1.png");
  pacman_default_img = loadImage("data/pacman/pacman_default.png");
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Pacman_Game" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
