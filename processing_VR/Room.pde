// 部屋の3Dモデルの表示

class Room
{
  PShape floor;
  PShape[] walls;
  PShape celling;
  PShape screen;
  PGraphics screenTarget;
  PShape screenPlane;
  boolean isScreenGraphic;
  final PVector[] MOVABLE_AREA_POINTS;
  
  Room()
  {
    MOVABLE_AREA_POINTS = new PVector[] {
      new PVector(114, -100, 0),
      new PVector(114, 90, 0),
      new PVector(-114, 90, 0),
      new PVector(-114, -100, 0)
    };
    
    init();
  }
  
  void init()
  {
    floor = loadShape("models/room/floor.obj");
    walls = new PShape[4];
    for(int i = 1; i <= walls.length; i++)
    {
      walls[i-1] = loadShape("models/room/wall_" + i + ".obj");
    }
    celling = loadShape("models/room/celling.obj");
    screen = loadShape("models/room/screen.obj");
    screenTarget = createGraphics(1280, 720, P2D);
    screenTarget.beginDraw();
    screenTarget.background(#fafafa); // テスト用
    screenTarget.endDraw();
    screenPlane = createPlane(58.200001, 104.266983, -58.200001, 38.791981, 95.335732 - Util.DELTA_POSITION, screenTarget);
    isScreenGraphic = false;
  }
  
  void update(PImage _eventImage)
  {
    screenTarget.beginDraw();
    float bright = (sin(radians(frameCount)) + 1.0) / 2.0 * 255;
    screenTarget.background(bright, bright, bright);
    screenTarget.textSize(180);
    screenTarget.textAlign(CENTER, CENTER);
    screenTarget.fill(255 - bright);
    if(_eventImage != null)
    {
      screenTarget.imageMode(CENTER);
      screenTarget.image(_eventImage, screenTarget.width / 2, screenTarget.height / 2, float(_eventImage.width) / _eventImage.height * screenTarget.height, screenTarget.height);
    }
    else
    {
      screenTarget.text("Hello World!", screenTarget.width / 2, screenTarget.height / 2);
    }
    screenTarget.endDraw();
  }
  
  void draw(PGraphics _tg, PVector _ambient, PVector _diffuseLightDir)
  {
    _tg.resetShader();
    _tg.pushMatrix();

    // Roomシェイプの描画
    _tg.shape(floor);
    for(int i = 0; i < walls.length; i++)
    {
      _tg.shape(walls[i]);
    }
    _tg.shape(celling);
    _tg.shape(screen);
    
    // スクリーンの描画
    _tg.shape(screenPlane);

    _tg.popMatrix();
    _tg.shader(currentShader);
  }
}
