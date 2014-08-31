import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:math';
import 'dart:async';

//import '../lib/ball.dart';

/**
 * A Polymer canvas element.
 */
@CustomTag('canvas-line')
 class CanvasLine extends CanvasElement with Polymer, Observable {
  @published String fill = "red";
  @published String stroke ="#000000";
  CanvasRenderingContext2D _context;
  Timer timer;
  int dx =2;
  int dy =4;
  int _x,_y,_z;
 // Ball ball;
  final bool check = false;
  static const int RACKET_W = 75;
  static const int RACKET_H = 10;
  

  CanvasLine.created() : super.created() {
    polymerCreated();
  }
  
  
  void attached(){
    super.attached();
    _context = getContext("2d");
    //ball(0,0,10);
    move(0,0,10);
    circle(75, 75, 10);
    rectangle(95,95,20,20);
  }

  void circle(x, y, r){
    _context.beginPath();
    _context.arc(x, y, r, 0, PI*2, true);
    _context.closePath();
    _context.fill();
  }
  
  void rectangle(x, y, w, h){
    _context.beginPath();
    _context.strokeStyle = 'red';
    _context.fillStyle = fill;
    _context.rect(x, y, w, h);
    _context.closePath();
    _context.stroke();
  }
  
  void ball(x, y, r){
    _context.beginPath();
    _context.arc(x,y,r,0,PI*2, true);
    _context.closePath();
    _context.fill();
  }
  
  void racket(x, y, w, h){
    _context.beginPath();
    _context.rect(x, y, w, h);
    _context.closePath();
    _context.fill();
  }
  
  void move(x,y,z){
    _x=x;
    _y=y;
    _z=z;
    timer = new Timer.periodic(const Duration(milliseconds:10),
      (t) => redraw());
  }
  
  void redraw(){
    _context.clearRect(0, 0, width, height);
    ball(_x,_y,_z);
    racket(width/2, height-RACKET_H, RACKET_W, RACKET_H);
    if(_x+dx >width || _x+dx < 0){
      dx=-dx;
    }
    if(_y+dy >height || _y+dy < 0){
      dy=-dy;
    }
    _x+=dx;
    _y+=dy;
  }
  
  void racketMove(event){
    print(event.toString());
  }
}
