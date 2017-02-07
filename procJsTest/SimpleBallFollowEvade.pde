/* Version 2.0 1/12/17
   > Added support for bounding circle via Processing 3 dist function
   > Added keyPress support for increasing/decreasing bound range
   > Moved bounding rect check from Ball object code, placed into
     external function 'mouseOverMe'
*/

Ball myBall;
int pxCollide = 50;

// Mode Constants (could belong to object, not as global)
final int MODE_FOLLOW = 0;
final int MODE_EVADE  = 1;
final int BOUND_RECT = 0;
final int BOUND_CIRC = 1;

void setup(){
  size(400,400);
  ellipseMode(CENTER);
  myBall = new Ball(width/2,height/2);
} // Ends Function setup

void draw(){
  background(0);
  myBall.update();
  myBall.render(); 
} // Ends Function draw

void keyPressed(){
  if      (key=='f'){myBall.mode_behavior=MODE_FOLLOW;}
  else if (key=='e'){myBall.mode_behavior=MODE_EVADE;}
  else if (key=='c'){myBall.mode_bounds=BOUND_CIRC;}
  else if (key=='r'){myBall.mode_bounds=BOUND_RECT;}  
  else if (keyCode==38 && pxCollide<100){pxCollide++;}
  else if (keyCode==40 && pxCollide>1){pxCollide--;}
} // Ends Function keyPressed

boolean mouseOverMe(int x, int y){
  return (abs(x-mouseX))<pxCollide && abs(y-mouseY)<pxCollide;
} // Ends Function mouseOverMe

class Ball{
  int X,Y;
  int mode_behavior;
  int mode_bounds;

  public Ball(int xI, int yI){
    this.X=xI;
    this.Y=yI;
    this.mode_behavior= MODE_FOLLOW;
    this.mode_bounds = BOUND_CIRC;
  } // Ends Constructor

  public void update(){
    if(mode_bounds == BOUND_CIRC && dist(X,Y,mouseX,mouseY)<pxCollide){
      if(mode_behavior==MODE_EVADE){modeEvade();}
      else if(mode_behavior==MODE_FOLLOW){modeFollow();}    
    }
    
    if(mode_bounds == BOUND_RECT && mouseOverMe(X,Y)){
      if(mode_behavior==MODE_EVADE){modeEvade();}
      else if(mode_behavior==MODE_FOLLOW){modeFollow();}
    }
  } // Ends Function update

  public void modeEvade(){
    if( (mouseX-X)<0){this.X+=2;}
    else if ( (mouseX-X)>0){this.X-=2;}
    
    if( (mouseY-Y)<0){this.Y+=2;}
    else if ( (mouseY-Y)>0){this.Y-=2;}
  } // Ends Function modeEvade

  public void modeFollow(){
    if( (mouseX-X)<0){this.X-=2;}
    else if ( (mouseX-X)>0){this.X+=2;}
    
    if( (mouseY-Y)<0){this.Y-=2;}
    else if ( (mouseY-Y)>0){this.Y+=2;}
  } // Ends Function modeFollow

  public void render(){
    
    // VFX for Ball's Representation
    stroke(0,120,255);
    fill(255,120,0);
    ellipse(X,Y,10,10);

    // VFX for Ball's Bounding Shape
    noFill();
    stroke(255);
    
    if(mode_bounds == BOUND_CIRC){
      ellipse(X,Y,pxCollide*2,pxCollide*2);
      if(dist(X,Y,mouseX,mouseY)<pxCollide){line(X,Y,mouseX,mouseY);}
    }
    if(mode_bounds == BOUND_RECT){
      rect(X-pxCollide,Y-pxCollide,pxCollide*2,pxCollide*2);
      if(mouseOverMe(X,Y)){line(X,Y,mouseX,mouseY);}
    }
    
  } // Ends Function render

} // Ends Class Ball