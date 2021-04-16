class Ghost {
  protected boolean isAlive;
  protected String name;
  protected int[] position = new int[2];
  protected color ghostColor;

  Ghost(String name, color c1){
    /*DEBUG*/
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Ghost: Initialized Ghost["+name+"]");

    ghostColor=c1;
    this.name = name;
    this.position[0]=13;
    this.position[1]=13;
  }

}
