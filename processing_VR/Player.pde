// プレイヤーの位置情報などの状況やコントローラーからの入力を管理するクラス

class Player extends Camera
{
  ControlIO control;
  ControlDevice device;
  final String[] BUTTON = {"A", "B", "X", "Y", "SL", "SR", "PLUS", "STICK", "HOME", "R", "ZR"};
  final Map<String, Integer> BUTTON_NAME_TO_INDEX;
  boolean[] buttonPressed;
  boolean[] prevButtonPressed;
  PVector stickDirection;
  int stickLeftRight;
  int stickPos;
  int prevStickPos;
  float currentRotateAngle;
  final float MOVE_SPEED = 2;
  final float ROTATE_SPEED = 60;
  
  Player(PApplet _this)
  {
    super();
    
    // コントローラー
    if(USE_JOY_CON_R_CONTROLLER)
    {
      control = ControlIO.getInstance(_this);
      device = control.getMatchedDevice("joy-con-r");
      if(device == null)
      {
        println("!!!!-----No suitable device configured.-----!!!!");
      }
    }
    
    BUTTON_NAME_TO_INDEX = new TreeMap<String, Integer>();
    for(int i = 0; i < BUTTON.length; i++)
    {
      BUTTON_NAME_TO_INDEX.put(BUTTON[i], i);
    }
    buttonPressed = new boolean[BUTTON_NAME_TO_INDEX.size()];
    prevButtonPressed = new boolean[BUTTON_NAME_TO_INDEX.size()];
    stickDirection = new PVector();
    stickLeftRight = -1;
    currentRotateAngle = 0;
  }
  
  void update()
  {
    if(USE_JOY_CON_R_CONTROLLER)
    {
      // ボタンの状態を取得
      prevButtonPressed = buttonPressed.clone();
      for(int i = 0; i < BUTTON_NAME_TO_INDEX.size(); i++)
      {
        buttonPressed[i] = device.getButton(BUTTON[i]).pressed();
      }
    
      // スティックの状態を取得
      prevStickPos = stickPos;
      stickPos = device.getHat("POV").getPos();
      PVector tmpDir = new PVector(-1.0, 0.0);
      stickLeftRight = -1;
      if(stickPos == 2)
      {
        stickLeftRight = 0;
      }
      else if(stickPos == 6)
      {
        stickLeftRight = 1;
      }
      else if(0 < stickPos)
      {
        float angle = float(stickPos) / 8 * TWO_PI + HALF_PI;
        tmpDir.rotate(angle);
        stickDirection = tmpDir.copy();
      }
      else
      {
        stickDirection.set(0, 0);
      }
    }
    
    // ヘッドセットのオフセットのリセットを要請
    final int PLUS = BUTTON_NAME_TO_INDEX.get("PLUS");
    if(buttonPressed[PLUS] && !prevButtonPressed[PLUS])
    {
      sensorReady = false;
    }
  }

  // スティックの入力から移動
  void moveByStick()
  {
    switch(stickLeftRight)
    {
      case 0:
      currentRotateAngle -= ROTATE_SPEED;
      break;

      case 1:
      currentRotateAngle += ROTATE_SPEED;
      break;
    }
    super.rotateBaseFromRadians(0, radians(currentRotateAngle));
    PVector move = PVector.mult(stickDirection, MOVE_SPEED);
    super.moveFromVelOnXY(move.x, move.y);
  }

  // 外部数値からの移動
  void move(float _x, float _y)
  {
    super.moveFromVelOnXY(_x, _y);
  }
}
