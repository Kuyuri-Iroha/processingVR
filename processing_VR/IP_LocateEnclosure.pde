// IP_Locate.pdeの動作筐体クラス


class IP_LocateEnclosure extends ObjectBase
{
  IP_Locate hamada;
  PShape[] enclosure;
  PImage[] slotImages;
  PGraphics[] slotScreens;
  float[][] slotImagePos;
  PShape[] slots;
  final int SLOT_SCREEN_WIDTH = 140;
  final float INIT_POS = 114.678291;
  final float INIT_POS_CENTER = 114.678291 - 15.0;
  boolean isOperate;
  final float SLOT_SPEED = 10.0;

  IP_LocateEnclosure()
  {
    super(80);
  }

  void init()
  {
    hamada = new IP_Locate();
    enclosure = new PShape[5];
    enclosure[0] = loadShape("models/IP_Slot/IP_Slot_body.obj");
    for(int i = 0; i < 4; i++)
    {
      enclosure[i+1] = loadShape("models/IP_Slot/IP_Slot_slot_" + i + ".obj");
    }

    // スロットの画像をロード
    slotImages = new PImage[4];
    for(int i = 0; i < slotImages.length; i++)
    {
      slotImages[i] = loadImage("models/IP_Slot/Reel" + (i+1) + ".png");
    }

    // スロットのスクリーンテクスチャを作成
    slotScreens = new PGraphics[4];
    for(int i = 0; i < slotScreens.length; i++)
    {
      slotScreens[i] = createGraphics(SLOT_SCREEN_WIDTH, 300, P2D);
      slotScreens[i].beginDraw();
      slotScreens[i].image(slotImages[i], 0, 0, SLOT_SCREEN_WIDTH, SLOT_SCREEN_WIDTH * 6);
      slotScreens[i].endDraw();
    }

    slotImagePos = new float[4][2];
    for(int i = 0; i < slotImagePos.length; i++)
    {
      slotImagePos[i][0] = -SLOT_SCREEN_WIDTH * 6;
    }

    // スロットのスクリーンを作成
    PVector[][] slotsVertices = new PVector[][] {
      {
        new PVector(-18.059147, 10.350000, 26.269325),
        new PVector(-18.059147, 5.750000, 26.269325), 
        new PVector(-18.646862, 10.350000, 28.385897),
        new PVector(-18.646862, 5.750000, 28.385897),
        new PVector(-18.710430, 10.350000, 30.581623),
        new PVector(-18.710430, 5.750000, 30.581623),
        new PVector(-18.246145, 10.350000, 32.728649),
        new PVector(-18.246145, 5.750000, 32.728649),
        new PVector(-17.281050, 10.350000, 34.701939),
        new PVector(-17.281050, 5.750000, 34.701939),
        new PVector(-15.871344, 10.350000, 36.386578),
        new PVector(-15.871344, 5.750000, 36.386578)
      },
      {
        new PVector(-18.059147, 4.599999, 26.269325),
        new PVector(-18.059147, -0.000000, 26.269325),
        new PVector(-18.646862, 4.599999, 28.385897),
        new PVector(-18.646862, -0.000000, 28.385897),
        new PVector(-18.710430, 4.599999, 30.581623),
        new PVector(-18.710430, -0.000000, 30.581623),
        new PVector(-18.246145, 4.599999, 32.728649),
        new PVector(-18.246147, -0.000000, 32.728649),
        new PVector(-17.281050, 4.599999, 34.701939),
        new PVector(-17.281052, -0.000000, 34.701939),
        new PVector(-15.871344, 4.599999, 36.386578),
        new PVector(-15.871345, -0.000001, 36.386578)
      },
      {
        new PVector(-18.059147, -1.150000, 26.269325),
        new PVector(-18.059147, -5.750000, 26.269325),
        new PVector(-18.646862, -1.150000, 28.385897),
        new PVector(-18.646862, -5.750000, 28.385897),
        new PVector(-18.710430, -1.150000, 30.581623),
        new PVector(-18.710430, -5.750000, 30.581623),
        new PVector(-18.246147, -1.150000, 32.728649),
        new PVector(-18.246147, -5.750000, 32.728649),
        new PVector(-17.281052, -1.150000, 34.701939),
        new PVector(-17.281052, -5.750000, 34.701939),
        new PVector(-15.871345, -1.150000, 36.386578),
        new PVector(-15.871345, -5.750000, 36.386578)
      },
      {
        new PVector(-18.059147, -6.900001, 26.269325),
        new PVector(-18.059147, -11.500000, 26.269325),
        new PVector(-18.646862, -6.900001, 28.385897),
        new PVector(-18.646862, -11.500000, 28.385897),
        new PVector(-18.710430, -6.900001, 30.581623),
        new PVector(-18.710430, -11.500000, 30.581623),
        new PVector(-18.246147, -6.900001, 32.728649),
        new PVector(-18.246147, -11.500000, 32.728649),
        new PVector(-17.281052, -6.900001, 34.701939),
        new PVector(-17.281052, -11.500000, 34.701939),
        new PVector(-15.871345, -6.900001, 36.386578),
        new PVector(-15.871345, -11.500001, 36.386578)
      }
    };

    slots = new PShape[4];
    textureMode(NORMAL);
    for(int i = 0; i < slotsVertices.length; i++)
    {
      slots[i] = createShape();

      slots[i].beginShape(TRIANGLE_STRIP);
      slots[i].noStroke();
      slots[i].texture(slotScreens[i]);
      for(int j = 0; j < slotsVertices[i].length; j++)
      {
        PVector loopv = slotsVertices[i][j];
        slots[i].vertex(loopv.x - Util.DELTA_POSITION, loopv.y, loopv.z, (j%2 == 0) ? 1.0 : 0.0 , map(j/2, 0, slotsVertices[i].length/2, 1.0, 0.0));
      }
      slots[i].endShape();
    }

    // スクリーンの方向ベクトル
    screenDirection.set(1.0, 0.0, 0.0);
    // スクリーンの中心位置
    screenCenter = new PVector(-27.0, 0.0, 34.0);

    // 施設の向いている方向
    frontDirection.set(-1.0, 0.0, 0.0);

    isOperate = false;
  }

