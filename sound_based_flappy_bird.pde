import processing.sound.*;

AudioIn input;
Amplitude loudness;

void setup(){
  fullScreen();
  printArray(Sound.list());
  input = new AudioIn(this, 0);
  input.start();
  loudness = new Amplitude(this);

  // Patch the input to the volume analyzer
  loudness.input(input);
  lastPipe=height-100;
  meter=loadImage("data/meter.png");
  meter.resize(20,height);
  //pipes.add(new Pipe(600));
}

int birdY=50,ls,lastPipe=height-100,ativeThreshold=5000,gravity=5,nextbounce,score,highscore;
ArrayList<Pipe> pipes =new ArrayList<>();
PImage meter;

void draw(){
  background(#4BB8FF);
  float inputLevel = map(mouseY, 0, height, 1.0, 0.0);
  input.amp(inputLevel);
  float volume = loudness.analyze();
  int size = int(map(volume, 0, 0.5, 1, 350)*1000);
  fill(255,255,0);
  
  circle(100,height-birdY,50);
  for(int i=0;i<pipes.size();i++){
    pipes.get(i).move();
  }
  if(pipes.size()>0&&pipes.get(0).pos==width){
   pipes.remove(0); 
  }
  if(pipes.size()>0&&!pipes.get(0).passed){
    if(pipes.get(0).pos>width-125){
      pipes.get(0).passed=true;
      //println(birdY-50+" "+(pipes.get(0).height-50) +" "+ (birdY+50) +" " + (pipes.get(0).height+150)+" "+pipes.get(0).height);
      if(birdY-50>height-pipes.get(0).height-50 && birdY+50<height-pipes.get(0).height+150){//the bird made it through
        score++;
      }else{
        score=0;
      }
    }
  }
  
  if(birdY>0){//gravity
    birdY-=gravity;
  }
  
  if(nextbounce<millis() && size>ativeThreshold){//the bird going up
    birdY+=12*gravity;
    nextbounce=millis()+100;//time between bounces
  }
  
  
  fill(0,200,0);
  for(int i=0;i<pipes.size();i++){
    rect(width-pipes.get(i).pos,pipes.get(i).height+50,30,height);//lower pipe
    rect(width-pipes.get(i).pos,pipes.get(i).height-150,30,-height);
  }
 
  if(ls<millis()){
    ls=millis()+2000;
    pipes.add(new Pipe((int)random(max(lastPipe-150,100),min(lastPipe+150,height-100))));
    lastPipe=pipes.get(pipes.size()-1).height;
  }


  float metermax=60000;
  float relvol=size/metermax;
  fill(255,255,160);
  clip(width-60,height-height*relvol,50,height);
  image(meter,width-30,0);
  image(meter,width-60,0);
  noClip();
  fill(0);
  rect(width-5,height-height*(ativeThreshold/metermax),-60,5);
  
  textAlign(CENTER,CENTER);
  fill(255);
  textSize(100);
  text(score,width/2,height*0.15);
  textSize(40);
  highscore=max(highscore,score);
  text("High Score: "+highscore,width/2,height*0.22);
  
}

class Pipe{
  int pos,height;
  boolean passed=false;
  Pipe(int h){
    height=h;
    pos=0;
  }
  void move(){
    pos+=5;
  }
}
