import 'package:polymer/polymer.dart';
import 'dart:collection';
import 'dart:html';
import 'dart:async';
import 'data_stream.dart';

@CustomTag('stream-chart')
class ClickCounter extends PolymerElement {
  @observable bool isPaused = false;
  @observable num interval = 5;
  

  num period = 40;
  num numPeriods = 1;
  num window_length;
  num spacing;
  Queue dataQueue = new Queue<num>();
  List <List> queueList =[];
  Stream<num> stream;
  StreamSubscription<num> subscription;
  CanvasElement canvas;
  CanvasElement background;
  CanvasRenderingContext2D ctx;
  CanvasRenderingContext2D bkg;
  
  num scale = 1;

  ClickCounter.created() : super.created() {
    // get canvas and context
    canvas = shadowRoot.querySelector('#stream');
    background = shadowRoot.querySelector('#background');
    window_length = period*numPeriods;
    spacing=canvas.width/window_length;
    ctx = canvas.getContext('2d') as CanvasRenderingContext2D; // makes type checker happy
    bkg = background.getContext('2d') as CanvasRenderingContext2D
        ..fillStyle = '#fff';
    stream = dataStream(new Duration(milliseconds: interval), period).asBroadcastStream();
    //take 5 periods of stream data.Set display scale.  start subscription to data stream.
    stream.take(window_length*5)
           .toList()
           .then((List<num> initStream){
           scale = .8*canvas.height/minMax(initStream);
          }).then((_){
      subscription = stream.transform(transformer).listen(onData);
    });
    //window.animationFrame.then(animateData);
    bkg.fillRect(0, 0, canvas.width, canvas.height);
    ctx.globalAlpha = 0.2;
  }
  
  speedChanged(){
    subscription.cancel();
    interval = interval*2;
    stream = dataStream(new Duration(milliseconds: interval), window_length);
    subscription = stream
        .listen(onData );
  }
  
  StreamTransformer transformer = new StreamTransformer.fromHandlers(handleData: (value, sink){
    sink.add(value*1);
  });
  
  void draw(List data){
    print("draw");
    ctx.beginPath();
    int index = 0;
    for(num dataPoint in data){
      ctx.lineTo(index*spacing, canvas.height/2 + scale*dataPoint);
      index++;
    }
    ctx.stroke();
  }
  
  void onData(num data){
    
    dataQueue.add(data);
    
    //check if queue is to be added to queueList
    if(dataQueue.length == window_length){
      queueList.add(dataQueue.toList());
      dataQueue.clear();
      print("window_length");
      print(queueList.length);
      print(queueList.first.length);
      //check size of queueList.
      if(queueList.length > 5){
        queueList.removeAt(0);
      }
      drawList();
    }
    else{print(dataQueue.length.toString());}
  }
  
  change(){
    print(interval.toString());
  }
  
  pause(){
    if(subscription.isPaused){
      subscription.resume();
    }else{
      subscription.pause();
      }
    }
  
  drawList(){
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    for(List data in queueList){
      draw(data);
    }
  }
  
  advance(){
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
}