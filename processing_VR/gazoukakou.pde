//gazoukakou_sisikuikenn.pde
//画像加工を実装
//1-3-53 Yoshida Ayano
//2019/01/14

class gazoukakou extends CompoBase<PImage> {
  PGraphics tg;
  PGraphics innerTg;
  PImage[] source_image;
  PImage exp_image;
  String[] strExp;
  int currentImageIndex;
  int [] button;//フィルターの写真の配列
  int [] button2;//フィルターの強度の配列
  int [] prevButton;//buttonの1ループ前の配列
  int [] prevButton2;//button2の1ループ前の配列
  int a=2;
  float b;
  int c;//加工の強度の初期値
  int verticalPos;//ボタンの縦
  int horizontalPos;  //ボタンの横横
  final int STICK_INTERVAL = 10;
  int intervalStart;

  boolean init() {
    button=new int [5];
    button2=new int [5];
    prevButton=new int [5];
    prevButton2=new int [5];
    verticalPos = 0;
    horizontalPos = 0;
    button[0]=1;
    button2[0]=1;

    innerTg = createGraphics(1200, 800, P2D);
    strExp = new String[] {
      "https://img.furusato-tax.jp/img/x/product/detail/forms/20171018/sd1_db1626e1bb33e3caa645872a853b1006bf849414.jpg",
      "http://japanism.info/images/hamburger-free-photo1.jpg",
      "https://www.pakutaso.com/shared/img/thumb/C824_choko3_TP_V.jpg",
      "https://d1f5hsy4d47upe.cloudfront.net/35/35ce0cedf846f526268298bed40759bb_t.jpeg",
      "https://d1f5hsy4d47upe.cloudfront.net/9f/9f0968c8895b728b39c8091dda143a95_t.jpeg",
      "http://sozaing.com/wp-content/uploads/img150404_5-540x360.jpg.pagespeed.ce.5ixmkJppwK.jpg",
      "https://www.pakutaso.com/shared/img/thumb/C789_unitoikuramaguro_TP_V.jpg"//元の写真の配列
     };
    source_image = new PImage[7]; //<>//
    for(int i = 0; i < source_image.length; i++)
    {
      source_image[i] = loadImage(strExp[i]);//画像をダウンロード
    }
    currentImageIndex = 0;
    imageInit(currentImageIndex);
    return true;
  }

  void imageInit(int _index) {
    if(source_image.length <= _index)
    {
      println("gazoukakou_sisikuikenn.imageInit(): ArrayIndexOutOfBounds.");
      return;
    }
    exp_image = source_image[_index].copy();//加工する画像をダウンロード
    currentImageIndex = _index;
  }


