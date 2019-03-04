// Processing VR
// VR World System with Processing.
// 2018/12/12 - 2019/01/17

import java.util.Deque;
import java.util.ArrayDeque;
import processing.serial.*;
import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;
import java.util.Map;
import java.util.TreeMap;


// Constants
final PVector RESOLUTION = new PVector(1024, 600);
final PVector DEBUG_SCREEN_RESOLUTION = new PVector(300, RESOLUTION.y);
final boolean DEBUG = false; // デバッグモードの起動フラグ
final boolean USE_6_DOF_SENSOR = true; // センサー使用フラグ
final boolean USE_JOY_CON_R_CONTROLLER = true; // コントローラーの使用フラグ

// Instances
final String PORT = "/dev/cu.usbmodem14601";
Serial sensorPort;
float sensorR;
float sensorP;
float sensorY;
boolean sensorReady = false;
float sensorOffsetR;
float sensorOffsetP;
float sensorOffsetY;
PGraphics rightScreen;
PGraphics leftScreen;
PGraphics debugInfoScreen; // P3Dモード有効時に起こるtextが表示されないバグへの対処: https://github.com/processing/processing/issues/2482
Deque<String> debugInfo;

World world;
PShader currentShader;


// 初期化以前処理
void settings()
{
  if(DEBUG)
  {
    size(int(RESOLUTION.x), int(RESOLUTION.y), P3D);
  }
  else
  {
    fullScreen(P3D);
  }

  smooth(2);
}

// 初期化処理
void setup()
{
  // Modes
  rectMode(CENTER);
  
  // Instances
  if(USE_6_DOF_SENSOR)
  {
    sensorPort = new Serial(this, PORT, 9600);
    sensorPort.bufferUntil('\n');
  }
  rightScreen = createGraphics(width / 2, height, P3D);
  leftScreen = createGraphics(width / 2, height, P3D);
  if(DEBUG)
  {
    debugInfoScreen = createGraphics(int(DEBUG_SCREEN_RESOLUTION.x), int(DEBUG_SCREEN_RESOLUTION.y), P2D);
    debugInfo = new ArrayDeque<String>();
  }

  world = new World(this);
  currentShader = world.worldShader;
}

// 更新処理
void draw()
{
  // Update sequence.

  world.update();
  
  
  // Draw sequence.
  beginRight();
  world.draw(rightScreen);
  endRight();

  beginLeft();
  world.draw(leftScreen);
  endLeft();
  
  // Draw debug infomation.
  if(DEBUG)
  {
    drawDebugInfo();
  }
}

// シリアルポートイベント
void serialEvent(Serial _port)
{
  if(USE_6_DOF_SENSOR)
  {
    String rpyStr = _port.readStringUntil('\n');
    if(rpyStr != null)
    {
      rpyStr = trim(rpyStr);

      float rpy[] = float(split(rpyStr, ','));
      if(rpy.length != 3) {return;}
      if(181 < abs(rpy[0]) || 181 < abs(rpy[1]) || 181 < abs(rpy[2])) {return;}

      if(!sensorReady)
      {
        sensorOffsetR = rpy[0];
        sensorOffsetP = rpy[1];
        sensorOffsetY = rpy[2];
        
        sensorReady = true;
      }

      sensorR = rpy[0] - sensorOffsetR;
      sensorP = rpy[1] - sensorOffsetP;
      sensorY = rpy[2] - sensorOffsetY;
      
      pushDebugInfo("SensorRPY: {" + sensorR + ", " + sensorP + ", " + sensorY + "}");
    }
  }
}


// 右画面の開始処理
void beginRight()
{
  rightScreen.beginDraw();
  rightScreen.background(#83A5D4);
  rightScreen.translate(width/2, height/2, 0);

  world.begin(rightScreen, false);
}

// 左画面の開始処理
void beginLeft()
{
  leftScreen.beginDraw();
  leftScreen.background(#83A5D4);
  leftScreen.translate(width/2, height/2, 0);

  world.begin(leftScreen, true);
}

// 右画面の描画処理
void endRight()
{
  rightScreen.endCamera();
  rightScreen.resetShader();
  
  rightScreen.endDraw();
  
  image(rightScreen, width/2, 0);
}

// 左画面の描画処理
void endLeft()
{
  leftScreen.endCamera();
  leftScreen.resetShader();
  
  leftScreen.endDraw();
  
  image(leftScreen, 0, 0);
}


// デバッグ情報の表示
void drawDebugInfo()
{ 
  debugInfo.push("fps: " + nf(frameRate, 2, 2));
  
  debugInfoScreen.beginDraw();
  debugInfoScreen.clear();
  debugInfoScreen.noStroke();
  debugInfoScreen.fill(10, 150);
  debugInfoScreen.rect(0, 0, DEBUG_SCREEN_RESOLUTION.x, DEBUG_SCREEN_RESOLUTION.y);
  debugInfoScreen.fill(#FFFFFF);
  debugInfoScreen.textSize(10);

  int yPos = 0;
  final int verticalSpaceSize = 15;

  debugInfoScreen.textAlign(LEFT, TOP);
  while(!debugInfo.isEmpty())
  {
    debugInfoScreen.text(debugInfo.poll(), 0, yPos);
    yPos += verticalSpaceSize;
  }

  debugInfoScreen.endDraw();

  image(debugInfoScreen, 0, 0);
}


// デバッグ画面に表示する項目の追加
void pushDebugInfo(String _msg)
{
  if(DEBUG)
  {
    debugInfo.push(_msg);
  }
}
