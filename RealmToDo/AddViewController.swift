//
//  AddViewController.swift
//  RealmToDo
//
//  Created by nakazy on 2015/05/07.
//  Copyright (c) 2015年 nakazy. All rights reserved.
//

import UIKit

// 紹介済み
protocol AddViewControllerDelegate {
    func didFinishTypingText(typedText: String?)
}

// テキストフィールドを扱うので UITextFieldDelegate プロトコルを適合させる
class AddViewController: UIViewController, UITextFieldDelegate {
    var textField: UITextField?
    var newItemText: String?
    var delegate: AddViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setupTextField()
        setupNavigationBar()
    }
    
    // view が表示されたとき
    // インスタンス生成じゃないので、表示されたあとに処理なのでユーザーが思う view 表示と同じタイミング
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // FirstResponder ってなんだ
        // http://glayash.blogspot.jp/2012/09/iosfirstresponder.html
        // 曰く、「ファーストレスポンダとは、Cocoaにおいてフォーカスが当たっているGUI要素のことです。そしてタッチ以外のイベントを、最初に受け取ることになるオブジェクトです。」
        // テキストフィールドを FirstResponder にしている
        textField?.becomeFirstResponder()
    }
    
    func setupTextField() {
        // CGRectZero とは
        // http://temping-amagramer.blogspot.jp/2011/03/ioscgrectzero.html
        // 「(0,0)地点で、大きさと長さがそれぞれ0の値を指定している定数だそうです。」
        textField = UITextField(frame: CGRectZero)
        // プレースホルダーっていうのは最初に書いてある文字
        // ユーザーが入力をすると消える
        textField?.placeholder = "Type in item"
        // デリゲートは自身で行う
        textField?.delegate = self
        // そして view に加える
        view.addSubview(textField!)
    }
    
    func setupNavigationBar() {
        // done ボタンを追加してる
        // 押されると self の doneAction が発火される
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneAction")
    }
    
    // オーバーライドっていうのはスーパークラスで定義した関数をサブクラスで定義し直すこと
    // これつけてないとコンパイラがエラーを吐く
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // textField を (11, self.topLayoutGuide.length + 50) の位置に
        // 横幅 view.frame.size.width - 22, 縦 100 としている
        textField?.frame = CGRectMake(11, self.topLayoutGuide.length + 50, view.frame.size.width - 22, 100)
    }
    
    func doneAction() {
        delegate?.didFinishTypingText(textField?.text)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        doneAction()
        textField.resignFirstResponder()
        return true
    }
    
}
