// gazoukakouEnclosure.pde
// gazoukakou.pdeの動作筐体クラス

class gazoukakouEnclosure extends ObjectBase
{
  gazoukakou yoshida;
  PGraphics screenTarget;
  PShape screen;
  PShape[] enclosure;
  final float INIT_POS = -114.678291;
  final float INIT_POS_CENTER = -114.678291 + 9.60628;

  gazoukakouEnclosure()
  {
    super(60);
  }
  
  void init()
  {
    yoshida = new gazoukakou();
    screenTarget = createGraphics(720, 720, P2D);
    screenTarget.beginDraw();
    screenTarget.background(#000000);
    screenTarget.endDraw();
    yoshida.tg = screenTarget;
    screen = createPlane(
      new PVector(1.100349 + Util.DELTA_POSITION, 0.962958, 4.556612 + Util.DELTA_POSITION),
      new PVector(1.100349 + Util.DELTA_POSITION, -0.942160, 4.556612 + Util.DELTA_POSITION),
      new PVector(2.208166 + Util.DELTA_POSITION, -0.942160, 3.173538 + Util.DELTA_POSITION),
      new PVector(2.208166 + Util.DELTA_POSITION, 0.962958, 3.173538 + Util.DELTA_POSITION),
      screenTarget);
    screen.scale(8);

    // スクリーンの方向ベクトル
    PVector v1 = PVector.sub(screen.getVertex(1), screen.getVertex(3));
    PVector v2 = PVector.sub(screen.getVertex(0), screen.getVertex(2));
    screenDirection = v1.cross(v2);
    screenDirection.normalize();

    // スクリーンの中心位置
    screenCenter = PVector.mult(PVector.add(PVector.mult(screen.getVertex(0), 8), PVector.mult(screen.getVertex(2), 8)), 0.5);
    
    // 3Dモデルのロード
    enclosure = new PShape[7];
    for(int i = 1; i <= enclosure.length; i++)
    {
      enclosure[i - 1] = loadShape("models/vending-kisosk/vending-kisosk" + i + ".obj");
      enclosure[i - 1].scale(8);
    }

    // 施設の向いている方向
    frontDirection.set(1.0, 0.0, 0.0);
  }
  
  void update()
  {
    if(isActivated)
    {
      screenTarget.beginDraw();
      screenTarget.imageMode(CORNERS);
      screenTarget.translate(0, 130);
      screenTarget.scale(0.7);
      yoshida.run();
      screenTarget.endDraw();
    }

    position.x = INIT_POS_CENTER;
  }
  
  void draw(PGraphics _tg)
  {
    _tg.resetShader();
    _tg.pushMatrix();
    
    _tg.translate(INIT_POS, 0.0, 0.0);
    for(PShape frame : enclosure)
    {
      _tg.shape(frame);
    }
    _tg.shape(screen);
    
    _tg.translate(INIT_POS_CENTER - INIT_POS, 0.0, 0.0);
    drawShadow(_tg);

    _tg.popMatrix();
    _tg.shader(currentShader);
  }
  
  
  // ボタン入力の取得
  void control(Player _player)
  {
    if(isActivated)
    {
      isActivated = !yoshida.buttonPressed(_player);
    }
  }

  
  // 外部スクリーンに出力
  PImage outputImage()
  {
    return yoshida.getData();
  }
}
