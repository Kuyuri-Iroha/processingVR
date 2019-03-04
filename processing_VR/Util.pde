// 単体で動作する機能をまとめたクラス

// 単体で動作する機能郡
static class Util
{
  // 影用ガウシアンブラーウェイト
  static final float[] SHADOW_GAUSSIAN_WEIGHT = calcGaussianWeight(5.0);
  
  // ジャギー回避用デルタ
  static final float DELTA_POSITION = 1e-2;
  
  // ガウシアンブラー用のウェイト算出
  static float[] calcGaussianWeight(float sigma)
  {
    float[] output = new float[10];
    
    float t = 0.0;
    float c2 = sigma * sigma;
    for(int i = 0; i < output.length; i++)
    {
      float r = 1.0 + 2.0 * i;
      float w = exp((r * r) * -0.5 / c2);
      output[i] = w;
      if(0 < i) {w *= 2.0;}
      t += w;
    }
    
    for(int i = 0; i < output.length; i++)
    {
      output[i] /= t;
    }
    
    return output;
  }
  
  // 床の描画
  static final PVector FLOOR_SIZE = new PVector(1000, 1000);
  static void drawFloor(PGraphics _tg)
  {
    _tg.fill(#ff00ff);
    _tg.stroke(#0f0f0f);
    _tg.sphere(2);
  
    _tg.fill(250);
    _tg.noStroke();
    _tg.beginShape();
    _tg.vertex(-FLOOR_SIZE.x, -FLOOR_SIZE.y, 0);
    _tg.vertex(FLOOR_SIZE.x, -FLOOR_SIZE.y, 0);
    _tg.vertex(FLOOR_SIZE.x, FLOOR_SIZE.y, 0);
    _tg.vertex(-FLOOR_SIZE.x, FLOOR_SIZE.y, 0);
    _tg.endShape(CLOSE);
  }
}


// 板ポリの作成
PShape createPlane(float _x1, float _z1, float _x2, float _z2, float _y, PImage _texture)
{
  return createPlane(new PVector(_x1, _y, _z1), new PVector(_x2, _y, _z1), new PVector(_x2, _y, _z2), new PVector(_x1, _y, _z2), _texture);
}

PShape createPlane(PVector _p1, PVector _p2, PVector _p3, PVector _p4, PImage _texture)
{
  textureMode(NORMAL);
  PShape plane = createShape();

  plane.beginShape();
  plane.noStroke();
  plane.texture(_texture);
  plane.vertex(_p1.x, _p1.y, _p1.z, 0.0, 0.0);
  plane.vertex(_p2.x, _p2.y, _p2.z, 1.0, 0.0);
  plane.vertex(_p3.x, _p3.y, _p3.z, 1.0, 1.0);
  plane.vertex(_p4.x, _p4.y, _p4.z, 0.0, 1.0);
  plane.endShape();

  return plane;
}