  void update()
  {
    hamada.run(); // 処理なし

    position.x = INIT_POS_CENTER;

    drawSlot();
  }

  void draw(PGraphics _tg)
  {
    _tg.resetShader();
    _tg.pushMatrix();

    _tg.translate(INIT_POS, 0, 0);
    _tg.shape(enclosure[0]);
    
    for(PShape slot : slots)
    {
      _tg.shape(slot);
    }

    _tg.translate(INIT_POS_CENTER - INIT_POS, 0.0, 0.0);
    drawShadow(_tg);

    _tg.popMatrix();
    _tg.shader(currentShader);
  }


  // ボタン入力取得関数
  void control(Player _player)
  {
    if(isActivated)
    {
      int A = _player.BUTTON_NAME_TO_INDEX.get("A");
      if(_player.buttonPressed[A] != _player.prevButtonPressed[A])
      {
        if(_player.buttonPressed[A])
        {
          if(isOperate)
          {
            isOperate = false;
            String[] ip = hamada.returnIP();
            float slotIPPosUnit = (SLOT_SCREEN_WIDTH * 6 / 8);
            float center = slotIPPosUnit * 3;
            for(int i = 0; i < slotImagePos.length; i++)
            {
              int ipNum = int(ip[i]);
              switch(ipNum)
              {
                case 7:
                slotImagePos[i][0] = -slotIPPosUnit * 3 + center;
                break;

                case 126:
                switch(i)
                {
                  case 0:
                  slotImagePos[i][0] = -slotIPPosUnit * 4 + center;
                  break;

                  case 1:
                  slotImagePos[i][0] = -slotIPPosUnit * 0 + center;
                  break;

                  case 2:
                  slotImagePos[i][0] = -slotIPPosUnit * 2 + center;
                  break;

                  case 3:
                  slotImagePos[i][0] = -slotIPPosUnit * 7 + center;
                  break;
                }
                break;

                case 223:
                switch(i)
                {
                  case 0:
                  slotImagePos[i][0] = -slotIPPosUnit * 6 + center;
                  break;

                  case 1:
                  slotImagePos[i][0] = -slotIPPosUnit * 1 + center;
                  break;

                  case 2:
                  slotImagePos[i][0] = -slotIPPosUnit * 4 + center;
                  break;

                  case 3:
                  slotImagePos[i][0] = -slotIPPosUnit * 1 + center;
                  break;
                }
                break;

                case 2:
                switch(i)
                {
                  case 0:
                  slotImagePos[i][0] = -slotIPPosUnit * 0 + center;
                  break;

                  case 1:
                  slotImagePos[i][0] = -slotIPPosUnit * 2 + center;
                  break;

                  case 2:
                  slotImagePos[i][0] = -slotIPPosUnit * 7 + center;
                  break;

                  case 3:
                  slotImagePos[i][0] = -slotIPPosUnit * 5 + center;
                  break;
                }
                break;

                case 91:
                switch(i)
                {
                  case 0:
                  slotImagePos[i][0] = -slotIPPosUnit * 2 + center;
                  break;

                  case 1:
                  slotImagePos[i][0] = -slotIPPosUnit * 7 + center;
                  break;

                  case 2:
                  slotImagePos[i][0] = -slotIPPosUnit * 0 + center;
                  break;

                  case 3:
                  slotImagePos[i][0] = -slotIPPosUnit * 0 + center;
                  break;
                }
                break;

                case 193:
                switch(i)
                {
                  case 0:
                  slotImagePos[i][0] = -slotIPPosUnit * 1 + center;
                  break;

                  case 1:
                  slotImagePos[i][0] = -slotIPPosUnit * 4 + center;
                  break;

                  case 2:
                  slotImagePos[i][0] = -slotIPPosUnit * 1 + center;
                  break;

                  case 3:
                  slotImagePos[i][0] = -slotIPPosUnit * 6 + center;
                  break;
                }
                break;

                case 23:
                switch(i)
                {
                  case 0:
                  slotImagePos[i][0] = -slotIPPosUnit * 5 + center;
                  break;

                  case 1:
                  slotImagePos[i][0] = -slotIPPosUnit * 5 + center;
                  break;

                  case 2:
                  slotImagePos[i][0] = -slotIPPosUnit * 5 + center;
                  break;

                  case 3:
                  slotImagePos[i][0] = -slotIPPosUnit * 4 + center;
                  break;
                }
                break;

                case 180:
                switch(i)
                {
                  case 0:
                  slotImagePos[i][0] = -slotIPPosUnit * 7 + center;
                  break;

                  case 1:
                  slotImagePos[i][0] = -slotIPPosUnit * 6 + center;
                  break;

                  case 2:
                  slotImagePos[i][0] = -slotIPPosUnit * 6 + center;
                  break;

                  case 3:
                  slotImagePos[i][0] = -slotIPPosUnit * 2 + center;
                  break;
                }
                break;
              }
              slotImagePos[i][1] = slotImagePos[i][0] + SLOT_SCREEN_WIDTH * 6;
            }
          }
          else
          {
            isOperate = true;
            for(int i = 0; i < slotImagePos.length; i++)
            {
              slotImagePos[i][0] = -SLOT_SCREEN_WIDTH * 6;
              slotImagePos[i][1] = 0.0;
            }
          }
        }
      }

      int B = _player.BUTTON_NAME_TO_INDEX.get("B");
      if(_player.buttonPressed[B] != _player.prevButtonPressed[B])
      {
        if(_player.buttonPressed[B])
        {
          isActivated = false;
        }
      }
    }
  }


