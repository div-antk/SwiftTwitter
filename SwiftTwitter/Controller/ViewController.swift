//
//  ViewController.swift
//  SwiftTwitter
//
//  Created by Takuya Ando on 2021/01/19.
//

import UIKit
import BubbleTransition
import Firebase

class FeedItem {
    var meigen:String!
    var auther:String!
}

class ViewController: UIViewController, XMLParserDelegate, UIViewControllerTransitioningDelegate {
    
    var userName = String()
    
    @IBOutlet weak var meigenLabel: UILabel!
    
    // プラスボタン
    @IBOutlet weak var toFeedButton: UIButton!
    
    let db = Firestore.firestore()
    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    var parser = XMLParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ボタンを丸くする
        toFeedButton.layer.cornerRadius = toFeedButton.frame.width/2
        
        // ナビゲーションバーを消す
        self.navigationController?.isNavigationBarHidden = true
        
        // XML解析を行う
        let url = "http://meigen.doodlenote.net/api?c=1"
        let urlToSend = URL(string: url)
        parser = XMLParser(contentsOf: urlToSend!)!
        parser.delegate = self
        parser.parse()
    }
    
    @IBAction func share(_ sender: Any) {
        
    }
    
    
    @IBAction func sendData(_ sender: Any) {
        // Firestoreで値を保存する
        if let quote = meigenLabel.text, let userName = Auth.auth()
    }
    
}

