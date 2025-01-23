////////////////////////////////////////////////////////////////////////////////////////////////////////////

boolean gametime = false;
String gameInitiateCode = "69420";
boolean firstTime2=true, gameNotRunning = true, buttonFirstClick = false;
void GameRedirect() {
  if (firstTime2) {
    if (gameNotRunning) firstTime2 = !firstTime2;
    GameSetupMenu();                   //idk why this one here works when i thought it should be inside the second if 
  } else {
    RunGamePortal();
  }
}

void GameSetupMenu() {
  removeButtons();
  background(0);
  screenFix();
  JOptionPane.showMessageDialog(frame, "Press the 'f key to return to the main screen.", "Instructions", JOptionPane.OK_OPTION);
  TitleScreenButtons();
}

void removeButtons() {
  bjan.setPosition(10000, 10000);
  bfeb.setPosition(10000, 10000);
  bmar.setPosition(10000, 10000);
  bapr.setPosition(10000, 10000);
  bmay.setPosition(10000, 10000);
  bjun.setPosition(10000, 10000);
  bjul.setPosition(10000, 10000);
  baug.setPosition(10000, 10000);
  boct.setPosition(10000, 10000);
  bsep.setPosition(10000, 10000);
  bnov.setPosition(10000, 10000);
  bdec.setPosition(10000, 10000);
  bbar.setPosition(10000, 10000);
  bpie.setPosition(10000, 10000);
  byear.setPosition(10000, 10000);
  bline.setPosition(10000, 10000);
  breset.setPosition(10000, 10000);
  bscatter.setPosition(10000, 10000);
  bmaxtemp.setPosition(10000, 10000);
  bmintemp.setPosition(10000, 10000);
  bsnowfall.setPosition(10000, 10000);
  bdatainfo.setPosition(10000, 10000);
  binstructions.setPosition(10000, 10000);
}

void screenFix() {
  surface.setResizable(true);
  surface.setSize(1440, 800);
  surface.setResizable(false);
}