  // スロットの描画
  void drawSlot()
  {
    if(!isActivated) {return;}
    for(int i = 0; i < slotScreens.length; i++)
    {
      if(SLOT_SCREEN_WIDTH * 6 < slotImagePos[i][0])
      {
        slotImagePos[i][0] = -SLOT_SCREEN_WIDTH * 6 - (SLOT_SCREEN_WIDTH * 6 - slotImagePos[i][0]);
      }
      if(SLOT_SCREEN_WIDTH * 6 < slotImagePos[i][1])
      {
        slotImagePos[i][1] = -SLOT_SCREEN_WIDTH * 6 - (SLOT_SCREEN_WIDTH * 6 - slotImagePos[i][1]);
      }

      slotScreens[i].imageMode(CORNER);
      slotScreens[i].beginDraw();
      slotScreens[i].image(slotImages[i], 0, slotImagePos[i][0], SLOT_SCREEN_WIDTH, SLOT_SCREEN_WIDTH * 6);
      slotScreens[i].image(slotImages[i], 0, slotImagePos[i][1], SLOT_SCREEN_WIDTH, SLOT_SCREEN_WIDTH * 6);
      slotScreens[i].endDraw();

      if(isOperate)
      {
        slotImagePos[i][0] += SLOT_SPEED;
        slotImagePos[i][1] += SLOT_SPEED;
      }
    }
  }


  // 外部スクリーンに出力
  PImage outputImage()
  {
    final int USE_INFO_INDEX = 1;
    String ipLocateData = hamada.getData();
    String[] ipInformations = split(ipLocateData, ", ");
    String locationURL = ipInformations[USE_INFO_INDEX].replaceAll(" ", "%20");

    XML photozou = loadXML("https://api.photozou.jp/rest/search_public.xml?keyword=" + locationURL);
    if(photozou == null) {return null;}

    XML[] photo = photozou.getChild("info").getChildren("photo");
    if(photo == null || photo.length <= 0) {return null;}

    PImage locateImg = loadImage(photo[floor(random(photo.length))].getChild("image_url").getContent());

    /*
    PGraphics sc = createGraphics(locateImg.width, locateImg.height, P2D);
    sc.beginDraw();
    sc.fill(#ffffff);
    sc.textSize(70 * (float(locateImg.width) / 1280));
    sc.text(ipInformations[USE_INFO_INDEX], 0, 0);
    sc.endDraw();
    */

    return locateImg;
  }

}
