// ワールドデータを管轄するクラス

class World
{
  PShader worldShader;
  Player player;
  PVector diffuseLightDir;
  PVector ambient;
  boolean existActivatedFacility;
  boolean[] activatedState;
  PVector deactivatedCamera[]; // 0: pos, 1: direction
  PVector activatedCamera[];
  final int ACTIVATION_TIME = 20; // フレーム単位
  int startEasingFrame;
  PImage eventImage;
  

  Room room;
  gazoukakouEnclosure gazoukakou;
  IP_LocateEnclosure ipLocate;
  MachinationEnclosure machination;


  World(PApplet _this)
  {
    worldShader = loadShader("shaders/default.frag", "shaders/default.vert");
    player = new Player(_this);
    diffuseLightDir = new PVector(1.0, -1.0, 1.0);
    diffuseLightDir.normalize();
    ambient = new PVector(0.7, 0.7, 0.7);
    existActivatedFacility = false;
    activatedState = new boolean[3];
    deactivatedCamera = new PVector[2];
    activatedCamera = new PVector[2];
    startEasingFrame = -ACTIVATION_TIME;
    eventImage = null;

    room = new Room();
    gazoukakou = new gazoukakouEnclosure();
    ipLocate = new IP_LocateEnclosure();
    machination = new MachinationEnclosure();
  }

  void begin(PGraphics _tg, boolean _left)
  {
    worldShader.set("ambient", ambient);
    worldShader.set("lightDir", diffuseLightDir);
    _tg.shader(worldShader);

    if(_left)
    {
      player.beginLeft(_tg);
    }
    else
    {
      player.beginRight(_tg);
    }
  }

  void update()
  {
    // Player
    player.update();
    if(!existActivatedFacility)
    {
      float t = easeInCubic(min(float(frameCount - startEasingFrame) / ACTIVATION_TIME, 1.0));
      if(startEasingFrame != -ACTIVATION_TIME && t != 1.0)
      {
        player.pos = PVector.lerp(activatedCamera[0], deactivatedCamera[0], t);
        player.direction = PVector.lerp(activatedCamera[1], deactivatedCamera[1], t);
      }
      
      if(t == 1.0)
      {
        player.moveByStick();
        float r = abs(sensorR) * 4 < 1.0 ? 0.0 : sensorR * 4;
        float p = abs(sensorP) * 4 < 1.0 ? 0.0 : sensorP * 4;
        float y = abs(sensorY) * 4 < 1.0 ? 0.0 : sensorY * 4;
        player.rotateFromRadians(p, r, y); // 補正値込みでそれっぽく見せる
      }
    }
    else
    {
      float t = easeInCubic(min(float(frameCount - startEasingFrame) / ACTIVATION_TIME, 1.0));
      player.pos = PVector.lerp(deactivatedCamera[0], activatedCamera[0], t);
      player.direction = PVector.lerp(deactivatedCamera[1], activatedCamera[1], t);
      
      if(!gazoukakou.isActivated != !activatedState[0])
      {
        existActivatedFacility = false;
        startEasingFrame = frameCount;

        eventImage = gazoukakou.outputImage();
      }
      if(!ipLocate.isActivated != !activatedState[1])
      {
        existActivatedFacility = false;
        startEasingFrame = frameCount;

        eventImage = ipLocate.outputImage();
      }
      if(!machination.isActivated != !activatedState[2])
      {
        existActivatedFacility = false;
        startEasingFrame = frameCount;

        eventImage = machination.outputImage();
      }
    }

    setPlayerPosInBounds();
    
    // Room
    room.update(eventImage);

    // gazoukakouEnclosure
    gazoukakou.update();
    gazoukakou.control(player);

    // IP_LocateEnclosure
    ipLocate.update();
    ipLocate.control(player);

    // AkatsukaEnclosure
    machination.update();
    machination.control(player);
    
    // 各施設とプレイヤーが接近しているかどうか
    if(!existActivatedFacility)
    {
      int A = player.BUTTON_NAME_TO_INDEX.get("A");
      // gazoukakou
      if(gazoukakou.getCloser(player))
      {
        pushDebugInfo("Get Closer: Gazoukakou.");
        if(player.buttonPressed[A])
        {
          existActivatedFacility = true;
          deactivatedCamera[0] = player.pos.copy();
          deactivatedCamera[1] = player.direction.copy();
          startEasingFrame = frameCount;

          gazoukakou.isActivated = true;
          setActivatedState();
          activatedCamera = gazoukakou.getScreenCamera(new PVector(gazoukakou.INIT_POS, 0.0, 0.0));
        }
      }

      // IP_Locate
      if(ipLocate.getCloser(player))
      {
        pushDebugInfo("Get Closer: IP_Locate.");
        if(player.buttonPressed[A])
        {
          existActivatedFacility = true;
          deactivatedCamera[0] = player.pos.copy();
          deactivatedCamera[1] = player.direction.copy();
          startEasingFrame = frameCount;

          ipLocate.isActivated = true;
          setActivatedState();
          activatedCamera = ipLocate.getScreenCamera(new PVector(ipLocate.INIT_POS, 0.0, 0.0));
        }
      }

      // Machination
      if(machination.getCloser(player))
      {
        pushDebugInfo("Get Closer: Machination.");
        if(player.buttonPressed[A])
        {
          existActivatedFacility = true;
          deactivatedCamera[0] = player.pos.copy();
          deactivatedCamera[1] = player.direction.copy();
          startEasingFrame = frameCount;

          machination.isActivated = true;
          setActivatedState();
          activatedCamera = machination.getScreenCamera(new PVector(machination.INIT_POS_X, machination.INIT_POS_Y, 0.0));
        }
      }
    }
  }

  void draw(PGraphics _tg)
  {
    _tg.pushMatrix();

    room.draw(_tg, ambient, diffuseLightDir);

    gazoukakou.draw(_tg);
    ipLocate.draw(_tg);
    machination.draw(_tg);

    _tg.popMatrix();
  }


  // 有効化状況を取得
  void setActivatedState()
  {
    activatedState[0] = gazoukakou.isActivated;
    activatedState[1] = ipLocate.isActivated;
    activatedState[2] = machination.isActivated;
  }


  // プレイヤーの移動制限
  void setPlayerPosInBounds()
  {
    // X軸の制限
    if(player.pos.x < room.MOVABLE_AREA_POINTS[2].x + player.DISTANCE_BETWEEN_EYES * 2)
    {
      player.pos.x = room.MOVABLE_AREA_POINTS[2].x + player.DISTANCE_BETWEEN_EYES * 2;
    }
    else if(room.MOVABLE_AREA_POINTS[0].x - player.DISTANCE_BETWEEN_EYES * 2 < player.pos.x)
    {
      player.pos.x = room.MOVABLE_AREA_POINTS[0].x - player.DISTANCE_BETWEEN_EYES * 2;
    }

    // Y軸の制限
    if(player.pos.y < room.MOVABLE_AREA_POINTS[0].y + player.DISTANCE_BETWEEN_EYES * 2)
    {
      player.pos.y = room.MOVABLE_AREA_POINTS[0].y + player.DISTANCE_BETWEEN_EYES * 2;
    }
    else if(room.MOVABLE_AREA_POINTS[1].y - player.DISTANCE_BETWEEN_EYES * 2 < player.pos.y)
    {
      player.pos.y = room.MOVABLE_AREA_POINTS[1].y - player.DISTANCE_BETWEEN_EYES * 2;
    }
  }
}
