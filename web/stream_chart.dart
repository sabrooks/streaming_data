import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('stream-chart')
class StreamChart extends PolymerElement {
  @observable List<num> data = toObservable([]);
  num spacing = 10;
  num scale = 1;
  num window_length = 40;

  CanvasElement canvas;
  CanvasRenderingContext2D ctx;

  StreamChart.created() : super.created() {
    // get canvas and context
    canvas = shadowRoot.querySelector('#stream');
    ctx = canvas.getContext('2d') as CanvasRenderingContext2D; // makes type checker happy
    ctx.globalAlpha = 0.2;
  }
  
  void attached(){
    super.attached();
    draw();
  }
  
  void draw(){
    print("draw");
    ctx.beginPath();
    int index = 0;
    for(num dataPoint in data){
      ctx.lineTo(index*spacing, canvas.height/2 + scale*dataPoint);
      index++;
    }
    ctx.stroke();
  }
  
  void drawCanvas( CustomEvent e, var detail, Node target){
    print("draw");
    ctx.beginPath();
    int index = 0;
    for(num dataPoint in data){
      ctx.lineTo(index*spacing, canvas.height/2 + scale*dataPoint);
      index++;
    }
    ctx.stroke();
  }
  
  /*drawList(){
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    for(List data in queueList){
      draw(data);
    }
  }
  * 
   */
  
 /* advance(){
    //need to improve responsiveness.  Quick changes can lead to stray lines.
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    dataQueue.removeLast();
    for(List data in queueList){
     data.add(data.first);
     data.removeAt(0);
    }
    drawList();
  }
  
  horizontalIncScale(){
    numPeriods += 1;
    window_length = numPeriods*period;
    spacing=canvas.width/window_length;
    drawList();
  }
  
 Future <num> initScale(){
   var completer = new Completer ();
   
   stream.take(window_length*5)
          .toList();
          //.then((List<num> initStream){
          //   scale = 1.2*minMax(initStream);
         //    });
   return completer.future;
 }
 
num minMax(List<num> dataSet){
   num min = 0; 
   num max = 0;
   for(num point in dataSet){
     if(point < min){min=point;};
     if(point > max){max=point;};
   }
   print("init scale");
   print(max-min);
   return max-min;
   //return {'min':min, 'max':max}; - returns range values.  
 }
 * 
  */
}