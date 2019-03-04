/*
説明:IPアドレスを決定し、その場所やデータをwebAPIでXMLから読み込みStringで返すクラス
*/

class IP_Locate extends CompoBase<String> {
  
  String [] ip;//IPアドレスを4分割したもの
  String IP_adress; //IPアドレス
  XML IP_locate; //地域特定用XML
  XML WeatherMap; //天気取得用XML
  XML TimeDifference; //時差取得用XML
  String country; //国
  String regionName; //州
  String city; //地域
  String lon; //経度
  String lat; //緯度
  String timezone; //タイムゾーン
  String weather; //現在の天気
  float tem_value; //現在の気温
  int r;//IPアドレス決定用の変数
  int hour;
  int minute;
  //init()内でIPアドレスを設定
  boolean init() {
    ip = new String [4];
    for(int x=0;x<ip.length;x++)ip[x]="7";
    IP_adress=ip[0]+"."+ip[1]+"."+ip[2]+"."+ip[3];
    return true;
  }

  void run() {
  }
  
  String[] returnIP(){
    setIP();
    return ip;
  }
  
  void setIP(){
    for(int x=0;x<ip.length;x++){
      r=(int)random(9);
      if(r==0)ip[x]="7";
      if(r==1)ip[x]="126";
      if(r==2)ip[x]="223";
      if(r==3)ip[x]="2";
      if(r==4)ip[x]="91";
      if(r==5)ip[x]="193";
      if(r==6)ip[x]="23";
      if(r==7)ip[x]="180";
    }
    IP_adress=ip[0]+"."+ip[1]+"."+ip[2]+"."+ip[3];
  }
  
  String getData() {
    IP_locate = loadXML("http://ip-api.com/xml/"+IP_adress);
    country=IP_locate.getChild("country").getContent();
    regionName=IP_locate.getChild("regionName").getContent();
    city=IP_locate.getChild("city").getContent();
    timezone=IP_locate.getChild("timezone").getContent();
    lon=IP_locate.getChild("lon").getContent();
    lat=IP_locate.getChild("lat").getContent();
    TimeDifference=loadXML("http://api.timezonedb.com/v2.1/convert-time-zone?key=H4JIXH80SBSF&format=xml&from=Asia/Tokyo&to="+timezone+"");
    minute=int(TimeDifference.getChild("offset").getContent());
    WeatherMap = loadXML("http://api.openweathermap.org/data/2.5/weather?lon="+lon+"&lat="+lat+"&APPID=ffb844a2d0c13eb1cfd09869315bd064&units=metric&mode=xml");
    tem_value=WeatherMap.getChild("temperature").getFloat("value");
    weather=WeatherMap.getChild("weather").getString("value");
    hour=(24+hour()+minute/3600)%24;
    minute=(60+minute()-(minute/60)%60)%60;
    String data = IP_adress+", "+country+", "+regionName+", "+city+", "+hour+":"+minute+", "+timezone+", "+lon+", "+lat+", "+weather+", "+tem_value;
    return data;
  }
}
