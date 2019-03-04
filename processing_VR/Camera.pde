// カメラの基本機能クラス

class Camera
{
  final PVector INIT_POS = new PVector(0, -100, 40);
  final PVector INIT_CENTER = new PVector(0, -90, 40);
  final PVector INIT_UP = new PVector(0, 0, -1);
  final PVector INIT_DIRECTION = new PVector(0, 1, 0);
  final float SIGHT_LENGTH = 10;
  final float DISTANCE_BETWEEN_EYES = 1.0;
  PVector pos;
  PVector center;
  PVector up;
  PVector baseDirection;
  PVector direction;
  float fov;
  float near;
  float far;
  
  Camera()
  {
    pos = INIT_POS.copy();
    center = INIT_CENTER.copy();
    up = INIT_UP.copy();
    baseDirection = INIT_DIRECTION.copy();
    direction = INIT_DIRECTION.copy();
    
    fov = radians(70);
    near = 1;
    far = 10000;
  }
  
  void beginRight(PGraphics _tg)
  {
    updateCenterFromDirection();

    // 右目の位置を算出
    PVector directionNormal = direction.cross(up);
    directionNormal.normalize();

    PVector rightPos = pos.copy();
    rightPos.add(directionNormal.mult(-DISTANCE_BETWEEN_EYES));

    pushDebugInfo("RightEyePos: " + rightPos.toString());

    _tg.beginCamera();
    _tg.camera(rightPos.x, rightPos.y, rightPos.z, center.x, center.y, center.z, up.x, up.y, up.z);
    _tg.perspective(fov, (width / 2.0) / height, near, far);
  }

  void beginLeft(PGraphics _tg)
  {
    updateCenterFromDirection();

    // 左目の位置を算出
    PVector directionNormal = direction.cross(up);
    directionNormal.normalize();

    PVector leftPos = pos.copy();
    leftPos.add(directionNormal.mult(DISTANCE_BETWEEN_EYES));

    pushDebugInfo("LeftEyePos: " + leftPos.toString());

    _tg.beginCamera();
    _tg.camera(leftPos.x, leftPos.y, leftPos.z, center.x, center.y, center.z, up.x, up.y, up.z);
    _tg.perspective(fov, (width / 2.0) / height, near, far);
  }


  void updateCenterFromDirection()
  {
    center = PVector.add(pos, PVector.mult(direction, SIGHT_LENGTH));
  }
  
  void rotateFromRadians(float _xRot, float _yRot, float _zRot)
  {
    // rotate direction.
    PMatrix3D rot = new PMatrix3D();
    PVector tmp = new PVector();

    PVector zRotAxis = up;
    rot.rotate(radians(_zRot), zRotAxis.x, zRotAxis.y, zRotAxis.z);
    tmp = rot.mult(baseDirection, null);
    PVector xRotAxis = tmp.cross(up);
    rot.rotate(radians(_xRot), xRotAxis.x, xRotAxis.y, xRotAxis.z);
    tmp = rot.mult(tmp, null);

    direction = tmp;
    
    // rotate up.
    if(PConstants.EPSILON < abs(_yRot))
    {
      rot.rotate(radians(_yRot), direction.x, direction.y, direction.z);
      up = rot.mult(INIT_UP, null);
    }
  }
  
  void rotateBaseFromRadians(float _xRot, float _zRot)
  {
    // rotate direction.
    PMatrix3D rot = new PMatrix3D();
    PVector axis = new PVector(_xRot, 0, _zRot);
    float angle = axis.mag();
    
    rot.rotate(radians(angle), axis.x, axis.y, axis.z);
    baseDirection = rot.mult(INIT_DIRECTION, null);
  }
  
  void moveFromVel(float _x, float _y, float _z)
  {
    PVector move = new PVector(_x, _y, _z);
    PMatrix3D rot = new PMatrix3D();
    PVector axis = INIT_DIRECTION.cross(direction);
    float angle = PVector.angleBetween(INIT_DIRECTION, direction);
    
    rot.rotate(angle, axis.x, axis.y, axis.z);
    pos.add(rot.mult(move, null));
  }
  
  void moveFromVelOnXY(float _x, float _y)
  {
    PVector move = new PVector(_x, _y, 0);
    PMatrix3D rot = new PMatrix3D();
    PVector xyDirection = direction.copy();
    xyDirection.z = 0.0;
    PVector axis = INIT_DIRECTION.cross(xyDirection);
    float angle = PVector.angleBetween(INIT_DIRECTION, xyDirection);
    
    rot.rotate(angle, axis.x, axis.y, axis.z);
    pos.add(rot.mult(move, null));
  }
}
