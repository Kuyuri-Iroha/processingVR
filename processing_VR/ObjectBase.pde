// ワールドに設置する物体の基本的な情報、機能をまとめた基底クラス。

// 全てのオブジェクトの基底クラス
abstract class ObjectBase
{
  final int SHADOW_TEXTURE_SIZE = 30;
  final color SHADOW_COLOR = color(50, 50, 50);
  PVector position;
  PGraphics shadow;
  int shadowSize;
  PVector frontDirection;
  final float ACTIVATION_DISTANCE = 40;
  final float ACTIVATION_ANGLE = PI / 4;
  boolean isActivated;
  PVector screenDirection;
  final float CAMERA_DISTANCE = 15;
  PVector screenCenter;
  
  ObjectBase()
  {
    baseInit(0);
    init();
  }

  ObjectBase(int _shadowSize)
  {
    baseInit(_shadowSize);
    init();
  }
  
  // 基底クラスとしての初期化処理
  void baseInit(int _shadowSize)
  {
    position = new PVector();
    frontDirection = new PVector(0, -1.0, 0);
    isActivated = false;
    screenDirection = new PVector();
    screenCenter = new PVector();
    if(_shadowSize == 0) {_shadowSize = SHADOW_TEXTURE_SIZE;}
    shadow = createGraphics(_shadowSize, _shadowSize, P3D);
    createShadowTexture(_shadowSize);
  }
  
  // 簡易的な影を生成
  void createShadowTexture(int _shadowSize)
  {
    PShader gaussianShader = loadShader("shaders/gaussian.frag");
    gaussianShader.set("weight", Util.SHADOW_GAUSSIAN_WEIGHT);
    gaussianShader.set("resolution", shadow.width, shadow.height);
    
    shadow.beginDraw();
    shadow.clear();
    
    final float ellipseSize = float(_shadowSize) / 2;
    shadow.fill(SHADOW_COLOR);
    shadow.noStroke();
    shadow.ellipse(shadow.width / 2, shadow.height / 2, ellipseSize, ellipseSize);
    shadow.endDraw();
    
    shadow.beginDraw();
    gaussianShader.set("tex", shadow);
    gaussianShader.set("horizontal", true);
    shadow.filter(gaussianShader);
    gaussianShader.set("horizontal", false);
    shadow.filter(gaussianShader);
    shadow.endDraw();
  }
  
  
  // 簡易的な影を描画
  void drawShadow(PGraphics _target)
  {
    _target.pushMatrix();
    
    _target.imageMode(CENTER);
    _target.translate(0.0, 0.0, Util.DELTA_POSITION);
    _target.resetShader();
    _target.image(shadow, 0, 0);
    _target.shader(currentShader);
    
    _target.popMatrix();
  }
  
  
  // プレイヤーが接近したかどうかを判定
  boolean getCloser(Player _player)
  {
    PVector playerInvDir = PVector.mult(_player.direction, -1);

    return (abs(PVector.angleBetween(playerInvDir, frontDirection)) < ACTIVATION_ANGLE) &&
      (PVector.dist(new PVector(_player.pos.x, _player.pos.y, 0.0), new PVector(position.x, position.y, 0.0)) < ACTIVATION_DISTANCE);
  }


  // アクティブ時のカメラの位置と方向を取得
  PVector[] getScreenCamera(PVector _facilityPos)
  {
    PVector[] cameraData = new PVector[2];
    cameraData[0] = PVector.add(PVector.add(screenCenter, PVector.mult(screenDirection, -CAMERA_DISTANCE)), _facilityPos);
    cameraData[1] = screenDirection;
    
    return cameraData;
  }
  
  abstract void init();
  
  abstract void update();
  
  abstract void draw(PGraphics _target);
}
