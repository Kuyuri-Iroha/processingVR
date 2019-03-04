// 班員向けの施設の基底クラス


// 部品の基底クラス
// 必ずこのクラスを継承してクラスを作ってください
// また、DataClassと書いてある部分には自分のアウトプットしたいデータ型を定義する
//（intならCompoBase<int>, 自作したOriginDataクラスのようなクラスならCompoBase<OriginData>のようにする）
// また、このクラスは継承しない限りインスタンス化できないので注意。
abstract class CompoBase <DataClass>
{
  boolean enable; // 初期化に成功したか、失敗したかを記録
  
  CompoBase()
  {
    enable = init();
  }
  
  // 下のabstractと書かれた関数はオーバーライド（上書き）しなければエラーを吐くので注意。
  
  // 初期化関数
  // 初期化に成功したら true を 失敗したら false を返す
  abstract boolean init();
  
  // 更新関数
  // draw関数のなかで毎回行いたい処理
  abstract void run();
  
  
  // データ取得関数
  // 継承時に指定したデータ型を返す
  abstract DataClass getData();
}