  void run() {
    innerTg.beginDraw();
    innerTg.background(#000000);
    innerTg.image( exp_image, 200, 100, 400, 300 );
    exp_image= source_image[currentImageIndex].copy();
    kyoudo();
    this.filter();

    innerTg.strokeWeight(3);
    for (int i=0; i<5; i=i+1) {
      innerTg.stroke(0);
      if (verticalPos == 0 && i == horizontalPos) {//フィルターの列
        innerTg.stroke(0, 255, 0);//動かしている場所が分かるようにした
      }
      if (button[i]==1) {
        innerTg.fill(255, 0, 0);//選択したボタンを赤く表示
      } else {
        innerTg.fill(255);
      }
      innerTg.ellipse(i*200+200, 200+300, 100, 100);
    }

    for (int i=0; i<5; i=i+1) {
      innerTg.stroke(0);
      if (verticalPos == 1 && i == horizontalPos) {//強度の列
        innerTg.stroke(0, 255, 0);//選択した場所が分かるようにした
      }
      if (button2[i]==1) {
        innerTg.fill(255, 0, 0);//選択したボタンを赤く表示
      } else {
        innerTg.fill(255);
      }
      innerTg.ellipse(i*200+200, 200+500, 100, 100);
    }

    if (button[0]==1||button[4]==1) {//無加工とINVERTのとき
      for (int i=0; i<5; i=i+1) {
        innerTg.fill(255, 0, 0);//強度のすべてのボタンを赤く表示
        innerTg.ellipse(i*200+200, 200+500, 100, 100);
      }
    }
    innerTg.fill(255);
    innerTg.textSize(24);
    innerTg.text ("FILTER", 35, 520);
    innerTg.text ("STRENGTH", 15, 720);

    innerTg.endDraw();

    tg.image(innerTg, 0, 0, tg.width - 200, tg.height);
  }

  PImage getData() {
    return exp_image.copy();
  }




  void kyoudo() {//フィルターの強度を変える関数
    if (button[1]==1) {

      if (button2[0]==1) {//POSTERIZEの強度
        a=10;
      } else if (button2[1]==1) {
        a=8;
      } else if (button2[2]==1) {
        a=6;
      } else if (button2[3]==1) {
        a=4;
      } else if (button2[4]==1) {
        a=2;
      }
    } else if (button[2]==1) {//THRESHOLDの強度
      if (button2[0]==1) {
        b=0.2;
      } else if (button2[1]==1) {
        b=0.4;
      } else if (button2[2]==1) {
        b=0.6;
      } else if (button2[3]==1) {
        b=0.8;
      } else if (button2[4]==1) {
        b=1;
      }
    } else if (button[3]==1) {//BLURの強度
      if (button2[0]==1) {
        c=1;
      } else if (button2[1]==1) {
        c=2;
      } else if (button2[2]==1) {
        c=3;
      } else if (button2[3]==1) {
        c=4;
      } else if (button2[4]==1) {
        c=5;
      }
    } else {
    }
  }

  void filter() {
    if (button[0]==1) {
    } else if (button[1]==1) {
      exp_image.filter(POSTERIZE, a);//POSTERIZEのフィルター
    } else if (button[2]==1) {

      exp_image.filter(THRESHOLD, b);//THRESHOLDのフィルター
    } else if (button[3]==1) {

      exp_image.filter(BLUR, c);//BLURのフィルター
    } else if (button[4]==1) {
      exp_image.filter(INVERT);//INVERTのフィルター
    }
  }


  boolean buttonPressed(Player _player) {
    if(1.0 < float(frameCount - intervalStart) / STICK_INTERVAL)
    {
      switch(_player.stickPos)
      {
      case 4: // UP 選択しているボタンを上にずらす
        verticalPos = (verticalPos+1) % 2;
        intervalStart = frameCount;
        break;

      case 8: // DOWN　選択しているボタンを下にずらす
        verticalPos = (verticalPos-1) % 2;
        if(verticalPos < 0) {
          verticalPos = 1;
        }
        intervalStart = frameCount;
        break;

      case 2: // LEFT　選択しているボタンを左にずらす
        horizontalPos = (horizontalPos - 1) % 5;
        if(horizontalPos < 0) {
          horizontalPos = 4;
        }
        intervalStart = frameCount;
        break;

      case 6: // RIGHT　選択しているボタンを右にずらす
        horizontalPos = (horizontalPos + 1) % 5;
        intervalStart = frameCount;
        break;
      }
    }
    
    int A = _player.BUTTON_NAME_TO_INDEX.get("A");//コントローラーのAボタンを押したとき
    if(_player.buttonPressed[A] != _player.prevButtonPressed[A])
    {
      if (_player.buttonPressed[A])
      {
        if (verticalPos % 2 == 0)
        {
          for (int i = 0; i < button.length; i++)
          {
            button[i] = 0;
          }
          button[horizontalPos] = 1;
        } else
        {
          for (int i = 0; i < button2.length; i++)
          {
            button2[i] = 0;
          }
          button2[horizontalPos] = 1;
        }
      }
    }
    
    int B = _player.BUTTON_NAME_TO_INDEX.get("B");//コントローラーのBボタンを押したとき
    if(_player.buttonPressed[B] != _player.prevButtonPressed[B])
    {
      if(_player.buttonPressed[B])
      {
        return true;
      }
    }
    
    int X = _player.BUTTON_NAME_TO_INDEX.get("X");//コントローラーのXボタンを押したとき
    if(_player.buttonPressed[X] != _player.prevButtonPressed[X])
    {
      if(_player.buttonPressed[X])
      {
        imageInit((currentImageIndex + 1) % source_image.length);
      }
    }
    return false;
  }
}
