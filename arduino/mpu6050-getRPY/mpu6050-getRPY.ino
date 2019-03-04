// MPU6050のロール、ピッチ、ヨーの値をシリアルポート9600bpsで取得

#include <Wire.h>
#include <MPU6050_6Axis_MotionApps20.h>
#include <MadgwickAHRS.h>

// キャリブレーションの結果を以下の6定数に入れる
const int GYRO_X = -92;
const int GYRO_Y = 16;
const int GYRO_Z = 35;
const int ACCEL_X = -3550;
const int ACCEL_Y = 1838;
const int ACCEL_Z = 838;

MPU6050 mpu;
static uint8_t mpuIntStatus;
static bool dmpReady = false;
static uint16_t packetSize;

float ypr[3];           // [yaw, pitch, roll]

const int MPU_ADDRESS = 0x68;
Madgwick filter;
int16_t axRaw, ayRaw, azRaw, gxRaw, gyRaw, gzRaw, temperature;
float ax, ay, az;
float gx, gy, gz;
float roll, pitch, yaw;
unsigned long lastReadTime = 0;
const unsigned long READ_INTERVAL = 10;


// 初期化
void setup()
{
  Serial.begin(9600);
  Wire.begin();
  Wire.setClock(400000L); // fast mode.
  initMPU();
  filter.begin(100);
}

// メインループ
void loop()
{
  if(READ_INTERVAL < millis() - lastReadTime)
  {
    getMPURaw();

    ax = convertRawAcceleration(axRaw);
    ay = convertRawAcceleration(ayRaw);
    az = convertRawAcceleration(azRaw);
    gx = convertRawGyro(gxRaw);
    gy = convertRawGyro(gyRaw);
    gz = convertRawGyro(gzRaw);

    filter.updateIMU(gx, gy, gz, ax, ay, az);

    roll = filter.getRoll();
    pitch = filter.getPitch();
    yaw = filter.getYaw();

    lastReadTime += READ_INTERVAL;

    Serial.print(roll, 4);
    Serial.print(',');
    Serial.print(pitch, 4);
    Serial.print(',');
    Serial.print(yaw, 4);
    Serial.print('\n');
  }
}

// MPU6050の生データを取得
void getMPURaw()
{
  mpu.getMotion6(&axRaw, &ayRaw, &azRaw, &gxRaw, &gyRaw, &gzRaw);
}

// MPU6050の初期化
// https://gist.github.com/Taikono-Himazin/54c435d0ff1d109b54bf92c751715cf6#file-mpu6050
void initMPU() 
{
  mpu.initialize();
  if (mpu.testConnection() != true)
  {
    Serial.println("MPU disconection");
    while (true) {}
  }
  if (mpu.dmpInitialize() != 0)
  {
    Serial.println("MPU break");
    while (true) {}
  }
  
  // Low-pass filter設定
  Wire.beginTransmission(MPU_ADDRESS);
  Wire.write(0x1A);
  Wire.write(0b00000101);
  Wire.endTransmission();
  
  mpu.setXGyroOffset(GYRO_X);
  mpu.setYGyroOffset(GYRO_Y);
  mpu.setZGyroOffset(GYRO_Z);
  mpu.setXAccelOffset(ACCEL_X);
  mpu.setYAccelOffset(ACCEL_Y);
  mpu.setZAccelOffset(ACCEL_Z);
  mpu.setDMPEnabled(true);
  mpuIntStatus = mpu.getIntStatus();
  dmpReady = true;
  packetSize = mpu.dmpGetFIFOPacketSize();
}

// 加速度の値を調整
// https://platformio.org/lib/show/689/Madgwick/examples
float convertRawAcceleration(int aRaw)
{
  // since we are using 2G range
  // -2g maps to a raw value of -32768
  // +2g maps to a raw value of 32767
  
  float a = (aRaw * 2.0) / 32768.0;
  return a;
}

// ジャイロの値を調整
// https://platformio.org/lib/show/689/Madgwick/examples
float convertRawGyro(int gRaw)
{
  // since we are using 250 degrees/seconds range
  // -250 maps to a raw value of -32768
  // +250 maps to a raw value of 32767
  
  float g = (gRaw * 250.0) / 32768.0;
  return g;
}
