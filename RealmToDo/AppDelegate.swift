//
//  AppDelegate.swift
//  RealmToDo
//
//  Created by nakazy on 2015/05/07.
//  Copyright (c) 2015年 nakazy. All rights reserved.
//

// import <ライブラリ名>
// UIKit は iOS で画面構築するためのコンポーネント群ライブラリ
// UI~ って名前のオブジェクトは UIKit により提供されているもの（たぶん）
import UIKit

// エントリポイント
// AppDelegate が UIApplicationMain という注釈で、
// iOS アプリ起動時は UIApplicationMain に指定されているクラスでウインドウが描画されていれば、とりあえず起動して画面は表示される
// ウインドウを描画していなければ真っ暗の画面で立ち上がる
// UIResponder, UIAppliationDelegate プロトコルを適合している

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // window 定義
    // <T>? となっているのでオプショナル型（ T は Type ）
    // nil を許すということだけれど window が nil となるときってどういうときだろう
    var window: UIWindow?

    // 起動後に実行される
    // application 引数: UIApllication はシングルトンで、アプリ全体で同じ application 変数
    // didFinishLaunchingOptions 引数: アプリがどのように起動したかを辞書型で持つ
    //   どのよう起動とは、シンプルにホーム画面からアイコンタップか、通知から起動したか、とかとか
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // UIWindow を生成
        // bounds が何かと見に行くと var bounds: CGRect { get } で { get } の意味が分からなかった
        // シミュレータを 5s で起動する
        // println(UIScreen.mainScreen().bounds) => (0.0, 0.0, 320.0, 568.0)
        // スクリーンの開始座標と画面サイズが返ってくる
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // window の rootViewController に UINavigationController を代入（そのまんま）
        // window はオプショナル型で nil を許すけれど nil にプロパティは設定できない
        // よって エクスクラメーション(!)マークをつけ、オプショナル型から UIWindow 型に変換し扱う（これをアンラップと言う）
        // ViewController オブジェクトを UINavigationController として代入
        // このメソッドあとちょっとなので ViewController を保留して残りを見ていく
        self.window!.rootViewController = UINavigationController(rootViewController: ViewController())
        
        // メインウインドウ, Cocoa に則っていうと Key Window として登録する
        // Key Window はユーザーからの入力を受け付けるウインドウということ
        // https://codeiq.jp/magazine/2014/05/9493/ を後半のほうを見ると分かりやすい
        self.window!.makeKeyAndVisible()
        
        // 公式ドキュメントに
        // return value
        // false if the app cannot handle the URL resource or continue a user activity, otherwise return true. The return value is ignored if the app is launched as a result of a remote notification.
        
        // とある。
        // URL リソースっていうものがどういうのか分からないけど、例外的な場合以外は true を返せばよい
        return true
        
        // 46 行目で使われている ViewController() を見に行く
        // ViewController.swift へジャンプ
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

