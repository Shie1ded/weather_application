void RunGamePortal() {
  if (tgravityball) GravityBallGame();
  if(tflappybird) FlappyBirdGame();
  else gameNotRunning = true;
}

void TitleScreenButtons() {
  ControlFont cf1 = new ControlFont(createFont("Times", 14));

  bgravityball = new ControlP5(this);
  bgravityball.addButton("GravityBall").setValue(0).setPosition(25, 50).setSize(125, 50).setColorBackground(color(0, 255, 0)).setFont(cf1);
  
  bflappybird = new ControlP5(this);
  bflappybird.addButton("FlappyBird").setValue(0).setPosition(25,100).setSize(125,50).setColorBackground(color(0,255,0)).setFont(cf1);
}

void YeetDemButtonsBack() {
  background(0);
  screenFix();
  bgravityball.setPosition(25, 50);
  bflappybird.setPosition(25,100);
}

void YeetDemButtons() {
  bgravityball.setPosition(10000, 10000);
  bflappybird.setPosition(10000,10000);
}

void allDemGamesOff() {
  tgravityball = false;
  tflappybird = false;
}

void keyPressed() {
  if (key=='f') {
    allDemGamesOff();
    YeetDemButtonsBack();
    gameNotRunning = true;
    buttonFirstClick = false;
  }
  if(tgravityball) keyPressedGravityBall();
  if(tflappybird) keyPressedFlappyBird();
}

void keyReleased(){
  if(tgravityball) keyReleasedGravityBall();
}
