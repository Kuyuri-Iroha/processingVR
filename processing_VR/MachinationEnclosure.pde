// Machination.pdeの動作筐体クラス

class MachinationEnclosure extends ObjectBase
{
  Machination akatsuka;
  PGraphics screenTarget;
  PShape screen;
  PShape[] enclosure;
  final float INIT_POS_X = -114.678291;
  final float INIT_POS_Y = -50.0;
  final float INIT_POS_X_CENTER = -114.678291;
  final float INIT_POS_Y_CENTER = -50.0;
  final float SCALE = 1.5;
  boolean firstDraw;

  MachinationEnclosure()
  {
    super(40);
  }

  void init()
  {
    akatsuka = new Machination();
    screenTarget = createGraphics(1524, 800, P2D);
    screenTarget.beginDraw();
    screenTarget.background(#000000);
    screenTarget.endDraw();
    akatsuka.tg = screenTarget;

    screen = createPlane(
      new PVector(7.937802 + Util.DELTA_POSITION, 18.719999, 38.695587),
      new PVector(7.937802 + Util.DELTA_POSITION, -18.719999, 38.695587),
      new PVector(7.937802 + Util.DELTA_POSITION, -18.719999, 12.375586),
      new PVector(7.937802 + Util.DELTA_POSITION, 18.719999, 12.375586),
      screenTarget);
    screen.scale(SCALE);

    // スクリーンの方向ベクトル
    screenDirection.set(-1.0, 0.0, 0.0);

    // スクリーンの中央位置
    screenCenter = PVector.mult(PVector.add(PVector.mult(screen.getVertex(0), SCALE), PVector.mult(screen.getVertex(2), SCALE)), 0.5);
    
    // 3Dモデルのロード
    enclosure = new PShape[2];
    enclosure[0] = loadShape("models/monitor/base.obj");
    enclosure[1] = loadShape("models/monitor/screen.obj");
    enclosure[0].scale(SCALE);
    enclosure[1].scale(SCALE);

    // 施設の向いている方向
    frontDirection.set(1.0, 0.0, 0.0);

    firstDraw = true;
  }

  void update()
  {
    if(isActivated)
    {
      akatsuka.move();
      screenTarget.beginDraw();
      screenTarget.background(#ffffff);
      akatsuka.display();
      screenTarget.endDraw();
    }
    else
    {
      screenTarget.beginDraw();
      if(firstDraw)
      {
        akatsuka.display();
        firstDraw = false;
      }
      screenTarget.endDraw();
    }

    position.x = INIT_POS_X_CENTER;
    position.y = INIT_POS_Y_CENTER;
  }

  void draw(PGraphics _tg)
  {
    _tg.resetShader();
    _tg.pushMatrix();
    
    _tg.translate(INIT_POS_X, INIT_POS_Y, 0.0);
    for(PShape frame : enclosure)
    {
      _tg.shape(frame);
    }
    _tg.shape(screen);
    
    _tg.translate(INIT_POS_X_CENTER - INIT_POS_X, INIT_POS_Y_CENTER - INIT_POS_Y, 0.0);
    drawShadow(_tg);

    _tg.popMatrix();
    _tg.shader(currentShader);
  }


  // ボタン操作
  void control(Player _player)
  {
    if(!isActivated) {return;}
    int B = _player.BUTTON_NAME_TO_INDEX.get("B");
    if(_player.buttonPressed[B] != _player.prevButtonPressed[B])
    {
      if(_player.buttonPressed[B])
      {
        isActivated = false;
      }
    }
  }

  // アクティブ時のカメラの位置と方向を取得
  PVector[] getScreenCamera(PVector _facilityPos)
  {
    PVector[] cameraData = new PVector[2];
    cameraData[0] = PVector.add(PVector.add(screenCenter, PVector.mult(screenDirection, -50)), _facilityPos);
    cameraData[1] = screenDirection;
    
    return cameraData;
  }


  // 外部スクリーンに出力
  PImage outputImage()
  {
    return screenTarget.get(); //上下が反転してしまう
  }
}
