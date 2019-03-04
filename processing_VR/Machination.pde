// Akatsuka.pde
// 赤塚さんの担当クラス（提出時にコメントがなかったため、深谷が代筆）
// 1-3-02 赤塚真仁


class Machination {
  PImage img=loadImage("models/monitor/worldmap.png");
  int []eX=new int[8];
  int []eY=new int[8];
  int []pop=new int[8];
  int []eco=new int[8];
  int []cli=new int[8];
  int []saf=new int[8];
  boolean []jug=new boolean[8];
  int word;

  PGraphics tg;
  final int MOVE_INTERVAL = 100;
  int lastMoveTime;

  Machination() {
    eX[0]=475;
    eX[1]=500;
    eX[2]=600;
    eX[3]=125;
    eX[4]=200;
    eX[5]=1050;
    eX[6]=1250;
    eX[7]=650;
    eY[0]=150;
    eY[1]=300;
    eY[2]=500;
    eY[3]=175;
    eY[4]=375;
    eY[5]=300;
    eY[6]=500;
    eY[7]=275;
    pop[0]=146000000;
    pop[1]=1300000000;
    pop[2]=24000000;
    pop[3]=63000000;
    pop[4]=90000000;
    pop[5]=320000000;
    pop[6]=200000000;
    pop[7]=125000000;
    eco[0]=4;
    cli[0]=1;
    saf[0]=3;
    eco[1]=4;
    cli[1]=2;
    saf[1]=2;
    eco[2]=2;
    cli[2]=3;
    saf[2]=3;
    eco[3]=4;
    cli[3]=4;
    saf[3]=3;
    eco[4]=2;
    cli[4]=2;
    saf[4]=3;
    eco[5]=4;
    cli[5]=3;
    saf[5]=3;
    eco[6]=2;
    cli[6]=3;
    saf[6]=1;
    eco[7]=4;
    cli[7]=4;
    saf[7]=4;
    word=19;

    lastMoveTime = 0;
  }

  void display() {
    tg.image(img, 0, 0);
    tg.strokeWeight(3);
    tg.fill(255);
    for (int i=0; i<8; i++) {
      for (int j=0; j<8; j++) {
        if (j!=i) {
          tg.line(eX[i], eY[i], eX[j], eY[j]);
        }
      }
    }
    for (int i=0; i<8; i++) {
      tg.ellipse(eX[i], eY[i], 125, 125);
    }
    tg.textSize(word);
    tg.fill(0);
    for (int i=0; i<8; i++) {
      tg.text(pop[i], eX[i]-60, eY[i]);
    }
    tg.text("Russia", eX[0]-50, eY[0]+20);
    tg.text("China", eX[1]-50, eY[1]+20);
    tg.text("Australia", eX[2]-50, eY[2]+20);
    tg.text("England", eX[3]-50, eY[3]+20);
    tg.text("Egypt", eX[4]-50, eY[4]+20);
    tg.text("America", eX[5]-50, eY[5]+20);
    tg.text("Brazil", eX[6]-50, eY[6]+20);
    tg.text("Japan", eX[7]-50, eY[7]+20);
    tg.text("Russia", 1324, 20);
    tg.text("China", 1324, 120);
    tg.text("Australia", 1324, 220);
    tg.text("England", 1324, 320);
    tg.text("Egypt", 1324, 420);
    tg.text("America", 1324, 520);
    tg.text("Brazil", 1324, 620);
    tg.text("Japan", 1324, 720);
    for (int i=0; i<8; i++) {
      tg.fill(255, 0, 0);
      tg.text("ECO", 1344, 39+100*i);
      tg.fill(0, 255, 0);
      tg.text("CLI", 1344, 58+100*i);
      tg.fill(0, 0, 255);
      tg.text("SAF", 1344, 77+100*i);
    }
    for (int i=0; i<8; i++) {
      for (int j=0; j<5; j++) {
        if (eco[i]>j) {
          tg.fill(255, 0, 0);
        } else {
          tg.noFill();
        }
        tg.rect(1400+25*j, 23+100*i, 15, 15);
        if (cli[i]>j) {
          tg.fill(0, 255, 0);
        } else {
          tg.noFill();
        }
        tg.rect(1400+25*j, 42+100*i, 15, 15);
        if (saf[i]>j) {
          tg.fill(0, 0, 255);
        } else {
          tg.noFill();
        }
        tg.rect(1400+25*j, 61+100*i, 15, 15);
      }
    }
  }

  void move() {
    if(millis() - lastMoveTime < MOVE_INTERVAL) {return;}

    for (int i=0; i<8; i++) {
      int temp=eco[i]+cli[i]+saf[i];
      int max=(int)random(1, 16);
      if (max>temp) {
        jug[i]=false;
      } else {
        jug[i]=true;
      }
      if (jug[i]==false&&pop[i]>0) {
        temp=(int)random(8);
        if (temp!=i) {
          pop[i]-=1000000;
          pop[temp]+=1000000;
        }
      }
    }

    lastMoveTime = millis();
  }

  void mousepress() {
    for (int i=0; i<8; i++) {
      for (int j=0; j<5; j++) {
        if (mouseX>1400+25*j&&mouseX<1400+25*j+15&&mouseY>23+100*i&&mouseY<23+100*i+15) {
          eco[i]=j+1;
        }
        if (mouseX>1400+25*j&&mouseX<1400+25*j+15&&mouseY>42+100*i&&mouseY<42+100*i+15) {
          cli[i]=j+1;
        }
        if (mouseX>1400+25*j&&mouseX<1400+25*j+15&&mouseY>61+100*i&&mouseY<61+100*i+15) {
          saf[i]=j+1;
        }
      }
    }
  }
}
