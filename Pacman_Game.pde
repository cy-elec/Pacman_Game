/*  Pacman_Game.pde - Project by Elec42, TheJa937, Flooxxxyy and Optirat;



*/
int frames = 60;

//Language Reference:  https://processing.org/reference/

PrintWriter debugoutput;

boolean keyMap[] = new boolean[256];
boolean fullReset = true;
/*gameHandler is an instance of Game and used for the general game control*/

Game gameHandler;


void setup()
{
  debugoutput = createWriter(".debug.log");

  frameRate(60);

  /*DEBUG*/
  debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Main: Initialized Window");

  //display
  surface.setResizable(false);
  surface.setSize(1400, 1400);

}

/*Update loop*/
void draw(){
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
void keyPressed()
{
  if(key != CODED) //if we detect a key press which is not a CODED key (=win, alt etc.) the key is marked in our key map
    keyMap[key]=true;
}

void keyReleased() {
  if(key != CODED)//if a key is released, we remeber the key, so that we can release it in our key map next cycle (1cylce= 1 pacman move)
    keyMap[key]=false;
}



void exit() {
  debugoutput.println("Exiting...");
  debugoutput.flush();
  debugoutput.close();
  super.exit();
}
