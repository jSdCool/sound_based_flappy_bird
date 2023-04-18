import processing.sound.*;

AudioIn input;
Amplitude loudness;

void setup(){
  fullScreen();
  input = new AudioIn(this, 0);
  input.start();
  loudness = new Amplitude(this);

  // Patch the input to the volume analyzer
  loudness.input(input);
  
  pipes.add(new Pipe(600));
}

int birdY=50,ls,last  Pipe=600;
ArrayList<Pipe> pipes =new ArrayList<>();

void draw(){
  background(#4BB8FF);
  float inputLevel = map(mouseY, 0, height, 1.0, 0.0);
  input.amp(inputLevel);
  float volume = loudness.analyze();
  int size = int(map(volume, 0, 0.5, 1, 350));
  fill(255,255,0);
  
  circle(100,height-birdY,50);
  for(int i=0;i<pipes.size();i++){
    pipes.get(i).move();
  }
  if(pipes.get(0).pos==width){
   pipes.remove(0); 
  }
  
  if(birdY>0){
    birdY-=10;
  }
  println(size);
  if(size>5){
    birdY+=15;
  }
  fill(0,200,0);
  for(int i=0;i<pipes.size();i++){
    rect(width-pipes.get(i).pos,pipes.get(i).height,30,height);
    rect(width-pipes.get(i).pos,pipes.get(i).height-150,30,-height);
  }
 
  if(ls<millis()){
    ls=millis()+1000;
    pipes.add(new Pipe((int)random(100,680)));
  }
  
  
}

class Pipe{
  int pos,height;
  Pipe(int h){
    height=h;
    pos=0;
  }
  void move(){
    pos+=5;
  }
}
