import 'dart:async';
import 'dart:math';

Stream<num> dataStream (Duration interval, num window_length,[int maxCount]){
  StreamController<num> controller;
  Timer timer;
  int counter = 0;
  Random generator = new Random ();
  num frequency = 2*PI/window_length;
  
  void tick(_){
    counter++;
    controller.add(10*sin(frequency*counter)+2*(generator.nextDouble()-0.5));
    if(maxCount != null && counter >=maxCount){
      timer.cancel();
      controller.close();
    }
  }
  
  void startTimer(){
    timer = new Timer.periodic(interval, tick);
  }
  
  void stopTimer(){
    if(timer != null){
      timer.cancel();
      timer =null;
    }
  }
  
  controller = new StreamController<num>(
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
      onCancel: stopTimer);
 
  
  return controller.stream;
}