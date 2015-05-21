//
//  ViewController.swift
//  RealmToDo
//
//  Created by nakazy on 2015/05/07.
//  Copyright (c) 2015年 nakazy. All rights reserved.
//

import UIKit

// はい ジャンプしてきました
// ViewController というファイル名だけど、このリポジトリでは ToDoItem, ViewController クラスが定義されていた。
// まずは ViewController クラスを読む

// RLMObject は Realm で基本となるモデル型
class ToDoItem: RLMObject {
    // DB に保存したいプロパティには dynamic をつける
    // 変数の初期値がそのままデータの初期値になる
    // name と finished というプロパティを持つ
    // ToDo アプリなので達成したかどうかの finished ってこと
    // すごく短く直感的にモデルを書ける！
    // 54 行目へジャンプ
    dynamic var name = ""
    dynamic var finished = false
}

// UIViewController は ViewController なので当然 UIViewController を適合
// TableView を表示するために、TableView に必要な UITableViewDelegate, UITableViewDataSource も適合する
// AddViewControllerDelegate は AddViewController.swift に書かれている。短いのでここに掲載する。
//
// protocol AddViewControllerDelegate {
//     func didFinishTypingText(typedText: String?)
// }
//
// これを適合したクラスは必ず didFinishTypingText メソッドを実装しなさい！ ということ
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddViewControllerDelegate {
    // tableView 型の変数宣言
    private var tableView: UITableView!

    // メインというべき Realm オブジェクトの登場
    // ちなみに今回はライブラリのインストール方法的に、 import Realm とする必要はない
    // RLMResults とは自動で状態を更新してくれる Container 型（Array, Dictionary 型といったものの総称）
    // リファレンス
    // http://realm.io/docs/objc/latest/api/Classes/RLMResults.html
    var todos: RLMResults {
        // getter
        // todos プロパティにアクセスすると以下のブロックの内容が返るようになる
        // 分からなかったら以下のページの計算型プロパティのところを見る
        // http://tea-leaves.jp/swift/content/%E3%83%97%E3%83%AD%E3%83%91%E3%83%86%E3%82%A3
        get {
            // predicate は叙述関数という意味のようで真偽値を返すということ
            // ここでは ToDoItem の中から predicate にマッチするものだけをリターンする目的
            // ToDoItem を読みに行こう 15行目へ
            // ToDoItem に使用する Predicate でプロパティである finished が false であるかを条件としている
            // argumentArray は条件のパターンを入れる配列。nil になっている。
            // 省略可能なので省略したほうがいいと思う
            let predicate = NSPredicate(format: "finished == false", argumentArray: nil)
            // ToDoItem の objectsWithPredicate を使ってる
            // predicate にマッチしたものが返ってくる
            // http://realm.io/docs/objc/latest/api/Classes/RLMObject.html#//api/name/objectsWithPredicate:
            return ToDoItem.objectsWithPredicate(predicate)
        }
    }
    
    var finished: RLMResults {
        get {
            // todos と一緒
            // こっちは finished が true のものを取る
            let predicate = NSPredicate(format: "finished == true", argumentArray: nil)
            return ToDoItem.objectsWithPredicate(predicate)
        }
    }
    // そのまま viewDidLoad() へ
    
    // view がインスタンス化された直後に一度だけ実行される
    // view のライフサイクルの詳細については以下のページへ
    // http://blog.livedoor.jp/sasata299/archives/52029262.html
    override func viewDidLoad() {
        // 親クラスである UIViewController の viewDidLoad を呼ぶ
        super.viewDidLoad()
        // AppDelegate の window のときの UITableView 版
        // (0, 0) 座標から width, height とともに画面いっぱいの TableView を生成する
        // self.view について
        // スーパークラスである UIViewController で定義してある
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        // tableView に対してセル（行ごとの項目）を登録する
        // 第一引数に セルとなるクラス、第二引数にセルの識別子とする文字列を取る
        // 標準の UITableViewCell のクラスのオブジェクトを与えている
        // クラスオブジェクトを取得するには UITableViewCell.self のように、クラス名にの後に.selfを付ける
        // forCellReuseIdentifier はやっておくと該当するセルを再利用してくれるので、やってなくてセルたくさんで重くて困る、っていう事態にならなくてよい
        // 再利用っていうことがどういうことかというと画面外になったセルインスタンスの中身を再利用先の内容に変更して表示するっていうこと
        // 
        // このへんで tableview の解説に飛んだほうがいいかも
        //
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        // delegate となるクラスを自身にしている これは UITableViewDelegate を適合したクラスを入れる
        tableView.delegate = self
        // dataSource もそう
        tableView.dataSource = self
        // view にサブビューとして 作ってきた tableView を加える
        // iOS は ViewController の1枚の view に対して小さな Subview を連ねて画面を構成していく解釈で合ってるかな（？）
        self.view.addSubview(tableView)
        // 103 行目 setupNavigationBar メソッドにジャンプ
        setupNavigationBar()
    }
    
    
    func setupNavigationBar() {
        // navigationItem はスーパークラスである UIViewController で定義されている
        // rightBarButtonItem と leftBarButtonItem があって UIBarButton 型のオブジェクト
        // barButtonSystemItem: .Add はシステムで用意されている Add ボタンを使うっていうこと
        // ここ見ると よいっぽい http://www.lancork.net/2014/12/ios-uibarbuttonsystemitem-icon-images/
        // .Add は UIBarButtonSystemItem.Add が省略されている
        //
        // なぜ省略できるの？
        //
        // target: self は押されたときにどのオブジェクトで action を受け取るか
        // action: "addButtonAction" なので、このボタンが押されたとき self つまり ViewController の addButtonAction() メソッドが呼ばれる
        // 115 行目へ
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonAction")
    }
    
    func addButtonAction() {
        // AddViewController を生成している
        // nib は Next Interface Builder の略で、StoryBoard で見られる GUI で画面を構築するもの
        // 今回は使っていないので nil
        // bundle っていうのはリソース管理の仕組み
        // NSBundle オブジェクトでいろいろする
        // 使ったことないので雑な紹介
        let addViewController = AddViewController(nibName: nil, bundle: nil)
        // delegate 先を self にする
        // delegate についての説明はまだ怖い感じなので
        // よそに「移譲」したい
        // iOS 開発における delegate の実装は以下を参照してほしい
        // http://qiita.com/osamu1203/items/6dedc01e3b975a0ceec4
        addViewController.delegate = self
        // 上で生成した addViewCotnroller を元にして UINavigationController を作る
        let navController = UINavigationController(rootViewController: addViewController)
        // navController の view に遷移する
        // animated 引数は文字通りアニメーションするかどうか
        // true にすると表示する view が下からせり上がってくる
        // completion 引数には指定した ViewController が表示した後、実行させたいコードブロックを渡す
        // 引数も戻り値も取らない
        // completion: {
        //     println("presented!")
        // }
        // みたいに書いたらいい
        // 表示する ViewController の viewDidAppear で処理したらいいじゃん！って思ったけど
        // この present の文脈で実行したい場合だけのコードを書くっていう感じか
        presentViewController(navController, animated: true, completion: nil)
    }
    
    // TableView のセクションの数を返す
    // Todo セクションと finished セクションと 2 つ
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    // 以下に tableView メソッドが多くあるけど、それがいつ実行されるものなのか分かってなくて
    // 解説がふわふわしてる
    
    // tableView っていう名前のメソッドはいくつも定義する必要がある
    // 以下のものは numberOfRowsInSection という引数を持つもので各セクションごとの行数を返す
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // この switch section はお決まりのパターンっぽい
        // この section っていう値がちょっと謎だったので試しに以下のコードをコメントアウトして挿れてみた
        // println(section)
        // println("-- tableView --")
        // すると
        // 1
        // -- tableView --
        // 0
        // -- tableView --
        // 1
        // -- tableView --
        // 0
        // -- tableView --
        // 1
        // -- tableView --
        // 0
        // -- tableView --
        // と出力された
        // まあこうやってセクションのセルは返すってこと
        switch section {
        case 0:
            return Int(todos.count)
        case 1:
            return Int(finished.count)
        default:
            return 0
        }
    }
    
    // titleForHeaderInSection を引数に持つものは 各セクションのタイトルを返す
    // 上とだいたい一緒
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "To do"
        case 1:
            return "Finished"
        default:
            return ""
        }
    }
    
    // cellForRowAtIndexPath を持つものはセル（行の要素）を返す
    // 戻り値の型で一目瞭然
    // cellForRowAtIndexPath は実行されたときに注目しているセルの行数が入るみたい
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルを取ってくる
        // 生成するだけじゃなくて再利用なセルがあればそれを取ってくる
        // 再利用するセルは 第一引数に渡した identifier 文字列で識別する
        // forIndexPath に indexPath を入れて、何行目にあたるセルかという情報を渡している
        // indexPath について知識不足
        // as! にエクスクラメーションマークがついているのはダウンキャストをするときには付けるみたい
        // ダウンキャストというのは元々の型のサブクラスへキャストすること
        // 型変換が失敗するおそれがある
        // 今回は関数定義で戻り値を UITableViewCell 型としているのでそれにキャストする
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        // セクションのお決まりパターン
        // section プロパティにセクション番号が入っていて
        // そのセクションのときの個数はもう指定してあるから、その個数回分 このメソッドが実行されているんだと思う
        switch indexPath.section {
        case 0:
            // 未遂の Todo の方
            // todos っていう Realm Object の集合である RLMResults オブジェクトから indexPath.row とインデックスを照らしあわせて取得してる
            // objectAtIndex については Realm ライブラリの RLMResults.h に記述してある
            // /**
            // Returns the object at the index specified.
            //
            // @param index   The index to look up.
            //
            // @return An RLMObject of the class contained by this RLMResults.
            // */
            // - (id)objectAtIndex:(NSUInteger)index;
            // つまり NSUInteger 型でインデックス番号を渡せば RLMResults の中からそのインデックス番号のオブジェクトを取ってきてくれる
            // UInteger は負数を取らない。インデックス番号も負数になることはないのでそうしているのかな
            let todoItem = todos.objectAtIndex(UInt(indexPath.row)) as! ToDoItem
            // NSMutableAttributedString っていうのはいろいろ装飾できる String クラスだそう
            // このアプリでは finished した Todo に打ち消し線を入れていて、そのために使う
            var attributedText = NSMutableAttributedString(string: todoItem.name)
            // addAttribute で装飾を加える
            // Strikethrough っていうのは打ち消し線のこと
            // NSStrikethroughStyleAttributeName については以下 少しスクロールすると書いてある
            // https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/NSAttributedString_UIKit_Additions/index.html#//apple_ref/doc/constant_group/Character_Attributes
            // value は指定した Attribute（ここでは NSStrikethroughStyleAttributeName）のどんな装飾にするか
            // 打ち消し線といってもいろいろある。太線とか細線とか
            // ここでは value: 0 なので線は描画されない
            // 描画されないなら指定する必要あるのかな？ と思うけどセルの再利用の際にスムーズに再利用するためかもしれない（憶測です）
            // Strikethrough にどんなスタイルがあるかは以下を見る
            // case の上から value の 0, 1, 2... と対応している
            // https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/NSAttributedString_UIKit_Additions/index.html#//apple_ref/c/tdef/NSUnderlineStyle
            //
            // range ではどの範囲まで装飾を付けるかをしていしている
            // わざわざ NSRange っていうオブジェクトを生成してるのめんどくせって思う
            // NSMakeRange(開始位置, 終了位置) ってなっててこれだと 0 文字目から attributedText の文字数までを取っていて
            // attributedText 全体の範囲になるってこと
            attributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 0, range: NSMakeRange(0, attributedText.length))
            // 入れる
            cell.textLabel!.attributedText = attributedText
        case 1:
            // 終わった Todo である finished を描画するセクション
            // 装飾以外やってること同じ
            let todoItem = finished.objectAtIndex(UInt(indexPath.row)) as! ToDoItem
            var attributedText = NSMutableAttributedString(string: todoItem.name)
            // case 0 だと value が 0 になってて線がなかったけどこちらは value が 1 で一本線がひかれる
            attributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributedText.length))
            cell.textLabel!.attributedText = attributedText
        default:
            break
        }
        return cell
    }
    
    // セルが選択されたとき、つまりタップされた時の処理
    // タップされたとき、Todo が finished になるように、finished が Todo になるように処理していく
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // なんでここオプショナル型なんだろう？
        var todoItem: ToDoItem?
        
        switch indexPath.section {
        case 0:
            todoItem = todos.objectAtIndex(UInt(indexPath.row)) as? ToDoItem
        case 1:
            todoItem = finished.objectAtIndex(UInt(indexPath.row)) as? ToDoItem
        default:
            break
        }

        // Realm データベースにアクセスするためのオブジェクトを生成
        let realm = RLMRealm.defaultRealm()
        // トランザクションでブロック内を実行する
        // トランザクションっていうのはその中を一連として行うってことで
        // 例えば A を保存するコードと B を保存するコードをトランザクションとして
        // A を保存することに成功したけど B は保存できなかった場合、A を保存したことを取り消す
        // そのブロックがすべてが問題なく実行されたことを保証するもの
        realm.transactionWithBlock() {
            // todoと finished のトグル
            // todo!.finished の逆、true なら false, false なら true を代入するってこと
            todoItem?.finished = !todoItem!.finished
        }
        
        // テーブルの更新処理
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            var todoItem: ToDoItem?
            
            switch indexPath.section {
            case 0:
                todoItem = todos.objectAtIndex(UInt(indexPath.row)) as? ToDoItem
            case 1:
                todoItem = finished.objectAtIndex(UInt(indexPath.row)) as? ToDoItem
            default:
                break
            }
            
            let realm = RLMRealm.defaultRealm()
            realm.transactionWithBlock() {
                // 削除もらくだねー
                realm.deleteObject(todoItem)
            }
            tableView.reloadData()
        }
    }
    
    // 渡ってきたテキストが空でなければ新たな Todo として追加する
    func didFinishTypingText(typedText: String?) {
        if typedText != "" {
            
            let newTodoItem = ToDoItem()
            newTodoItem.name = typedText!
            
            let realm = RLMRealm.defaultRealm()
            realm.transactionWithBlock() {
                realm.addObject(newTodoItem)
            }
            
            // テーブルの更新処理
            tableView.reloadData()
        }
    }
}

