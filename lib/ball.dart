library ball;

import 'dart:html';
import 'dart:math';

class Ball{
  CanvasRenderingContext2D context;
  int x, y, r;
  int dx = 2;
  int dy = 4;
  
  Ball(this.context,[this.x, this.y, this.r]){
    draw();
  }
  
  void draw(){
    context.beginPath();
    context.arc(x,y,r,0,PI*2, true);
    context.closePath();
    context.fill();
  }
  
  /*void move(){
    clear();
    x += dx;
    y += dy;
  }*/
}