class Ghost {
  boolean isAlive;
  String name;
  int[] position = new int[2];


  Ghost(String name){
    /*DEBUG*/
    debugoutput.println(hour()+":"+minute()+":"+second()+"Ghost: Initialized Ghost["+name+"]");
    this.name = name;
    this.position[0]=1;
    this.position[1]=1;
  }



}
